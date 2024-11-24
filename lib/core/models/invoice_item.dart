class InvoiceItem {
  int? id;
  String? invoiceId; // Firestore document ID from the invoices collection
  String inventoryId; // Firestore document ID from the inventory collection
  String name;
  String? description;
  String uom;
  int quantity;
  double unitPrice;
  double totalPrice;

  InvoiceItem({
    this.id,
    this.invoiceId,
    required this.inventoryId,
    required this.name,
    this.description,
    required this.uom,
    required this.quantity,
    required this.unitPrice,
    required this.totalPrice,
  });

  factory InvoiceItem.fromJSON(Map<String, dynamic> json) {
    return InvoiceItem(
      id: json['id'],
      invoiceId: json['invoice_id'],
      inventoryId: json['inventory_id'],
      name: json['name'],
      description: json['description'],
      uom: json['uom'],
      quantity: json['quantity'],
      unitPrice: json['unit_price'],
      totalPrice: json['total_price'],
    );
  }

  Map<String, dynamic> toJSON() {
    return {
      'id': id,
      'invoice_id': invoiceId,
      'inventory_id': inventoryId,
      'name': name,
      'description': description,
      'uom': uom,
      'quantity': quantity,
      'unit_price': unitPrice,
      'total_price': totalPrice,
    };
  }
}
