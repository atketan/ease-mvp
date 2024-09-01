import '../models/invoice.dart';
import 'database_helper.dart';

class InvoicesDAO {
  final DatabaseHelper _databaseHelper = DatabaseHelper();

  Future<int> insertInvoice(Invoice invoice) async {
    final db = await _databaseHelper.database;
    return await db.insert('Invoices', invoice.toJSON());
  }

  Future<List<Invoice>> getAllInvoices({String? paymentStatus}) async {
    final db = await _databaseHelper.database;
    List<Map<String, dynamic>> maps;

    if (paymentStatus == null || paymentStatus.isEmpty) {
      maps = await db.query('Invoices');
    } else {
      maps = await db.query('Invoices', where: 'status = ?', whereArgs: [paymentStatus]);
    }

    return List.generate(maps.length, (i) => Invoice.fromJSON(maps[i]));
  }

  Future<int> updateInvoice(Invoice invoice) async {
    final db = await _databaseHelper.database;
    return await db.update('Invoices', invoice.toJSON(),
        where: 'id = ?', whereArgs: [invoice.id]);
  }

  Future<List<Invoice>> getInvoicesByDateRange(
      DateTime startDate, DateTime endDate) async {
    final db = await _databaseHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'Invoices',
      where: 'date >= ? AND date <= ?',
      whereArgs: [startDate.toIso8601String(), endDate.toIso8601String()],
    );
    return List.generate(maps.length, (i) => Invoice.fromJSON(maps[i]));
  }

  Future<List<Invoice>> getInvoicesByDateRangeAndPaymentStatus(
      DateTime startDate, DateTime endDate, String paymentStatus) async {
    final db = await _databaseHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'Invoices',
      where: 'date >= ? AND date <= ? AND status = ?',
      whereArgs: [
        startDate.toIso8601String(),
        endDate.toIso8601String(),
        paymentStatus
      ],
    );
    return List.generate(maps.length, (i) => Invoice.fromJSON(maps[i]));
  }
}
