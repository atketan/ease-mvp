class Payment {
  int? id;
  int invoiceId;
  double amount;
  DateTime paymentDate;
  String paymentMethod;
  DateTime? createdAt;
  DateTime? updatedAt;

  Payment({
    this.id,
    required this.invoiceId,
    required this.amount,
    required this.paymentDate,
    required this.paymentMethod,
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
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  Map<String, dynamic> toJSON() {
    return {
      'id': id,
      'invoice_id': invoiceId,
      'amount': amount,
      'payment_date': paymentDate.toIso8601String(),
      'payment_method': paymentMethod,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }
}
