enum PaymentMethod {
  upi,
  cash,
  debitCard,
  creditCard,
  netBanking,
  cheque,
  other,
}

extension PaymentMethodExtension on PaymentMethod {
  String get displayName {
    switch (this) {
      case PaymentMethod.upi:
        return 'UPI';
      case PaymentMethod.cash:
        return 'Cash';
      case PaymentMethod.debitCard:
        return 'Debit Card';
      case PaymentMethod.creditCard:
        return 'Credit Card';
      case PaymentMethod.netBanking:
        return 'Net Banking';
      case PaymentMethod.cheque:
        return 'Cheque';
      case PaymentMethod.other:
        return 'Other';
    }
  }
}

extension StringToPaymentMethod on String {
  PaymentMethod toPaymentMethod() {
    switch (this.toLowerCase()) {
      case 'upi':
        return PaymentMethod.upi;
      case 'cash':
        return PaymentMethod.cash;
      case 'debit card':
        return PaymentMethod.debitCard;
      case 'credit card':
        return PaymentMethod.creditCard;
      case 'net banking':
        return PaymentMethod.netBanking;
      case 'cheque':
        return PaymentMethod.cheque;
      case 'other':
        return PaymentMethod.other;
      default:
        throw Exception('Unknown payment method: $this');
    }
  }
}
