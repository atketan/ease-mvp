enum InvoiceType {
  cashSale,
  creditSale,
  cashPurchase,
  creditPurchase,
}

extension InvoiceTypeExtension on InvoiceType {
  String get label {
    switch (this) {
      case InvoiceType.cashSale:
        return 'Cash Sale';
      case InvoiceType.creditSale:
        return 'Credit Sale';
      case InvoiceType.cashPurchase:
        return 'Cash Purchase';
      case InvoiceType.creditPurchase:
        return 'Credit Purchase';
      default:
        return 'Unknown';
    }
  }
}

extension InvoiceTitleExtension on InvoiceType {
  String get title {
    switch (this) {
      case InvoiceType.cashSale:
        return 'Sale';
      case InvoiceType.creditSale:
        return 'Sale';
      case InvoiceType.cashPurchase:
        return 'Purchase';
      case InvoiceType.creditPurchase:
        return 'Purchase';
      default:
        return 'Unknown';
    }
  }
}
