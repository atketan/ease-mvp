class Customer {
  String? id;
  String name;
  String? address;
  String? phone;
  String? email;
  DateTime createdAt;
  DateTime updatedAt;

  Customer({
    this.id,
    required this.name,
    this.address,
    this.phone,
    this.email,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Customer.fromJSON(Map<String, dynamic> json) {
    return Customer(
      id: json['id'],
      name: json['name'] ?? "",
      address: json['address'] ?? "",
      phone: json['phone'].toString(),
      email: json['email'] ?? "",
      createdAt: (json['created_at'] != null)
          ? DateTime.parse(json['created_at'])
          : DateTime.now(),
      updatedAt: (json['updated_at'] != null)
          ? DateTime.parse(json['updated_at'])
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJSON() {
    return {
      'id': id,
      'name': name,
      'address': address,
      'phone': phone,
      'email': email,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}
