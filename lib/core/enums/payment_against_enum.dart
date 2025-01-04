enum PaymentType {
  openingBalance, // added at the time of creating a new client or vendor
  sales, // associated with sales invoice
  purchase, // associated with purchase invoice
  expense, // associated with expense
  client, // amounts paid out or in to a client, unrelated to sales and can be used to manage additional client payments
  vendor, // amounts paid out or in to a vendor, unrelated to purchase and can be used to manage additional vendor payments
  other,
}

extension PaymentAgainstExtension on PaymentType {
  String get name {
    switch (this) {
      case PaymentType.openingBalance:
        return 'Opening Balance';
      case PaymentType.sales:
        return 'Sales';
      case PaymentType.purchase:
        return 'Purchase';
      case PaymentType.expense:
        return 'Expense';
      case PaymentType.client:
        return 'Client';
      case PaymentType.vendor:
        return 'Vendor';
      case PaymentType.other:
        return 'Other';
    }
  }
}

extension StringPaymentAgainstExtension on String {
  PaymentType toPaymentAgainst() {
    switch (this) {
      case 'Opening Balance':
        return PaymentType.openingBalance;
      case 'Sales':
        return PaymentType.sales;
      case 'Purchase':
        return PaymentType.purchase;
      case 'Expense':
        return PaymentType.expense;
      case 'Client':
        return PaymentType.client;
      case 'Vendor':
        return PaymentType.vendor;
      case 'Other':
        return PaymentType.other;
      default:
        return PaymentType.other;
    }
  }
}
