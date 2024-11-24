import '../../models/payment.dart';

abstract class PaymentsDataSource {
  Future<int> insertPayment(Payment payment);
  Future<List<Payment>> getAllPayments();
  Future<int> updatePayment(Payment payment);
  Future<int> deletePayment(String paymentId);
  Future<Payment?> getPaymentById(String paymentId);
  Future<List<Payment>> getPaymentsByInvoiceId(String invoiceId);
  Future<Payment?> getPaymentByInvoiceId(
    String? invoiceId,
  ); // To be deprecated, as each invoice can have multiple payments made against it
}
