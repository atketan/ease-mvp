class Expense {
  int? id;
  String? expenseId; // firestore doc id
  String categoryId; // firestore doc id for expense category
  String description;
  double amount;
  DateTime createdAt;
  DateTime? updatedAt;

  Expense({
    this.id,
    this.expenseId,
    required this.categoryId,
    required this.description,
    required this.amount,
    required this.createdAt,
    this.updatedAt,
  });

  factory Expense.fromJSON(Map<String, dynamic> json) {
    return Expense(
      id: json['id'],
      expenseId: json['expense_id'],
      categoryId: json['category_id'],
      description: json['description'],
      amount: json['amount'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  Map<String, dynamic> toJSON() {
    return {
      'id': id,
      'expense_id': expenseId,
      'category_id': categoryId,
      'description': description,
      'amount': amount,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }
}
