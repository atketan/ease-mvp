import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ease/core/models/customer.dart';
import 'package:ease/core/database/customers/customers_dao.dart';
import 'package:ease/core/database/ledger/ledger_entry_dao.dart';
import 'dart:async';

class ClientsLedgerSummaryPage extends StatefulWidget {
  @override
  _ClientsLedgerSummaryPageState createState() =>
      _ClientsLedgerSummaryPageState();
}

class _ClientsLedgerSummaryPageState extends State<ClientsLedgerSummaryPage> {
  late CustomersDAO _customersDAO;
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
    _customersDAO = Provider.of<CustomersDAO>(context);
    _ledgerEntryDAO = Provider.of<LedgerEntryDAO>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Clients Ledger Summary'),
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
              stream: _customersDAO.getAllCustomersStream(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Center(child: Text('No customers found.'));
                }

                // Apply local filter to the Firestore stream elements
                final customers = snapshot.data!.docs
                    .map((doc) {
                      final customer =
                          Customer.fromJSON(doc.data() as Map<String, dynamic>);
                      customer.id = doc.id;
                      return customer;
                    })
                    .where((customer) =>
                        customer.name.toLowerCase().contains(_searchText))
                    .toList();

                return ListView.builder(
                  itemCount: customers.length,
                  itemBuilder: (context, index) {
                    final customer = customers[index];
                    final balancesFuture =
                        _ledgerEntryDAO.getLedgerSummary(customer.id!);
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
                              title: Text(customer.name),
                              subtitle: Text('Phone: ${customer.phone}'),
                              trailing: SizedBox(
                                child: CircularProgressIndicator(),
                              ),
                            );
                          }
                          if (snapshot.hasError) {
                            return ListTile(
                              title: Text(customer.name),
                              subtitle: Text('Phone: ${customer.phone}'),
                              trailing: SizedBox(
                                width: 175,
                                child: Text('Error'),
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
                            title: Text(
                              customer.name,
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            subtitle: Text('Phone: ${customer.phone}'),
                            trailing: SizedBox(
                              width: 175,
                              child: Text(
                                'Total Received: ₹${balances['totalCredits']} \nBalance: ₹${balances['balance']}', // 'Total Paid: ${balances['totalDebits']}'
                                style: Theme.of(context).textTheme.labelLarge,
                              ),
                            ),
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
