import 'package:ease/core/models/payment.dart';

import 'invoice_item.dart';

class Invoice {
  int? id; // auto-increment ID from the DB - primary key
  String? invoiceId; // Firestore doc id
  String? customerId;
  String? vendorId;
  String name; // customer name or vendor name
  String invoiceNumber;
  DateTime date;
  double totalAmount;
  double discount;
  double taxes;
  double grandTotal;
  String paymentType; // cash or credit
  String status; // paid or unpaid
  String? notes;
  List<InvoiceItem> _items = [];
  List<Payment> _payments = [];

  Invoice({
    this.id,
    this.invoiceId,
    this.customerId,
    this.vendorId,
    required this.name,
    required this.invoiceNumber,
    required this.date,
    required this.totalAmount,
    required this.discount,
    required this.taxes,
    required this.grandTotal,
    required this.paymentType,
    required this.status,
    this.notes,
  }) : assert(customerId != null || vendorId != null,
            'Either customerId or vendorId must be non-null');

  List<InvoiceItem> get items => _items;

  void set items(List<InvoiceItem> items) {
    _items = items;
  }

  List<Payment> get payments => _payments;

  void set payments(List<Payment> payments) {
    _payments = payments;
  }

  factory Invoice.fromJSON(Map<String, dynamic> json) {
    return Invoice(
      id: json['id'],
      invoiceId: json['invoice_id'],
      customerId: json['customer_id'],
      vendorId: json['vendor_id'],
      name: json['name'],
      invoiceNumber: json['invoice_number'],
      date: DateTime.parse(json['date']),
      totalAmount: json['total_amount'],
      discount: json['discount'],
      taxes: json['taxes'],
      grandTotal: json['grand_total'],
      paymentType: json['payment_type'],
      status: json['status'],
      notes: json['notes'],
    );
    // ).._items = (json['items'] as List)
    //     .map((item) => InvoiceItem.fromJSON(item))
    //     .toList();
  }

  Map<String, dynamic> toJSON() {
    return {
      'id': id,
      'invoice_id': invoiceId,
      'customer_id': customerId,
      'vendor_id': vendorId,
      'name': name,
      'invoice_number': invoiceNumber,
      'date': date.toIso8601String(),
      'total_amount': totalAmount,
      'discount': discount,
      'taxes': taxes,
      'grand_total': grandTotal,
      'payment_type': paymentType,
      'status': status,
      'notes': notes,
      // 'items': _items.map((item) => item.toJSON()).toList(),
    };
  }
}
