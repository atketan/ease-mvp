import 'package:ease/core/enums/payment_against_enum.dart';
import 'package:ease/core/enums/payment_method_enum.dart';
import 'package:ease/core/enums/transaction_type_enum.dart';

class Payment {
  String? id;
  String? invoiceId; // Nullable, as it may not be associated with an invoice
  String? customerId; // Nullable, as it may not be associated with a customer/client
  String? vendorId; // Nullable, as it may not be associated with a vendor/supplier
  double amount;
  DateTime paymentDate;
  PaymentMethod
      paymentMethod; // upi, cash, debit card, credit card, net banking, cheque, other
  TransactionType transactionType; // credit, debit
  String? notes; // Nullable, for general payment description
  PaymentAgainst paymentAgainst; // sales/purchase invoice, expense, client, vendor, other
  DateTime? createdAt;
  DateTime? updatedAt;

  Payment({
    this.id,
    this.invoiceId,
    required this.amount,
    required this.paymentDate,
    required this.paymentMethod,
    required this.transactionType,
    this.notes,
    required this.paymentAgainst,
    this.createdAt,
    this.updatedAt,
  });

  factory Payment.fromJSON(Map<String, dynamic> json) {
    return Payment(
      id: json['id'],
      invoiceId: json['invoice_id'],
      amount: json['amount'],
      paymentDate: DateTime.parse(json['payment_date']),
      paymentMethod: json['payment_method'].toString().toPaymentMethod(),
      transactionType: TransactionType.values.firstWhere(
          (e) => e.toString() == 'TransactionType.${json['transaction_type']}'),
      notes: json['general_payment_description'],
      paymentAgainst: json['payment_against'].toString().toPaymentAgainst(),
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'])
          : null,
    );
  }

  Map<String, dynamic> toJSON() {
    return {
      'id': id,
      'invoice_id': invoiceId,
      'amount': amount,
      'payment_date': paymentDate.toIso8601String(),
      'payment_method': paymentMethod.name.toLowerCase(),
      'transaction_type':
          transactionType.toString().split('.').last, // Convert enum to string
      'notes': notes,
      'payment_against': paymentAgainst.name,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }
}
