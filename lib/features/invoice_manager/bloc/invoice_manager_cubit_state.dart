import 'package:ease/core/models/invoice.dart';
import 'package:ease/core/models/payment.dart';

abstract class InvoiceManagerCubitState {}

class InvoiceManagerInitial extends InvoiceManagerCubitState {}

class InvoiceManagerLoading extends InvoiceManagerCubitState {}

class InvoiceManagerLoaded extends InvoiceManagerCubitState {
  final Invoice invoice;

  InvoiceManagerLoaded({required this.invoice});
}

class InvoiceManagerError extends InvoiceManagerCubitState {
  final String message;
  InvoiceManagerError(this.message);
}

class InvoiceManagerPaymentsLoading extends InvoiceManagerCubitState {}

class InvoiceManagerPaymentsLoaded extends InvoiceManagerCubitState {
  final List<Payment> payments;

  InvoiceManagerPaymentsLoaded({required this.payments});
}
