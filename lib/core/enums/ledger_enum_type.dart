enum LedgerEntryType {
  invoice, // For invoices
  payment, // For payments
  expense, // For expenses
  openingBalance, // For opening balances
  advance // For advance payments or overpayments
}

extension LedgerEntryTypeExtension on LedgerEntryType {
  String get name {
    switch (this) {
      case LedgerEntryType.invoice:
        return 'invoice';
      case LedgerEntryType.payment:
        return 'payment';
      case LedgerEntryType.expense:
        return 'expense';
      case LedgerEntryType.openingBalance:
        return 'opening_balance';
      case LedgerEntryType.advance:
        return 'advance';
    }
  }
}

extension StringToLedgerEntryType on String {
  LedgerEntryType toLedgerEntryType() {
    switch (this) {
      case 'invoice':
        return LedgerEntryType.invoice;
      case 'payment':
        return LedgerEntryType.payment;
      case 'expense':
        return LedgerEntryType.expense;
      case 'opening_balance':
        return LedgerEntryType.openingBalance;
      case 'advance':
        return LedgerEntryType.advance;
      default:
        throw Exception('Unknown ledger entry type: $this');
    }
  }
}
