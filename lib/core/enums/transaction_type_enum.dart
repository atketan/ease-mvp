enum TransactionType {
  credit, // Payin
  debit, // Payout
}

extension TransactionTypeExtension on TransactionType {
  String get name {
    switch (this) {
      case TransactionType.credit:
        return 'credit';
      case TransactionType.debit:
        return 'debit';
    }
  }
}

extension StringToTransactionType on String {
  TransactionType toTransactionType() {
    switch (this) {
      case 'credit':
        return TransactionType.credit;
      case 'debit':
        return TransactionType.debit;
      default:
        throw Exception('Unknown transaction category: $this');
    }
  }
}
