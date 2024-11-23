import '../../models/invoice_item.dart';

abstract class InvoiceItemsDataSource {
  Future<int> insertInvoiceItem(InvoiceItem invoiceItem);
  Future<List<InvoiceItem>> getInvoiceItemsByInvoiceId(String invoiceId);
  Future<int> updateInvoiceItem(InvoiceItem invoiceItem);
  Future<int> deleteInvoiceItem(String id);
}