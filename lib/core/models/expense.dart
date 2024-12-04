class Expense {
  int? id;
  String? expenseId; // Firestore document ID
  String? notes;
  String? name; // category name - to avoid calling categories collection
  String? categoryId;
  double amount;
  DateTime createdAt;
  DateTime updatedAt;

  Expense({
    this.id,
    this.expenseId,
    required this.name,
    this.notes,
    this.categoryId,
    required this.amount,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Expense.fromJSON(Map<String, dynamic> json) {
    return Expense(
      id: json['id'],
      expenseId: json['expense_id'],
      name: json['name'],
      notes: json['notes'],
      categoryId: json['category_id'],
      amount: json['amount'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  Map<String, dynamic> toJSON() {
    return {
      'id': id,
      'expense_id': expenseId,
      'name': name,
      'notes': notes,
      'category_id': categoryId,
      'amount': amount,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}
