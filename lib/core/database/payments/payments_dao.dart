import '../../models/payment.dart';
import 'payments_data_source.dart';

class PaymentsDAO {
  final PaymentsDataSource _dataSource;

  PaymentsDAO(this._dataSource);

  Future<String> insertPayment(Payment payment) {
    return _dataSource.insertPayment(payment);
  }

  Future<List<Payment>> getAllPayments() {
    return _dataSource.getAllPayments();
  }

  Future<int> updatePayment(Payment payment) {
    return _dataSource.updatePayment(payment);
  }

  Future<int> deletePayment(String paymentId) {
    return _dataSource.deletePayment(paymentId);
  }

  Future<Payment?> getPaymentById(String paymentId) {
    return _dataSource.getPaymentById(paymentId);
  }

  Future<Payment?> getPaymentByInvoiceId(String? invoiceId) {
    return _dataSource.getPaymentByInvoiceId(invoiceId);
  }

  Future<List<Payment>> getPaymentsByInvoiceId(String invoiceId) {
    return _dataSource.getPaymentsByInvoiceId(invoiceId);
  }
}
