import '../models/payment.dart';
import 'database_helper.dart';

class PaymentsDAO {
  final DatabaseHelper _databaseHelper = DatabaseHelper();

  Future<int> insertPayment(Payment payment) async {
    final db = await _databaseHelper.database;
    return await db.insert('Payments', payment.toJSON());
  }

  Future<List<Payment>> getAllPayments() async {
    final db = await _databaseHelper.database;
    final List<Map<String, dynamic>> maps = await db.query('Payments');
    return List.generate(maps.length, (i) => Payment.fromJSON(maps[i]));
  }

  Future<int> updatePayment(Payment payment) async {
    final db = await _databaseHelper.database;
    return await db.update('Payments', payment.toJSON(),
        where: 'id = ?', whereArgs: [payment.id]);
  }

  Future<int> deletePayment(int id) async {
    final db = await _databaseHelper.database;
    return await db.delete('Payments', where: 'id = ?', whereArgs: [id]);
  }

  Future<Payment?> getPaymentByInvoiceId(int? id) async {
    if (id == null) return null;
    final db = await _databaseHelper.database;
    final List<Map<String, dynamic>> maps =
        await db.query('Payments', where: 'invoice_id = ?', whereArgs: [id]);

    if (maps.isNotEmpty) {
      return Payment.fromJSON(maps.first);
    } else {
      return null;
    }
  }
}
