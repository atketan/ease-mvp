enum PaymentMethod {
  cash,
  upi,
  // debitCard,
  // creditCard,
  netBanking,
  // cheque,
  other,
}

extension PaymentMethodExtension on PaymentMethod {
  String get displayName {
    switch (this) {
      case PaymentMethod.cash:
        return 'Cash';
      case PaymentMethod.upi:
        return 'UPI';
      // case PaymentMethod.debitCard:
      //   return 'Debit Card';
      // case PaymentMethod.creditCard:
      //   return 'Credit Card';
      case PaymentMethod.netBanking:
        return 'Net Banking';
      // case PaymentMethod.cheque:
      //   return 'Cheque';
      case PaymentMethod.other:
        return 'Other';
    }
  }
}

extension StringToPaymentMethod on String {
  PaymentMethod toPaymentMethod() {
    switch (this) {
      case 'cash':
        return PaymentMethod.cash;
      case 'upi':
        return PaymentMethod.upi;
      // case 'debit card':
      //   return PaymentMethod.debitCard;
      // case 'credit card':
      //   return PaymentMethod.creditCard;
      case 'netBanking':
        return PaymentMethod.netBanking;
      // case 'cheque':
      //   return PaymentMethod.cheque;
      case 'other':
        return PaymentMethod.other;
      default:
        throw Exception('Unknown payment method: $this');
    }
  }
}
