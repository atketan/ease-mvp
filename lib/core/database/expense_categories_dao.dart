import '../models/expense_category.dart';
import 'database_helper.dart';

class ExpenseCategoriesDAO {
  final DatabaseHelper _databaseHelper = DatabaseHelper();

  Future<int> insertExpenseCategory(ExpenseCategory category) async {
    final db = await _databaseHelper.database;
    return await db.insert('ExpenseCategories', category.toJSON());
  }

  Future<List<ExpenseCategory>> getAllExpenseCategories() async {
    final db = await _databaseHelper.database;
    final List<Map<String, dynamic>> maps = await db.query('ExpenseCategories');
    return List.generate(maps.length, (i) => ExpenseCategory.fromJSON(maps[i]));
  }

  Future<int> updateExpenseCategory(ExpenseCategory category) async {
    final db = await _databaseHelper.database;
    return await db.update('ExpenseCategories', category.toJSON(),
        where: 'id = ?', whereArgs: [category.id]);
  }

  Future<int> deleteExpenseCategory(int id) async {
    final db = await _databaseHelper.database;
    return await db
        .delete('ExpenseCategories', where: 'id = ?', whereArgs: [id]);
  }
}
