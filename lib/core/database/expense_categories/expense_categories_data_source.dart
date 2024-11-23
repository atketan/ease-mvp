import '../../models/expense_category.dart';

abstract class ExpenseCategoriesDataSource {
  Future<int> insertExpenseCategory(ExpenseCategory category);
  Future<List<ExpenseCategory>> getAllExpenseCategories();
  Future<int> updateExpenseCategory(ExpenseCategory category);
  Future<int> deleteExpenseCategory(String expenseId);
}