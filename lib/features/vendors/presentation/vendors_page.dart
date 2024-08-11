import 'dart:async';
import 'package:ease_mvp/core/database/vendors_dao.dart';
import 'package:ease_mvp/core/models/vendor.dart';

import 'package:flutter/material.dart';

import 'update_vendors_page.dart';

class VendorsPage extends StatefulWidget {
  @override
  _VendorsPageState createState() => _VendorsPageState();
}

class _VendorsPageState extends State<VendorsPage> {
  List<Vendor> _allVendors = [];
  final _vendorsDAO = VendorsDAO();
  final _streamController = StreamController<List<Vendor>>();

  @override
  void initState() {
    super.initState();
    _fetchVendors();
  }

  void _fetchVendors() async {
    final vendors = await _vendorsDAO.getAllVendors();
    setState(() {
      _allVendors = vendors;
    });
    _streamController.add(vendors);
  }

  void _filtervendors(String query) {
    final filtered = _allVendors.where((vendor) {
      final nameLower = vendor.name.toLowerCase();
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
        title: Text('Vendors'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context)
                  .push(
                    MaterialPageRoute(
                      builder: (_) => UpdateVendorsPage(
                        mode: VendorsFormMode.Add,
                      ),
                    ),
                  )
                  .then(
                    (value) => _fetchVendors(),
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
                _filtervendors(value);
              },
              decoration: InputDecoration(
                labelText: 'Filter by Name',
                border: OutlineInputBorder(),
              ),
            ),
          ),
          Expanded(
            child: StreamBuilder<List<Vendor>>(
              stream: _streamController.stream,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final vendors = snapshot.data!;
                  return ListView.builder(
                    itemCount: vendors.length,
                    itemBuilder: (context, index) {
                      final vendor = vendors[index];
                      return ListTile(
                        title: Text(
                          vendor.name,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Text("Address: ${vendor.address}"),
                            Text(
                              "Phone No.: ${vendor.phone}",
                              style: Theme.of(context).textTheme.labelMedium,
                            ),
                            Text(
                              "Email: ${vendor.email}",
                              style: Theme.of(context).textTheme.labelMedium,
                            )
                          ],
                        ),
                        trailing: IconButton(
                          onPressed: () {
                            Navigator.of(context)
                                .push(
                                  MaterialPageRoute(
                                    builder: (_) => UpdateVendorsPage(
                                      mode: VendorsFormMode.Edit,
                                      vendorId: vendor.id,
                                    ),
                                  ),
                                )
                                .then(
                                  (value) => _fetchVendors(),
                                );
                          },
                          icon: Icon(Icons.edit),
                        ),
                        // Add other vendor details here
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
