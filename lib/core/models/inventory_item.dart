class InventoryItem {
  String? itemId;
  final String name;
  final String? description;
  final double unitPrice;
  final String uom;

  InventoryItem({
    this.itemId,
    required this.name,
    this.description,
    required this.unitPrice,
    required this.uom,
  });

  factory InventoryItem.fromJSON(Map<String, dynamic> json) {
    return InventoryItem(
      itemId: json['item_id'],
      name: json['name'],
      description: json['description'],
      unitPrice: json['unit_price'],
      uom: json['uom'],
    );
  }

  Map<String, dynamic> toJSON() {
    return {
      'item_id': itemId,
      'name': name,
      'description': description,
      'unit_price': unitPrice,
      'uom': uom,
    };
  }
}
