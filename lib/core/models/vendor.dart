class Vendor {
  String? id;
  String name;
  String? address;
  String? phone;
  String? email;
  DateTime? createdAt;
  DateTime? updatedAt;
  // openingBalance - is the carry forward balance either from previous year
  // or from the older app/process which was used to manage the accounts
  double openingBalance;


  Vendor({
    this.id,
    required this.name,
    this.address,
    this.phone,
    this.email,
    this.createdAt,
    this.updatedAt,
    required this.openingBalance,
  });

  factory Vendor.fromJSON(Map<String, dynamic> json) {
    return Vendor(
      id: json['id'],
      name: json['name'],
      address: json['address'],
      phone: json['phone'],
      email: json['email'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      openingBalance: json['opening_balance'],
    );
  }

  Map<String, dynamic> toJSON() {
    return {
      'id': id,
      'name': name,
      'address': address,
      'phone': phone,
      'email': email,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
      'opening_balance': openingBalance,
    };
  }
}
