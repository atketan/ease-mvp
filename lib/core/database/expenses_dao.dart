import '../models/expense.dart';
import 'database_helper.dart';

class ExpensesDAO {
  final DatabaseHelper _databaseHelper = DatabaseHelper();

  Future<int> insertExpense(Expense expense) async {
    final db = await _databaseHelper.database;
    return await db.insert('Expenses', expense.toJSON());
  }

  Future<List<Expense>> getAllExpenses() async {
    final db = await _databaseHelper.database;
    final List<Map<String, dynamic>> maps = await db.query('Expenses');
    return List.generate(maps.length, (i) => Expense.fromJSON(maps[i]));
  }

  Future<int> updateExpense(Expense expense) async {
    final db = await _databaseHelper.database;
    return await db.update('Expenses', expense.toJSON(),
        where: 'id = ?', whereArgs: [expense.id]);
  }

  Future<int> deleteExpense(int id) async {
    final db = await _databaseHelper.database;
    return await db.delete('Expenses', where: 'id = ?', whereArgs: [id]);
  }
}
