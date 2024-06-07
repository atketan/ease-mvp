class InvoiceItem {
  String particulars;
  String uom;
  double rate;
  int quantity;
  double amount;

  InvoiceItem({
    required this.particulars,
    required this.uom,
    required this.rate,
    required this.quantity,
    required this.amount,
  });

  String get getParticulars => particulars;
  String get getUom => uom;
  double get getRate => rate;
  int get getQuantity => quantity;
  double get getAmount => amount;

  set setParticulars(String value) {
    particulars = value;
  }

  set setUom(String value) {
    uom = value;
  }

  set setRate(double value) {
    rate = value;
  }

  set setQuantity(int value) {
    quantity = value;
  }

  set setAmount(double value) {
    amount = value;
  }

  Map<String, dynamic> toJson() {
    return {
      'particulars': particulars,
      'uom': uom,
      'rate': rate,
      'quantity': quantity,
      'amount': amount,
    };
  }

  factory InvoiceItem.fromJson(Map<String, dynamic> json) {
    return InvoiceItem(
      particulars: json['particulars'],
      uom: json['uom'],
      rate: json['rate'],
      quantity: json['quantity'],
      amount: json['amount'],
    );
  }
}
