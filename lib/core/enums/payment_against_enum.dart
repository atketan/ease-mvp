enum PaymentAgainst {
  salesInvoice,
  purchaseInvoice, // aka, purchase order
  expense,
  client,
  vendor,
  other,
}

extension PaymentAgainstExtension on PaymentAgainst {
  String get name {
    switch (this) {
      case PaymentAgainst.salesInvoice:
        return 'Sales';
      case PaymentAgainst.purchaseInvoice:
        return 'Purchase';
      case PaymentAgainst.expense:
        return 'Expense';
      case PaymentAgainst.client:
        return 'Client';
      case PaymentAgainst.vendor:
        return 'Vendor';
      case PaymentAgainst.other:
        return 'Other';
    }
  }
}

extension StringPaymentAgainstExtension on String {
  PaymentAgainst toPaymentAgainst() {
    switch (this) {
      case 'Sales':
        return PaymentAgainst.salesInvoice;
      case 'Purchase':
        return PaymentAgainst.purchaseInvoice;
      case 'Expense':
        return PaymentAgainst.expense;
      case 'Client':
        return PaymentAgainst.client;
      case 'Vendor':
        return PaymentAgainst.vendor;
      case 'Other':
        return PaymentAgainst.other;
      default:
        return PaymentAgainst.other;
    }
  }
}
