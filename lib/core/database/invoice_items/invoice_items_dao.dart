import '../../models/invoice_item.dart';
import 'invoice_items_data_source.dart';

class InvoiceItemsDAO {
  final InvoiceItemsDataSource _dataSource;

  InvoiceItemsDAO(this._dataSource);

  Future<String> insertInvoiceItem(InvoiceItem invoiceItem) {
    return _dataSource.insertInvoiceItem(invoiceItem);
  }

  Future<List<InvoiceItem>> getInvoiceItemsByInvoiceId(String invoiceId) {
    return _dataSource.getInvoiceItemsByInvoiceId(invoiceId);
  }

  Future<int> updateInvoiceItem(InvoiceItem invoiceItem) {
    return _dataSource.updateInvoiceItem(invoiceItem);
  }

  Future<int> deleteInvoiceItem(InvoiceItem invoiceItem) {
    return _dataSource.deleteInvoiceItem(invoiceItem);
  }
}