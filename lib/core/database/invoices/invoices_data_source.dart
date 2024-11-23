import '../../models/invoice.dart';

abstract class InvoicesDataSource {
  Future<int> insertInvoice(Invoice invoice);
  Future<List<Invoice>> getAllInvoices();
  Future<Invoice?> getInvoiceById(String invoiceId);
  Future<int> updateInvoice(Invoice invoice);
  Future<int> deleteInvoice(String invoiceId);
  Future<int> markInvoiceAsPaid(String invoiceId);
  Future<List<Invoice>> getInvoicesByDateRangeAndPaymentStatus(
      DateTime startDate, DateTime endDate, String status);
  Future<List<Invoice>> getSalesInvoicesByDateRange(
      DateTime startDate, DateTime endDate);
}
