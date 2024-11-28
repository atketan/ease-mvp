import '../../models/invoice.dart';
import 'invoices_data_source.dart';

class InvoicesDAO {
  final InvoicesDataSource _dataSource;

  InvoicesDAO(this._dataSource);

  Future<String> insertInvoice(Invoice invoice) {
    return _dataSource.insertInvoice(invoice);
  }

  Future<List<Invoice>> getAllInvoices() {
    return _dataSource.getAllInvoices();
  }

  Future<Invoice?> getInvoiceById(String invoiceId) {
    return _dataSource.getInvoiceById(invoiceId);
  }

  Future<int> updateInvoice(Invoice invoice) {
    return _dataSource.updateInvoice(invoice);
  }

  Future<int> deleteInvoice(String invoiceId) {
    return _dataSource.deleteInvoice(invoiceId);
  }

  Future<int> markInvoiceAsPaid(String invoiceId) {
    return _dataSource.markInvoiceAsPaid(invoiceId);
  }

  Future<List<Invoice>> getInvoicesByDateRangeAndPaymentStatus(
      DateTime startDate, DateTime endDate, String status) {
    return _dataSource.getInvoicesByDateRangeAndPaymentStatus(
        startDate, endDate, status);
  }

  Future<List<Invoice>> getSalesInvoicesByDateRange(
      DateTime startDate, DateTime endDate) {
    return _dataSource.getSalesInvoicesByDateRange(startDate, endDate);
  }

  Stream<List<Invoice>> subscribeToInvoices(
      DateTime startDate, DateTime endDate) {
    return _dataSource.subscribeToInvoices(startDate, endDate);
  }
}
