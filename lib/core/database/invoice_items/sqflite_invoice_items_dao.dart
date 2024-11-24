import '../../models/invoice_item.dart';
import '../database_helper.dart';
import 'invoice_items_data_source.dart';

class SqfliteInvoiceItemsDAO implements InvoiceItemsDataSource {
  final DatabaseHelper _databaseHelper = DatabaseHelper();

  @override
  Future<String> insertInvoiceItem(InvoiceItem invoiceItem) async {
    final db = await _databaseHelper.database;
    return await db
        .insert('InvoiceItems', invoiceItem.toJSON())
        .toString(); // SQLite returns an integer ID
  }

  @override
  Future<List<InvoiceItem>> getInvoiceItemsByInvoiceId(String invoiceId) async {
    final db = await _databaseHelper.database;
    final List<Map<String, dynamic>> maps = await db
        .query('InvoiceItems', where: 'invoice_id = ?', whereArgs: [invoiceId]);
    return List.generate(maps.length, (i) => InvoiceItem.fromJSON(maps[i]));
  }

  @override
  Future<int> updateInvoiceItem(InvoiceItem invoiceItem) async {
    final db = await _databaseHelper.database;
    return await db.update('InvoiceItems', invoiceItem.toJSON(),
        where: 'id = ?', whereArgs: [invoiceItem.id]);
  }

  @override
  Future<int> deleteInvoiceItem(InvoiceItem invoiceItem) async {
    final db = await _databaseHelper.database;
    return await db
        .delete('InvoiceItems', where: 'id = ?', whereArgs: [invoiceItem.id]);
  }
}
