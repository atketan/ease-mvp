import '../models/invoice.dart';
import 'database_helper.dart';

class InvoicesDAO {
  final DatabaseHelper _databaseHelper = DatabaseHelper();

  Future<int> insertInvoice(Invoice invoice) async {
    final db = await _databaseHelper.database;
    return await db.insert('Invoices', invoice.toJSON());
  }

  Future<List<Invoice>> getAllInvoices() async {
    final db = await _databaseHelper.database;
    final List<Map<String, dynamic>> maps = await db.query('Invoices');
    return List.generate(maps.length, (i) => Invoice.fromJSON(maps[i]));
  }

  Future<int> updateInvoice(Invoice invoice) async {
    final db = await _databaseHelper.database;
    return await db.update('Invoices', invoice.toJSON(),
        where: 'id = ?', whereArgs: [invoice.id]);
  }

  Future<int> deleteInvoice(int id) async {
    final db = await _databaseHelper.database;
    return await db.delete('Invoices', where: 'id = ?', whereArgs: [id]);
  }
}
