import '../../models/expense.dart';
import 'expenses_data_source.dart';

class ExpensesDAO {
  final ExpensesDataSource _dataSource;

  ExpensesDAO(this._dataSource);

  Future<int> insertExpense(Expense expense) {
    return _dataSource.insertExpense(expense);
  }

  Future<List<Expense>> getAllExpenses() {
    return _dataSource.getAllExpenses();
  }

  Future<int> updateExpense(Expense expense) {
    return _dataSource.updateExpense(expense);
  }

  Future<int> deleteExpense(String expenseId) {
    return _dataSource.deleteExpense(expenseId);
  }
}