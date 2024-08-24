// invoice_manager_state.dart

abstract class InvoiceManagerCubitState {}

class InvoiceManagerInitial extends InvoiceManagerCubitState {}

class InvoiceManagerLoading extends InvoiceManagerCubitState {}

class InvoiceManagerLoaded extends InvoiceManagerCubitState {}

class InvoiceManagerError extends InvoiceManagerCubitState {
  final String message;
  InvoiceManagerError(this.message);
}
