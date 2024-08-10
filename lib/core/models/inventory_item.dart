class InventoryItem {
  final String id;
  final String name;
  final double unitPrice;
  final String unit;

  InventoryItem({
    required this.id,
    required this.name,
    required this.unitPrice,
    required this.unit,
  });

  factory InventoryItem.fromJSON(Map<String, dynamic> json) {
    return InventoryItem(
      id: json['id'],
      name: json['name'],
      unitPrice: json['unitPrice'],
      unit: json['unit'],
    );
  }

  Map<String, dynamic> toJSON() {
    return {
      'id': id,
      'name': name,
      'unitPrice': unitPrice,
      'unit': unit,
    };
  }
}
