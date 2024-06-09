class Expense {
  int? id;
  int categoryId;
  String description;
  double amount;
  DateTime date;
  DateTime? createdAt;
  DateTime? updatedAt;

  Expense({
    this.id,
    required this.categoryId,
    required this.description,
    required this.amount,
    required this.date,
    this.createdAt,
    this.updatedAt,
  });

  factory Expense.fromJSON(Map<String, dynamic> json) {
    return Expense(
      id: json['id'],
      categoryId: json['category_id'],
      description: json['description'],
      amount: json['amount'],
      date: DateTime.parse(json['date']),
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  Map<String, dynamic> toJSON() {
    return {
      'id': id,
      'category_id': categoryId,
      'description': description,
      'amount': amount,
      'date': date.toIso8601String(),
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }
}
