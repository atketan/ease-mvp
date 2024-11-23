import '../../models/invoice_item.dart';
import 'invoice_items_data_source.dart';

class InvoiceItemsDAO {
  final InvoiceItemsDataSource _dataSource;

  InvoiceItemsDAO(this._dataSource);

  Future<int> insertInvoiceItem(InvoiceItem invoiceItem) {
    return _dataSource.insertInvoiceItem(invoiceItem);
  }

  Future<List<InvoiceItem>> getInvoiceItemsByInvoiceId(String invoiceId) {
    return _dataSource.getInvoiceItemsByInvoiceId(invoiceId);
  }

  Future<int> updateInvoiceItem(InvoiceItem invoiceItem) {
    return _dataSource.updateInvoiceItem(invoiceItem);
  }

  Future<int> deleteInvoiceItem(String id) {
    return _dataSource.deleteInvoiceItem(id);
  }
}