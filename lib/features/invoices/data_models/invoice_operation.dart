enum InvoiceOperation {
  newInvoice,
  updateInvoice,
}

extension InvoiceOperationExtension on InvoiceOperation {
  String get label {
    switch (this) {
      case InvoiceOperation.newInvoice:
        return 'New Invoice';
      case InvoiceOperation.updateInvoice:
        return 'Update Invoice';
      default:
        return '';
    }
  }
}

extension InvoiceOperationPrefixExtension on InvoiceOperation {
  String get prefix {
    switch (this) {
      case InvoiceOperation.newInvoice:
        return 'New';
      case InvoiceOperation.updateInvoice:
        return 'Update';
      default:
        return '';
    }
  }
}
