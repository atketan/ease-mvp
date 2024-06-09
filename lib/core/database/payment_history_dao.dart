import '../models/payment_history.dart';
import 'database_helper.dart';

class PaymentHistoryDAO {
  final DatabaseHelper _databaseHelper = DatabaseHelper();

  Future<int> insertPaymentHistory(PaymentHistory paymentHistory) async {
    final db = await _databaseHelper.database;
    return await db.insert('PaymentHistory', paymentHistory.toJSON());
  }

  Future<List<PaymentHistory>> getAllPaymentHistory() async {
    final db = await _databaseHelper.database;
    final List<Map<String, dynamic>> maps = await db.query('PaymentHistory');
    return List.generate(maps.length, (i) => PaymentHistory.fromJSON(maps[i]));
  }

  Future<int> updatePaymentHistory(PaymentHistory paymentHistory) async {
    final db = await _databaseHelper.database;
    return await db.update('PaymentHistory', paymentHistory.toJSON(),
        where: 'id = ?', whereArgs: [paymentHistory.id]);
  }

  Future<int> deletePaymentHistory(int id) async {
    final db = await _databaseHelper.database;
    return await db.delete('PaymentHistory', where: 'id = ?', whereArgs: [id]);
  }
}
