class Customer {
  int? id;
  String name;
  String? address;
  String? phone;
  String? email;
  DateTime? createdAt;
  DateTime? updatedAt;

  Customer({
    this.id,
    required this.name,
    this.address,
    this.phone,
    this.email,
    this.createdAt,
    this.updatedAt,
  });

  factory Customer.fromJSON(Map<String, dynamic> json) {
    return Customer(
      id: json['id'],
      name: json['name'] ?? "",
      address: json['address'] ?? "",
      phone: json['phone'] ?? "",
      email: json['email'] ?? "",
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  Map<String, dynamic> toJSON() {
    return {
      'name': name,
      'address': address,
      'phone': phone,
      'email': email,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }
}
