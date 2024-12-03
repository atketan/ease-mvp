import 'package:ease/features/expense_categories/presentation/expense_categories_landing_page.dart';
import 'package:flutter/material.dart';

class ReportsLandingPage extends StatefulWidget {
  @override
  _ReportsLandingPageState createState() => _ReportsLandingPageState();
}

class _ReportsLandingPageState extends State<ReportsLandingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Reports'),
      ),
      body: ListView(
        children: [
          ListTile(
            title: Text('Expense Categories'),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => ExpenseCategoriesLandingPage(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
