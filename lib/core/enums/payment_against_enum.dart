enum PaymentAgainst {
  salesInvoice,
  purchaseInvoice, // aka, purchase order
  expense,
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
      case 'Other':
        return PaymentAgainst.other;
      default:
        return PaymentAgainst.other;
    }
  }
}
