import 'package:ease/core/enums/payment_type_enum.dart';

class Payment {
  String? id;
  String? invoiceId; // Nullable, as it may not be associated with an invoice
  double amount;
  DateTime paymentDate;
  String paymentMethod;
  PaymentType paymentType; // Use enum instead of String
  String? generalPaymentDescription; // Nullable, for general payments
  DateTime? createdAt;
  DateTime? updatedAt;

  Payment({
    this.id,
    this.invoiceId,
    required this.amount,
    required this.paymentDate,
    required this.paymentMethod,
    required this.paymentType,
    this.generalPaymentDescription,
    this.createdAt,
    this.updatedAt,
  });

  factory Payment.fromJSON(Map<String, dynamic> json) {
    return Payment(
      id: json['id'],
      invoiceId: json['invoice_id'],
      amount: json['amount'],
      paymentDate: DateTime.parse(json['payment_date']),
      paymentMethod: json['payment_method'],
      paymentType: PaymentType.values.firstWhere((e) => e.toString() == 'PaymentType.${json['payment_type']}'),
      generalPaymentDescription: json['general_payment_description'],
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at']) : null,
      updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at']) : null,
    );
  }

  Map<String, dynamic> toJSON() {
    return {
      'id': id,
      'invoice_id': invoiceId,
      'amount': amount,
      'payment_date': paymentDate.toIso8601String(),
      'payment_method': paymentMethod,
      'payment_type': paymentType.toString().split('.').last, // Convert enum to string
      'general_payment_description': generalPaymentDescription,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }
}
