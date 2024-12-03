class ExpenseCategory {
  int? id;
  String? categoryId; // firestore doc id
  String name;
  String? description;
  String? iconName;
  DateTime? createdAt;
  DateTime? updatedAt;

  ExpenseCategory({
    this.id,
    this.categoryId,
    required this.name,
    this.description,
    this.iconName,
    this.createdAt,
    this.updatedAt,
  });

  factory ExpenseCategory.fromJSON(Map<String, dynamic> json) {
    return ExpenseCategory(
      id: json['id'],
      categoryId: json['category_id'],
      name: json['name'],
      description: json['description'],
      iconName: json['icon_name'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  Map<String, dynamic> toJSON() {
    return {
      'id': id,
      'category_id': categoryId,
      'name': name,
      'description': description,
      'icon_name': iconName,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }
}
