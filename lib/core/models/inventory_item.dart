class InventoryItem {
  final int? itemId;
  final String name;
  final String? description;
  final double unitPrice;
  final String unit;

  InventoryItem({
    this.itemId,
    required this.name,
    this.description,
    required this.unitPrice,
    required this.unit,
  });

  factory InventoryItem.fromJSON(Map<String, dynamic> json) {
    return InventoryItem(
      itemId: json['item_id'],
      name: json['name'],
      description: json['description'],
      unitPrice: json['unit_price'],
      unit: json['unit'],
    );
  }

  Map<String, dynamic> toJSON() {
    return {
      'item_id': itemId,
      'name': name,
      'description': description,
      'unit_price': unitPrice,
      'unit': unit,
    };
  }
}
