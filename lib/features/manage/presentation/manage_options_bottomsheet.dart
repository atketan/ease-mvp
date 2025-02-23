import 'package:ease/features/customers/presentation/customers_page.dart';
import 'package:ease/features/expense_categories/presentation/expense_categories_landing_page.dart';
import 'package:ease/features/items/presentation/items_page.dart';
import 'package:ease/features/vendors/presentation/vendors_page.dart';
import 'package:flutter/material.dart';

class ManageOptionsBottomsheet extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => ManageOptionsBottomsheetState();
}

class ManageOptionsBottomsheetState extends State<ManageOptionsBottomsheet> {
  final List<Map<String, dynamic>> _menuItems = [
    {
      'title': 'Customers',
      'subtitle': 'Sales',
      'icon': Icons.people,
      'page': CustomersPage(),
    },
    {
      'title': 'Suppliers',
      'subtitle': 'Purchases',
      'icon': Icons.store,
      'page': VendorsPage(),
    },
    {
      'title': 'Items',
      'subtitle': 'Inventory',
      'icon': Icons.inventory_2,
      'page': ItemsPage(),
    },
    // Add more menu items here for 3x3 grid
    {
      'title': 'Expense',
      'subtitle': 'Categories',
      'icon': Icons.bar_chart,
      'page': ExpenseCategoriesLandingPage(),
    },
    {
      'title': 'Reports',
      'subtitle': 'Analytics',
      'icon': Icons.bar_chart,
      'page': null,
    },
    {
      'title': 'Settings',
      'subtitle': 'Configuration',
      'icon': Icons.settings,
      'page': null,
    },
    // {
    //   'title': 'Export',
    //   'subtitle': 'Data',
    //   'icon': Icons.download,
    //   'page': null,
    // },
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: GridView.count(
        crossAxisCount: 3,
        mainAxisSpacing: 8.0,
        crossAxisSpacing: 8.0,
        children: _menuItems.map((item) {
          return InkWell(
            onTap: () {
              if (item['page'] != null) {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => item['page'],
                  ),
                );
              } else {
                Navigator.of(context).pop();
                // Show a snackbar or toast message
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Coming soon!'),
                  ),
                );
              }
            },
            child: Card(
              elevation: 1,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    item['icon'],
                    size: 32,
                    color: Theme.of(context).primaryColor,
                  ),
                  SizedBox(height: 8),
                  Text(
                    item['title'],
                    style: Theme.of(context).textTheme.titleSmall,
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    item['subtitle'],
                    style: Theme.of(context).textTheme.bodySmall,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}