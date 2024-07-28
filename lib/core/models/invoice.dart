import 'invoice_item.dart';

class Invoice {
  int? id; // auto-increment ID from the DB - primary key
  int? customerId;
  int? vendorId;
  String invoiceNumber;
  DateTime date;
  double totalAmount;
  String paymentType;
  String status;
  List<InvoiceItem> _items = [];

  Invoice({
    this.id,
    this.customerId,
    this.vendorId,
    required this.invoiceNumber,
    required this.date,
    required this.totalAmount,
    required this.paymentType,
    required this.status,
  }) : assert(customerId != null || vendorId != null,
            'Either customerId or vendorId must be non-null');

  List<InvoiceItem> get items => _items;

  void set items(List<InvoiceItem> items) {
    _items = items;
  }

  factory Invoice.fromJSON(Map<String, dynamic> json) {
    return Invoice(
      id: json['id'],
      customerId: json['customer_id'] ?? "",
      vendorId: json['vendor_id'] ?? "",
      invoiceNumber: json['invoice_number'],
      date: DateTime.parse(json['date']),
      totalAmount: json['total_amount'],
      paymentType: json['payment_type'],
      status: json['status'],
    ).._items = (json['items'] as List)
        .map((item) => InvoiceItem.fromJSON(item))
        .toList();
  }

  Map<String, dynamic> toJSON() {
    return {
      'id': id,
      'customer_id': customerId ?? "",
      'vendor_id': vendorId ?? "",
      'invoice_number': invoiceNumber,
      'date': date.toIso8601String(),
      'total_amount': totalAmount,
      'payment_type': paymentType,
      'status': status,
      'items': _items.map((item) => item.toJSON()).toList(),
    };
  }
}
