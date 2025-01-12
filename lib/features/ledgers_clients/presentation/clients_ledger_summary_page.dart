import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ease/core/models/customer.dart';
import 'package:ease/core/database/customers/customers_dao.dart';
import 'package:ease/core/database/ledger/ledger_entry_dao.dart';

class ClientsLedgerSummaryPage extends StatefulWidget {
  @override
  _ClientsLedgerSummaryPageState createState() =>
      _ClientsLedgerSummaryPageState();
}

class _ClientsLedgerSummaryPageState extends State<ClientsLedgerSummaryPage> {
  late CustomersDAO _customersDAO;
  late LedgerEntryDAO _ledgerEntryDAO;
  String _searchText = '';

  @override
  Widget build(BuildContext context) {
    _customersDAO = Provider.of<CustomersDAO>(context);
    _ledgerEntryDAO = Provider.of<LedgerEntryDAO>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Customers'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onChanged: (value) {
                setState(() {
                  _searchText = value.toLowerCase();
                });
              },
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
                    return FutureBuilder<Map<String, double>>(
                      future: balancesFuture,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return ListTile(
                            title: Text(customer.name),
                            subtitle: Text('Phone: ${customer.phone}'),
                            trailing: CircularProgressIndicator(),
                          );
                        }
                        if (snapshot.hasError) {
                          return ListTile(
                            title: Text(customer.name),
                            subtitle: Text('Phone: ${customer.phone}'),
                            trailing: Text('Error'),
                          );
                        }
                        final balances = snapshot.data!;
                        return ListTile(
                          title: Text(customer.name),
                          subtitle: Text('Phone: ${customer.id}'),
                          trailing: Text(
                              'Total Received: ${balances['totalCredits']} \nTotal Paid: ${balances['totalDebits']} \nBalance: ${balances['balance']}'),
                        );
                      },
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
