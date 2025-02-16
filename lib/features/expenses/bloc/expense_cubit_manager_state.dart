import 'package:ease/core/models/ledger_entry.dart';
import 'package:equatable/equatable.dart';

abstract class ExpenseManagerCubitState extends Equatable {
  const ExpenseManagerCubitState();

  @override
  List<Object> get props => [];
}

class ExpenseManagerInitial extends ExpenseManagerCubitState {}

class ExpenseManagerInitialized extends ExpenseManagerCubitState {
  final LedgerEntry ledgerEntry;

  const ExpenseManagerInitialized(this.ledgerEntry);

  @override
  List<Object> get props => [ledgerEntry];
}

class ExpenseManagerLoaded extends ExpenseManagerCubitState {
  final LedgerEntry ledgerEntry;

  const ExpenseManagerLoaded(this.ledgerEntry);

  @override
  List<Object> get props => [ledgerEntry];
}

class ExpenseManagerEntryInserted extends ExpenseManagerCubitState {
  final LedgerEntry ledgerEntry;

  const ExpenseManagerEntryInserted(this.ledgerEntry);

  @override
  List<Object> get props => [ledgerEntry];
}

class ExpenseManagerEntryUpdated extends ExpenseManagerCubitState {
  final LedgerEntry ledgerEntry;

  const ExpenseManagerEntryUpdated(this.ledgerEntry);

  @override
  List<Object> get props => [ledgerEntry];
}

class ExpenseManagerUpdated extends ExpenseManagerCubitState {
  final LedgerEntry ledgerEntry;

  const ExpenseManagerUpdated(this.ledgerEntry);

  @override
  List<Object> get props => [ledgerEntry];
}

class ExpenseManagerError extends ExpenseManagerCubitState {
  final String message;

  const ExpenseManagerError(this.message);

  @override
  List<Object> get props => [message];
}
