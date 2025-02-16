import 'package:ease/core/database/ledger/ledger_entry_dao.dart';
import 'package:ease/core/enums/ledger_enum_type.dart';
import 'package:ease/core/enums/transaction_type_enum.dart';
import 'package:ease/core/models/ledger_entry.dart';
import 'package:ease/features/expenses/bloc/expense_cubit_manager_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ExpenseManagerCubit extends Cubit<ExpenseManagerCubitState> {
  ExpenseManagerCubit(
    this._ledgerEntryDAO,
  ) : super(ExpenseManagerInitial());

  final LedgerEntryDAO _ledgerEntryDAO;

  late LedgerEntry _ledgerEntry;

  LedgerEntry get ledgerEntry => _ledgerEntry;

  set ledgerEntry(LedgerEntry ledgerEntry) {
    _ledgerEntry = ledgerEntry;
  }

  // Initialize a new ledger entry for expenses
  void initializeLedgerEntry(String invoiceNumber) {
    _ledgerEntry = LedgerEntry(
      type: LedgerEntryType.expense,
      invNumber: invoiceNumber,
      transactionDate: DateTime.now(),
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      amount: 0.0,
      transactionType: TransactionType.debit, // Expense is always a debit
      // Add other necessary fields
    );
    emit(ExpenseManagerInitialized(_ledgerEntry));
  }

  // Load an existing ledger entry
  // Future<void> loadLedgerEntry(String invoiceNumber) async {
  //   try {
  //     final ledgerEntry = await _ledgerEntryDAO.getLedgerEntryByInvoiceNumber(invoiceNumber);
  //     if (ledgerEntry != null) {
  //       _ledgerEntry = ledgerEntry;
  //       emit(ExpenseManagerLoaded(_ledgerEntry));
  //     } else {
  //       emit(ExpenseManagerError('Ledger entry not found'));
  //     }
  //   } catch (e) {
  //     emit(ExpenseManagerError(e.toString()));
  //   }
  // }

  // Insert a new ledger entry
  Future<void> insertLedgerEntry(LedgerEntry ledgerEntry) async {
    try {
      await _ledgerEntryDAO.createLedgerEntry(ledgerEntry);
      emit(ExpenseManagerEntryInserted(ledgerEntry));
    } catch (e) {
      emit(ExpenseManagerError(e.toString()));
    }
  }

  // Update an existing ledger entry
  Future<void> updateLedgerEntry(LedgerEntry ledgerEntry) async {
    try {
      await _ledgerEntryDAO.updateLedgerEntry(
          ledgerEntry.docId!, ledgerEntry.toJSON());
      emit(ExpenseManagerEntryUpdated(ledgerEntry));
    } catch (e) {
      emit(ExpenseManagerError(e.toString()));
    }
  }

  void setTransactionDate(DateTime value) {
    _ledgerEntry.transactionDate = value;
    emit(ExpenseManagerUpdated(_ledgerEntry));
  }
}
