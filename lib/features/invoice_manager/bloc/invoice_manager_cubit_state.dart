// invoice_manager_state.dart
import 'package:ease_mvp/core/models/invoice.dart';

abstract class InvoiceManagerCubitState {}

class InvoiceManagerInitial extends InvoiceManagerCubitState {}

class InvoiceManagerLoading extends InvoiceManagerCubitState {}

class InvoiceManagerLoaded extends InvoiceManagerCubitState {
  final List<Invoice> invoices;
  InvoiceManagerLoaded(this.invoices);
}

class InvoiceManagerError extends InvoiceManagerCubitState {
  final String message;
  InvoiceManagerError(this.message);
}
