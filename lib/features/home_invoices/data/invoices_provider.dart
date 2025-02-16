import 'package:ease/core/database/ledger/ledger_entry_dao.dart';
import 'package:ease/core/enums/ledger_enum_type.dart';
import 'package:ease/core/enums/transaction_category_enum.dart';
import 'package:ease/core/models/ledger_entry.dart';
import 'package:ease/core/utils/developer_log.dart';
import 'package:flutter/material.dart';
// import '../../../core/database/invoices/invoices_dao.dart';
// import '../../../core/models/invoice.dart';
import 'dart:async';

class InvoicesProvider with ChangeNotifier {
  DateTime defaultStartDate;
  DateTime defaultEndDate;
  DateTime _startDate;
  DateTime _endDate;
  StreamSubscription<dynamic>? _invoicesSubscription;

  // InvoicesProvider(this._invoicesDAO)
  InvoicesProvider(this._ledgerEntryDAO)
      : defaultStartDate = DateTime.now().subtract(Duration(days: 30)).copyWith(
            hour: 0, minute: 0, second: 0, millisecond: 0, microsecond: 0),
        defaultEndDate = DateTime.now().copyWith(
            hour: 23, minute: 59, second: 59, millisecond: 999, microsecond: 0),
        _startDate = DateTime.now().subtract(Duration(days: 30)).copyWith(
            hour: 0, minute: 0, second: 0, millisecond: 0, microsecond: 0),
        _endDate = DateTime.now().copyWith(
            hour: 23, minute: 59, second: 59, millisecond: 999, microsecond: 0);

  // final InvoicesDAO _invoicesDAO;
  // final VendorsDAO _vendorsDAO = VendorsDAO();
  // final CustomersDAO _customersDAO = CustomersDAO();
  // final PaymentHistoryDAO _paymentHistoryDAO = PaymentHistoryDAO();

  final LedgerEntryDAO _ledgerEntryDAO;

  // List<LedgerEntry> _unpaidInvoices = [];
  // List<LedgerEntry> _paidInvoices = [];
  double _totalUnpaidAmount = 0.0;
  double _totalExpensesAmount = 0.0;
  double _totalSalesAmount = 0.0;
  double _totalPurchaseAmount = 0.0;

  List<LedgerEntry> _allSalesInvoices = [];
  List<LedgerEntry> _allPurchaseInvoices = [];
  List<LedgerEntry> get allSalesInvoices => _allSalesInvoices;
  List<LedgerEntry> get allPurchaseInvoices => _allPurchaseInvoices;

  List<LedgerEntry> _allExpenseInvoices = [];
  List<LedgerEntry> get allExpenseInvoices => _allExpenseInvoices;
  List<LedgerEntry> _allPaymentInvoices = [];
  List<LedgerEntry> get allPaymentInvoices => _allPaymentInvoices;

  List<LedgerEntry> get unpaidInvoices =>
      _allSalesInvoices.where((invoice) => invoice.status != 'paid').toList();
  List<LedgerEntry> get paidInvoices =>
      _allSalesInvoices.where((invoice) => invoice.status == 'paid').toList();
  List<LedgerEntry> get unpaidPurchases => _allPurchaseInvoices
      .where((invoice) => invoice.status != 'paid')
      .toList();
  List<LedgerEntry> get paidPurchases => _allPurchaseInvoices
      .where((invoice) => invoice.status == 'paid')
      .toList();

  double get totalUnpaidAmount => _totalUnpaidAmount;
  double get totalSalesAmount => _totalSalesAmount;
  double get totalPurchaseAmount => _totalPurchaseAmount;
  double get totalExpensesAmount => _totalExpensesAmount;

  DateTime get startDate => _startDate;
  DateTime get endDate => _endDate;

  bool _isFilterApplied = false;
  bool get isFilterApplied => _isFilterApplied;

  void setDateRange(DateTime start, DateTime end) {
    // Cancel existing subscription
    _invoicesSubscription?.cancel();

    _startDate = DateTime(start.year, start.month, start.day)
        .copyWith(hour: 0, minute: 0, second: 0, millisecond: 0);
    _endDate = DateTime(end.year, end.month, end.day, 23, 59, 59, 999);

    _isFilterApplied =
        !((_startDate == defaultStartDate) && (_endDate == defaultEndDate));

    subscribeToInvoices();
  }

  void clearFilter() {
    _startDate = defaultStartDate;
    _endDate = defaultEndDate;
    _isFilterApplied = false;
    // fetchUnpaidInvoices();
    // fetchAllSalesInvoices();
    notifyListeners();
  }

  void subscribeToInvoices() {
    _invoicesSubscription = _ledgerEntryDAO
        .getLedgerEntriesStream(startDate: _startDate, endDate: _endDate)
        .listen((invoices) {
      debugLog(
          'Start date: $_startDate, End date: $_endDate, Length: ${invoices.length}',
          name: 'InvoicesProvider');

      _allSalesInvoices = invoices
          .where((invoice) =>
              invoice.type == LedgerEntryType.invoice &&
              invoice.transactionCategory == TransactionCategory.sales)
          .toList();
      _allPurchaseInvoices = invoices
          .where((invoice) =>
              invoice.type == LedgerEntryType.invoice &&
              invoice.transactionCategory == TransactionCategory.purchase)
          .toList();

      _allExpenseInvoices = invoices
          .where((invoice) => invoice.type == LedgerEntryType.expense)
          .toList();

      _allPaymentInvoices = invoices
          .where((invoice) => invoice.type == LedgerEntryType.payment)
          .toList();

      debugLog(
          'SubscribeToInvoices, Fetched ${_allSalesInvoices.length} sales invoices',
          name: 'InvoicesProvider');
      debugLog(
          'SubscribeToInvoices, Fetched ${_allPurchaseInvoices.length} purchase invoices',
          name: 'InvoicesProvider');
      debugLog(
          'SubscribeToInvoices, Fetched ${_allExpenseInvoices.length} expense invoices',
          name: 'InvoicesProvider');
      debugLog(
          'SubscribeToInvoices, Fetched ${_allPaymentInvoices.length} payment invoices',
          name: 'InvoicesProvider');

      _calculateTotalSalesAmount();
      _calculateTotalPurchaseAmount();
      _calculateTotalExpensesAmount();

      notifyListeners();
    }, onError: (e) {
      debugLog('Error fetching sales invoices: $e', name: 'InvoicesProvider');
      // Handle the error appropriately
    });
  }

  void _calculateTotalSalesAmount() {
    _totalSalesAmount = _allSalesInvoices.fold(
      0,
      (sum, invoice) => sum + (invoice.grandTotal ?? 0.0),
    );
  }

  void _calculateTotalPurchaseAmount() {
    _totalPurchaseAmount = _allPurchaseInvoices.fold(
      0,
      (sum, invoice) => sum + (invoice.grandTotal ?? 0.0),
    );
  }

  void _calculateTotalExpensesAmount() {
    _totalExpensesAmount = _allExpenseInvoices.fold(
      0,
      (sum, invoice) => sum + (invoice.grandTotal ?? 0.0),
    );
  }

  @override
  void dispose() {
    _invoicesSubscription?.cancel();
    super.dispose();
  }
}
