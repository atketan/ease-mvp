class Customer {
  String? id;
  String name;
  String? address;
  String? phone;
  String? email;
  DateTime createdAt;
  DateTime updatedAt;
  // openingBalance - is the carry forward balance either from previous year
  // or from the older app/process which was used to manage the accounts
  double openingBalance;

  Customer({
    this.id,
    required this.name,
    this.address,
    this.phone,
    this.email,
    required this.createdAt,
    required this.updatedAt,
    required this.openingBalance,
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
      openingBalance: json['opening_balance'] ?? 0.0,
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
      'opening_balance': openingBalance,
    };
  }
}
