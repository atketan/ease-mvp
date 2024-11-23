import '../../models/expense_category.dart';
import 'expense_categories_data_source.dart';

class ExpenseCategoriesDAO {
  final ExpenseCategoriesDataSource _dataSource;

  ExpenseCategoriesDAO(this._dataSource);

  Future<int> insertExpenseCategory(ExpenseCategory category) {
    return _dataSource.insertExpenseCategory(category);
  }

  Future<List<ExpenseCategory>> getAllExpenseCategories() {
    return _dataSource.getAllExpenseCategories();
  }

  Future<int> updateExpenseCategory(ExpenseCategory category) {
    return _dataSource.updateExpenseCategory(category);
  }

  Future<int> deleteExpenseCategory(String expenseId) {
    return _dataSource.deleteExpenseCategory(expenseId);
  }
}
