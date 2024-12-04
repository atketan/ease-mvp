enum InvoiceType {
  Sales,
  Purchase,
  Expense,
  // Add other types as needed
}

extension InvoiceTypeExtension on InvoiceType {
  String get title {
    switch (this) {
      case InvoiceType.Sales:
        return 'Sale';
      case InvoiceType.Purchase:
        return 'Purchase';
      case InvoiceType.Expense:
        return 'Expense';
      // Add cases for other types
    }
  }
}

enum InvoiceSubType {
  cashSale,
  creditSale,
  cashPurchase,
  creditPurchase,
}

extension InvoiceSubTypeExtension on InvoiceSubType {
  String get label {
    switch (this) {
      case InvoiceSubType.cashSale:
        return 'Cash Sale';
      case InvoiceSubType.creditSale:
        return 'Credit Sale';
      case InvoiceSubType.cashPurchase:
        return 'Cash Purchase';
      case InvoiceSubType.creditPurchase:
        return 'Credit Purchase';
      default:
        return 'Unknown';
    }
  }
}

extension InvoiceSubTypeTitleExtension on InvoiceSubType {
  String get title {
    switch (this) {
      case InvoiceSubType.cashSale:
        return 'Sale';
      case InvoiceSubType.creditSale:
        return 'Sale';
      case InvoiceSubType.cashPurchase:
        return 'Purchase';
      case InvoiceSubType.creditPurchase:
        return 'Purchase';
      default:
        return 'Unknown';
    }
  }
}
