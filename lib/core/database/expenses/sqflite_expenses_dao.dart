import '../../models/expense.dart';
import '../database_helper.dart';
import 'expenses_data_source.dart';

class SqfliteExpensesDAO implements ExpensesDataSource {
  final DatabaseHelper _databaseHelper = DatabaseHelper();

  @override
  Future<int> insertExpense(Expense expense) async {
    final db = await _databaseHelper.database;
    return await db.insert('Expenses', expense.toJSON());
  }

  @override
  Future<List<Expense>> getAllExpenses() async {
    final db = await _databaseHelper.database;
    final List<Map<String, dynamic>> maps = await db.query('Expenses');
    return List.generate(maps.length, (i) => Expense.fromJSON(maps[i]));
  }

  @override
  Future<int> updateExpense(Expense expense) async {
    final db = await _databaseHelper.database;
    return await db.update('Expenses', expense.toJSON(),
        where: 'id = ?', whereArgs: [expense.id]);
  }

  @override
  Future<int> deleteExpense(String expenseId) async {
    final db = await _databaseHelper.database;
    return await db.delete('Expenses', where: 'id = ?', whereArgs: [expenseId]);
  }
}