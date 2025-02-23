import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ease/core/database/vendors/vendors_dao.dart';
import 'package:ease/core/enums/transaction_category_enum.dart';
import 'package:ease/core/models/vendor.dart';
import 'package:ease/features/ledger_details/presentation/ledger_details_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ease/core/database/ledger/ledger_entry_dao.dart';
import 'dart:async';

class VendorsLedgerSummaryPage extends StatefulWidget {
  @override
  _VendorsLedgerSummaryPageState createState() =>
      _VendorsLedgerSummaryPageState();
}

class _VendorsLedgerSummaryPageState extends State<VendorsLedgerSummaryPage> {
  late VendorsDAO _vendorsDAO;
  late LedgerEntryDAO _ledgerEntryDAO;
  String _searchText = '';
  Timer? _debounce;

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  void _onSearchChanged(String value) {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(seconds: 2), () {
      setState(() {
        _searchText = value.toLowerCase();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    _vendorsDAO = Provider.of<VendorsDAO>(context);
    _ledgerEntryDAO = Provider.of<LedgerEntryDAO>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Suppliers Ledger Summary'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onChanged: _onSearchChanged,
              decoration: InputDecoration(
                labelText: 'Filter by Name',
                border: OutlineInputBorder(),
              ),
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _vendorsDAO.getAllVendorsStream(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Center(child: Text('No vendors found.'));
                }

                // Apply local filter to the Firestore stream elements
                final vendors = snapshot.data!.docs
                    .map((doc) {
                      final vendor =
                          Vendor.fromJSON(doc.data() as Map<String, dynamic>);
                      vendor.id = doc.id;
                      return vendor;
                    })
                    .where((vendor) =>
                        vendor.name.toLowerCase().contains(_searchText))
                    .toList();

                return ListView.builder(
                  itemCount: vendors.length,
                  itemBuilder: (context, index) {
                    final vendor = vendors[index];
                    final balancesFuture = _ledgerEntryDAO
                        .getLedgerSummaryByAssociatedId(vendor.id!);
                    return Card(
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      child: FutureBuilder<Map<String, double>>(
                        future: balancesFuture,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return ListTile(
                              title: Text(vendor.name),
                              subtitle: Text('Phone: ${vendor.phone}'),
                              trailing: SizedBox(
                                child: CircularProgressIndicator(),
                              ),
                            );
                          }
                          if (snapshot.hasError) {
                            return ListTile(
                              title: Text(vendor.name),
                              subtitle: Text('Phone: ${vendor.phone}'),
                              trailing: SizedBox(
                                width: 175,
                                child: Text('Error, ${snapshot.error}'),
                              ),
                            );
                          }
                          final balances = snapshot.data!;
                          return ListTile(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                            tileColor: (balances['balance']! > 0.0)
                                ? Colors.red[100]
                                : Theme.of(context).listTileTheme.tileColor,
                            onTap: () {
                              if (vendor.id != null) {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (_) => LedgerDetailsPage(
                                      associatedId: vendor.id!,
                                      transactionCategory:
                                          TransactionCategory.purchase,
                                      ledgerSummary: balances,
                                    ),
                                  ),
                                );
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Associate ID is missing.'),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                              }
                            },
                            title: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      vendor.name,
                                      style: Theme.of(context)
                                          .textTheme
                                          .labelLarge
                                          ?.copyWith(
                                              fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      'Phone: ${vendor.phone}',
                                      style: Theme.of(context)
                                          .textTheme
                                          .labelSmall,
                                    )
                                  ],
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    // SizedBox(
                                    //   width: 175,
                                    //   child: Text(
                                    //     'Total Paid: ₹${balances['totalDebits']} \nBalance: ₹${balances['balance']}', // 'Total Paid: ${balances['totalDebits']}'
                                    //     style:
                                    //         Theme.of(context).textTheme.labelMedium,
                                    //   ),
                                    // ),
                                    Text(
                                      'Balance',
                                      style: Theme.of(context)
                                          .textTheme
                                          .labelSmall,
                                    ),
                                    Text(
                                      '₹${balances['balance']}',
                                      style: Theme.of(context)
                                          .textTheme
                                          .labelLarge
                                          ?.copyWith(
                                              fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                )
                              ],
                            ),
                            trailing: Icon(Icons.arrow_right_outlined),
                          );
                        },
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
