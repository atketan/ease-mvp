import '../../models/payment.dart';
import '../database_helper.dart';
import 'payments_data_source.dart';

class SqflitePaymentsDAO implements PaymentsDataSource {
  final DatabaseHelper _databaseHelper = DatabaseHelper();

  @override
  Future<int> insertPayment(Payment payment) async {
    final db = await _databaseHelper.database;
    return await db.insert('Payments', payment.toJSON());
  }

  @override
  Future<List<Payment>> getAllPayments() async {
    final db = await _databaseHelper.database;
    final List<Map<String, dynamic>> maps = await db.query('Payments');
    return List.generate(maps.length, (i) => Payment.fromJSON(maps[i]));
  }

  @override
  Future<int> updatePayment(Payment payment) async {
    final db = await _databaseHelper.database;
    return await db.update('Payments', payment.toJSON(),
        where: 'id = ?', whereArgs: [payment.id]);
  }

  @override
  Future<int> deletePayment(String id) async {
    final db = await _databaseHelper.database;
    return await db.delete('Payments', where: 'id = ?', whereArgs: [id]);
  }

  @override
  Future<Payment?> getPaymentById(String paymentId) async {
    final db = await _databaseHelper.database;
    final List<Map<String, dynamic>> maps =
        await db.query('Payments', where: 'id = ?', whereArgs: [paymentId]);

    if (maps.isNotEmpty) {
      return Payment.fromJSON(maps.first);
    } else {
      return null;
    }
  }

  @override
  Future<Payment?> getPaymentByInvoiceId(String? invoiceId) async {
    final db = await _databaseHelper.database;
    final List<Map<String, dynamic>> maps = await db
        .query('Payments', where: 'invoice_id = ?', whereArgs: [invoiceId]);

    if (maps.isNotEmpty) {
      return Payment.fromJSON(maps.first);
    } else {
      return null;
    }
  }

  @override
  Future<List<Payment>> getPaymentsByInvoiceId(String invoiceId) async {
    final db = await _databaseHelper.database;
    final List<Map<String, dynamic>> maps = await db
        .query('Payments', where: 'invoice_id = ?', whereArgs: [invoiceId]);

    return List.generate(maps.length, (i) => Payment.fromJSON(maps[i]));
  }
}
