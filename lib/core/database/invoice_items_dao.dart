import '../models/invoice_item.dart';
import 'database_helper.dart';

class InvoiceItemsDAO {
  final DatabaseHelper _databaseHelper = DatabaseHelper();

  Future<int> insertInvoiceItem(InvoiceItem invoiceItem) async {
    final db = await _databaseHelper.database;
    return await db.insert('InvoiceItems', invoiceItem.toJSON());
  }

  Future<List<InvoiceItem>> getAllInvoiceItems() async {
    final db = await _databaseHelper.database;
    final List<Map<String, dynamic>> maps = await db.query('InvoiceItems');
    return List.generate(maps.length, (i) => InvoiceItem.fromJSON(maps[i]));
  }

  Future<int> updateInvoiceItem(InvoiceItem invoiceItem) async {
    final db = await _databaseHelper.database;
    return await db.update('InvoiceItems', invoiceItem.toJSON(),
        where: 'id = ?', whereArgs: [invoiceItem.id]);
  }

  Future<int> deleteInvoiceItem(int id) async {
    final db = await _databaseHelper.database;
    return await db.delete('InvoiceItems', where: 'id = ?', whereArgs: [id]);
  }
}
