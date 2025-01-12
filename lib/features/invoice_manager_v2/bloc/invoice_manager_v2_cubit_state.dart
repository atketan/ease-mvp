// import 'package:ease/core/models/invoice.dart';
import 'package:ease/core/models/ledger_entry.dart';

abstract class InvoiceManagerCubitState {}

class InvoiceManagerInitial extends InvoiceManagerCubitState {}

class InvoiceManagerLoading extends InvoiceManagerCubitState {}

class InvoiceManagerLoaded extends InvoiceManagerCubitState {
  // final Invoice invoice;
  final LedgerEntry ledgerEntry;

  InvoiceManagerLoaded({required this.ledgerEntry});
}

class InvoiceManagerError extends InvoiceManagerCubitState {
  final String message;
  InvoiceManagerError(this.message);
}
