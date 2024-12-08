import '../../models/expense.dart';

abstract class ExpensesDataSource {
  Future<String> insertExpense(Expense expense);
  Future<List<Expense>> getAllExpenses();
  Future<int> updateExpense(Expense expense);
  Future<int> deleteExpense(String expenseId);
}