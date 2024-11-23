import '../../models/expense_category.dart';
import '../database_helper.dart';
import 'expense_categories_data_source.dart';

class SqfliteExpenseCategoriesDAO implements ExpenseCategoriesDataSource {
  final DatabaseHelper _databaseHelper = DatabaseHelper();

  @override
  Future<int> insertExpenseCategory(ExpenseCategory category) async {
    final db = await _databaseHelper.database;
    return await db.insert('ExpenseCategories', category.toJSON());
  }

  @override
  Future<List<ExpenseCategory>> getAllExpenseCategories() async {
    final db = await _databaseHelper.database;
    final List<Map<String, dynamic>> maps = await db.query('ExpenseCategories');
    return List.generate(maps.length, (i) => ExpenseCategory.fromJSON(maps[i]));
  }

  @override
  Future<int> updateExpenseCategory(ExpenseCategory category) async {
    final db = await _databaseHelper.database;
    return await db.update('ExpenseCategories', category.toJSON(),
        where: 'id = ?', whereArgs: [category.id]);
  }

  @override
  Future<int> deleteExpenseCategory(String expenseId) async {
    final db = await _databaseHelper.database;
    return await db
        .delete('ExpenseCategories', where: 'id = ?', whereArgs: [expenseId]);
  }
}
