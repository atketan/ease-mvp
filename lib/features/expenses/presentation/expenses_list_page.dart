import 'package:ease/features/expenses/providers/expense_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../widgets/expense_form.dart';

class ExpensesListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<ExpensesProvider>(
      builder: (context, provider, child) {
        if (provider.expenses.isEmpty) {
          return Center(
            child: Text('No expenses found'),
          );
        }
        return ListView.builder(
          itemCount: provider.expenses.length,
          itemBuilder: (context, index) {
            final expense = provider.expenses[index];
            return ListTile(
              dense: true,
              leading: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    DateFormat('MMM').format(expense.createdAt),
                    style: Theme.of(context).textTheme.labelMedium,
                  ),
                  Text(
                    DateFormat('d').format(expense.createdAt),
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ],
              ),
              title: Text(expense.name ?? ''),
              subtitle: Text('#${expense.expenseNumber}'),
              trailing: Text(
                "₹" + expense.amount.toString(),
                style: Theme.of(context).textTheme.titleMedium!.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              onLongPress: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ExpenseForm(
                      expense: expense,
                    ),
                  ),
                );
              },
              // trailing: IconButton(
              //   icon: Icon(Icons.edit),
              //   onPressed: () {
              //   },
              // ),
            );
          },
        );
      },
    );
  }
}
