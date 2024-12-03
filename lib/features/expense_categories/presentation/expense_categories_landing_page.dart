import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/expense_category_provider.dart';
import 'data/icon_data.dart';
import 'widgets/expense_category_form.dart';

class ExpenseCategoriesLandingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Expense Categories'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ExpenseCategoryForm(),
                ),
              );
            },
          ),
        ],
      ),
      body: Consumer<ExpenseCategoryProvider>(
        builder: (context, provider, child) {
          return ListView.builder(
            itemCount: provider.expenseCategories.length,
            itemBuilder: (context, index) {
              final category = provider.expenseCategories[index];
              return ListTile(
                leading: category.iconName != null
                    ? Icon(iconDataMap[category.iconName!])
                    : null,
                title: Text(category.name),
                // subtitle: Text(category.description ?? ''),
                trailing: IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ExpenseCategoryForm(
                          expenseCategory: category,
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
    );
  }
}
