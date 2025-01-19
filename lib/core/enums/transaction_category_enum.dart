enum TransactionCategory {
  sales, // Customer-related transactions
  purchase, // Vendor-related transactions
  expense, // Expense transactions
  other // Miscellaneous or uncategorized transactions
}

extension TransactionCategoryExtension on TransactionCategory {
  String get name {
    switch (this) {
      case TransactionCategory.sales:
        return 'sales';
      case TransactionCategory.purchase:
        return 'purchase';
      case TransactionCategory.expense:
        return 'expense';
      case TransactionCategory.other:
        return 'other';
    }
  }

  String get displayName {
    switch (this) {
      case TransactionCategory.sales:
        return 'Sales';
      case TransactionCategory.purchase:
        return 'Purchase';
      case TransactionCategory.expense:
        return 'Expense';
      case TransactionCategory.other:
        return 'Other';
    }
  }
}

extension StringToTransactionCategory on String {
  TransactionCategory toTransactionCategory() {
    switch (this) {
      case 'sales':
        return TransactionCategory.sales;
      case 'purchase':
        return TransactionCategory.purchase;
      case 'expense':
        return TransactionCategory.expense;
      case 'other':
        return TransactionCategory.other;
      default:
        throw Exception('Unknown transaction category: $this');
    }
  }
}
