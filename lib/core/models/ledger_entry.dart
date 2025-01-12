import 'package:ease/core/enums/ledger_enum_type.dart';
import 'package:ease/core/enums/payment_method_enum.dart';
import 'package:ease/core/enums/transaction_category_enum.dart';
import 'package:ease/core/enums/transaction_type_enum.dart';

class LedgerEntry {
  String? id; // Firestore document ID
  LedgerEntryType type; // Enum for type ("invoice", "payment", etc.)
  String? associatedId; // Customer or vendor ID
  String? name; // Name of customer or vendor
  TransactionCategory?
      transactionCategory; // "sales", "purchase", "expense", or "other"
  double amount; // Total amount for the entry
  double? discount;
  double? grandTotal;
  double?
      initialPaid; // Amount paid at the time of invoice creation (if type = "invoice")
  double? remainingDue; // Outstanding amount (if type = "invoice")
  String? status; // "paid", "unpaid", "partially_paid" (if applicable)
  PaymentMethod? paymentMethod; // Payment method (if type = "payment")
  TransactionType?
      transactionType; // "credit" (money in) or "debit" (money out)
  String? notes; // Optional description
  String? attachmentUrl; // Invoice or expense attachments (if applicable)
  DateTime transactionDate; // Date of the transaction
  DateTime createdAt; // Auto-generated
  DateTime updatedAt; // Auto-generated

  LedgerEntry({
    this.id,
    required this.type,
    this.associatedId,
    this.transactionCategory,
    required this.amount,
    this.discount,
    this.grandTotal,
    this.initialPaid,
    this.remainingDue,
    this.status,
    this.paymentMethod,
    this.transactionType,
    this.notes,
    this.attachmentUrl,
    required this.transactionDate,
    required this.createdAt,
    required this.updatedAt,
  });

  factory LedgerEntry.fromJSON(Map<String, dynamic> json) {
    return LedgerEntry(
      id: json['id'],
      type: json['type'].toString().toLedgerEntryType(),
      associatedId: json['associated_id'],
      transactionCategory:
          json['transaction_category']?.toString().toTransactionCategory(),
      amount: json['amount'],
      discount: json['discount'],
      grandTotal: json['grand_total'],
      initialPaid: json['initial_paid'],
      remainingDue: json['remaining_due'],
      status: json['status'],
      paymentMethod: json['payment_method']?.toString().toPaymentMethod(),
      transactionType: json['transaction_type']?.toString().toTransactionType(),
      notes: json['notes'],
      attachmentUrl: json['attachment_url'],
      transactionDate: DateTime.parse(json['transaction_date']),
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  Map<String, dynamic> toJSON() {
    return {
      'id': id,
      'type': type.name,
      'associated_id': associatedId,
      'transaction_category': transactionCategory?.name,
      'amount': amount,
      'discount': discount,
      'grand_total': grandTotal,
      'initial_paid': initialPaid,
      'remaining_due': remainingDue,
      'status': status,
      'payment_method': paymentMethod?.name,
      'transaction_type': transactionType?.name,
      'notes': notes,
      'attachment_url': attachmentUrl,
      'transaction_date': transactionDate.toIso8601String(),
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}
