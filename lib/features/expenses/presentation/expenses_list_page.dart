import 'package:ease/features/expenses/providers/expense_provider.dart';
import 'package:ease/widgets/time_range_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../widgets/expense_form.dart';

class ExpensesListPage extends StatefulWidget {
  final TimeRangeProvider timeRangeProvider;

  ExpensesListPage({Key? key, required this.timeRangeProvider})
      : super(key: key);

  @override
  State<ExpensesListPage> createState() => _ExpensesListPageState();
}

class _ExpensesListPageState extends State<ExpensesListPage> {
  @override
  void initState() {
    super.initState();
    final expenseProvider =
        Provider.of<ExpensesProvider>(context, listen: false);
    expenseProvider.setDateRange(
      widget.timeRangeProvider.startDate,
      widget.timeRangeProvider.endDate,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ExpensesProvider>(
      builder: (context, expenseProvider, child) {
        // Listen to date range changes
        widget.timeRangeProvider.addListener(() {
          expenseProvider.setDateRange(
            widget.timeRangeProvider.startDate,
            widget.timeRangeProvider.endDate,
          );
        });

        if (expenseProvider.expenses.isEmpty) {
          return Center(
            child: Text('No expenses found'),
          );
        }
        return ListView.builder(
          itemCount: expenseProvider.expenses.length,
          itemBuilder: (context, index) {
            final expense = expenseProvider.expenses[index];
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
            );
          },
        );
      },
    );
  }
}
