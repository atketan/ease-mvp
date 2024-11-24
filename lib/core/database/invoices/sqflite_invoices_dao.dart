import '../../models/invoice.dart';
import '../database_helper.dart';
import 'invoices_data_source.dart';

class SqfliteInvoicesDAO implements InvoicesDataSource {
  final DatabaseHelper _databaseHelper = DatabaseHelper();

  @override
  Future<String> insertInvoice(Invoice invoice) async {
    final db = await _databaseHelper.database;
    return await db
        .insert('Invoices', invoice.toJSON())
        .toString(); // SQLite returns an integer ID
  }

  @override
  Future<List<Invoice>> getAllInvoices() async {
    final db = await _databaseHelper.database;
    final List<Map<String, dynamic>> maps = await db.query('Invoices');
    return List.generate(maps.length, (i) => Invoice.fromJSON(maps[i]));
  }

  @override
  Future<Invoice?> getInvoiceById(String invoiceId) async {
    final db = await _databaseHelper.database;
    final List<Map<String, dynamic>> maps =
        await db.query('Invoices', where: 'id = ?', whereArgs: [invoiceId]);

    if (maps.isNotEmpty) {
      return Invoice.fromJSON(maps.first);
    } else {
      return null;
    }
  }

  @override
  Future<int> updateInvoice(Invoice invoice) async {
    final db = await _databaseHelper.database;
    return await db.update('Invoices', invoice.toJSON(),
        where: 'id = ?', whereArgs: [invoice.id]);
  }

  @override
  Future<int> deleteInvoice(String invoiceId) async {
    final db = await _databaseHelper.database;
    return await db.delete('Invoices', where: 'id = ?', whereArgs: [invoiceId]);
  }

  @override
  Future<int> markInvoiceAsPaid(String invoiceId) async {
    final db = await _databaseHelper.database;
    return await db.update(
      'Invoices',
      {'status': 'paid'},
      where: 'id = ?',
      whereArgs: [invoiceId],
    );
  }

  @override
  Future<List<Invoice>> getInvoicesByDateRangeAndPaymentStatus(
      DateTime startDate, DateTime endDate, String status) async {
    final db = await _databaseHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'Invoices',
      where: 'date BETWEEN ? AND ? AND status = ?',
      whereArgs: [
        startDate.toIso8601String(),
        endDate.toIso8601String(),
        status
      ],
    );
    return List.generate(maps.length, (i) => Invoice.fromJSON(maps[i]));
  }

  @override
  Future<List<Invoice>> getSalesInvoicesByDateRange(
      DateTime startDate, DateTime endDate) async {
    final db = await _databaseHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'Invoices',
      where: 'date BETWEEN ? AND ? AND type = ?',
      whereArgs: [
        startDate.toIso8601String(),
        endDate.toIso8601String(),
        'sales'
      ],
    );
    return List.generate(maps.length, (i) => Invoice.fromJSON(maps[i]));
  }
}
