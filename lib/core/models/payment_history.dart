class PaymentHistory {
  int? id;
  int paymentId;
  DateTime paymentDate;
  double amount;
  String method;
  DateTime? createdAt;
  DateTime? updatedAt;

  PaymentHistory({
    this.id,
    required this.paymentId,
    required this.paymentDate,
    required this.amount,
    required this.method,
    this.createdAt,
    this.updatedAt,
  });

  factory PaymentHistory.fromJSON(Map<String, dynamic> json) {
    return PaymentHistory(
      id: json['id'],
      paymentId: json['payment_id'],
      paymentDate: DateTime.parse(json['payment_date']),
      amount: json['amount'],
      method: json['method'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  Map<String, dynamic> toJSON() {
    return {
      'id': id,
      'payment_id': paymentId,
      'payment_date': paymentDate.toIso8601String(),
      'amount': amount,
      'method': method,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }
}
