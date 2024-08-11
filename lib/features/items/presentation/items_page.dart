import 'dart:async';

import 'package:ease_mvp/core/database/inventory_items_dao.dart';
import 'package:ease_mvp/core/models/inventory_item.dart';
import 'package:ease_mvp/features/items/presentation/update_items_page.dart';
import 'package:flutter/material.dart';

class ItemsPage extends StatefulWidget {
  @override
  ItemsPageState createState() => ItemsPageState();
}

class ItemsPageState extends State<ItemsPage> {
  List<InventoryItem> _allItems = [];
  final _itemsDAO = InventoryItemsDAO();
  final _streamController = StreamController<List<InventoryItem>>();

  @override
  void initState() {
    super.initState();
    _fetchItems();
  }

  void _fetchItems() async {
    final items = await _itemsDAO.getAllInventoryItems();
    setState(() {
      _allItems = items;
    });
    _streamController.add(items);
  }

  void _filterItems(String query) {
    final filtered = _allItems.where((vendor) {
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
        title: Text('Inventory Items'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context)
                  .push(
                    MaterialPageRoute(
                      builder: (_) => UpdateItemsPage(
                        mode: FormMode.Add,
                      ),
                    ),
                  )
                  .then(
                    (value) => _fetchItems(),
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
                _filterItems(value);
              },
              decoration: InputDecoration(
                labelText: 'Filter by Name',
                border: OutlineInputBorder(),
              ),
            ),
          ),
          Expanded(
            child: StreamBuilder<List<InventoryItem>>(
              stream: _streamController.stream,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final items = snapshot.data!;
                  return ListView.builder(
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      final item = items[index];
                      return ListTile(
                        title: Text(
                          item.name,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Text("Address: ${vendor.address}"),
                            Text(
                              "Unit: ${item.unit}",
                              style: Theme.of(context).textTheme.labelMedium,
                            ),
                            Text(
                              "Price: ${item.unitPrice.toString()}",
                              style: Theme.of(context).textTheme.labelMedium,
                            )
                          ],
                        ),
                        trailing: IconButton(
                          onPressed: () {
                            Navigator.of(context)
                                .push(
                                  MaterialPageRoute(
                                    builder: (_) => UpdateItemsPage(
                                      mode: FormMode.Edit,
                                      itemId: item.itemId,
                                    ),
                                  ),
                                )
                                .then(
                                  (value) => _fetchItems(),
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
