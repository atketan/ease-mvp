import 'dart:async';
import 'package:ease_mvp/core/database/customers_dao.dart';
import 'package:ease_mvp/core/models/customer.dart';
import 'package:ease_mvp/features/customers/presentation/update_customers_page.dart';
import 'package:flutter/material.dart';

class CustomersPage extends StatefulWidget {
  @override
  _CustomersPageState createState() => _CustomersPageState();
}

class _CustomersPageState extends State<CustomersPage> {
  List<Customer> _allCustomers = [];
  final _customersDAO = CustomersDAO();
  final _streamController = StreamController<List<Customer>>();

  @override
  void initState() {
    super.initState();
    _fetchCustomers();
  }

  void _fetchCustomers() async {
    final customers = await _customersDAO.getAllCustomers();
    setState(() {
      _allCustomers = customers;
    });
    _streamController.add(customers);
  }

  void _filterCustomers(String query) {
    final filtered = _allCustomers.where((customer) {
      final nameLower = customer.name.toLowerCase();
      final queryLower = query.toLowerCase();
      return nameLower.contains(queryLower);
    }).toList();

    _streamController.add(filtered);
  }

  @override
  void dispose() {
    _streamController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Customers'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context)
                  .push(
                    MaterialPageRoute(
                      builder: (_) => UpdateCustomersPage(
                        mode: CustomersFormMode.Add,
                      ),
                    ),
                  )
                  .then(
                    (value) => _fetchCustomers(),
                  );
            },
            child: Text('Add'),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onChanged: (value) {
                _filterCustomers(value);
              },
              decoration: InputDecoration(
                labelText: 'Filter by Name',
                border: OutlineInputBorder(),
              ),
            ),
          ),
          Expanded(
            child: StreamBuilder<List<Customer>>(
              stream: _streamController.stream,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final customers = snapshot.data!;
                  return ListView.builder(
                    itemCount: customers.length,
                    itemBuilder: (context, index) {
                      final customer = customers[index];
                      return ListTile(
                        title: Text(
                          customer.name,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Text("Address: ${customer.address}"),
                            Text(
                              "Phone No.: ${customer.phone}",
                              style: Theme.of(context).textTheme.labelMedium,
                            ),
                            Text(
                              "Email: ${customer.email}",
                              style: Theme.of(context).textTheme.labelMedium,
                            )
                          ],
                        ),
                        trailing: IconButton(
                          onPressed: () {
                            Navigator.of(context)
                                .push(
                                  MaterialPageRoute(
                                    builder: (_) => UpdateCustomersPage(
                                      mode: CustomersFormMode.Edit,
                                      customerId: customer.id,
                                    ),
                                  ),
                                )
                                .then(
                                  (value) => _fetchCustomers(),
                                );
                          },
                          icon: Icon(Icons.edit),
                        ),
                        // Add other customer details here
                      );
                    },
                  );
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else {
                  return Center(child: CircularProgressIndicator());
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
