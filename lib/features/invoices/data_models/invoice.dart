import 'invoice_item.dart';

class Invoice {
  String voucherNumber;
  List<InvoiceItem> invoiceItems;

  Invoice({
    required this.voucherNumber,
    required this.invoiceItems,
  });
}
