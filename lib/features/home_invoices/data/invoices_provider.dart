import 'package:ease/core/utils/developer_log.dart';
import 'package:flutter/material.dart';
import '../../../core/database/invoices/invoices_dao.dart';
import '../../../core/models/invoice.dart';

class InvoicesProvider with ChangeNotifier {
  DateTime defaultStartDate;
  DateTime defaultEndDate;
  DateTime _startDate;
  DateTime _endDate;

  InvoicesProvider(this._invoicesDAO)
      : defaultStartDate = DateTime.now().subtract(Duration(days: 30)).copyWith(
            hour: 0, minute: 0, second: 0, millisecond: 0, microsecond: 0),
        defaultEndDate = DateTime.now().copyWith(
            hour: 23, minute: 59, second: 59, millisecond: 999, microsecond: 0),
        _startDate = DateTime.now().subtract(Duration(days: 30)).copyWith(
            hour: 0, minute: 0, second: 0, millisecond: 0, microsecond: 0),
        _endDate = DateTime.now().copyWith(
            hour: 23, minute: 59, second: 59, millisecond: 999, microsecond: 0);

  final InvoicesDAO _invoicesDAO;
  // final VendorsDAO _vendorsDAO = VendorsDAO();
  // final CustomersDAO _customersDAO = CustomersDAO();
  // final PaymentHistoryDAO _paymentHistoryDAO = PaymentHistoryDAO();

  List<Invoice> _unpaidInvoices = [];
  List<Invoice> _paidInvoices = [];
  double _totalUnpaidAmount = 0.0;
  double _totalPaidAmount = 0.0;

  List<Invoice> _allSalesInvoices = [];
  List<Invoice> _allPurchaseInvoices = [];
  List<Invoice> get allSalesInvoices => _allSalesInvoices;
  List<Invoice> get allPurchaseInvoices => _allPurchaseInvoices;

  List<Invoice> get unpaidInvoices => _unpaidInvoices;
  List<Invoice> get paidInvoices => _paidInvoices;
  double get totalUnpaidAmount => _totalUnpaidAmount;
  double get totalPaidAmount => _totalPaidAmount;

  DateTime get startDate => _startDate;
  DateTime get endDate => _endDate;

  bool _isFilterApplied = false;
  bool get isFilterApplied => _isFilterApplied;

  void setDateRange(DateTime start, DateTime end) {
    debugLog('setDateRange called with start: $start, end: $end',
        name: 'InvoicesProvider');
    _startDate = DateTime(start.year, start.month, start.day)
        .copyWith(hour: 0, minute: 0, second: 0, millisecond: 0);
    _endDate = DateTime(end.year, end.month, end.day, 23, 59, 59, 999);

    _isFilterApplied =
        !((_startDate == defaultStartDate) && (_endDate == defaultEndDate));

    fetchUnpaidInvoices();
    fetchPaidInvoices();
    fetchAllSalesInvoices();
    notifyListeners();
  }

  void clearFilter() {
    _startDate = defaultStartDate;
    _endDate = defaultEndDate;
    _isFilterApplied = false;
    fetchUnpaidInvoices();
    fetchAllSalesInvoices();
    notifyListeners();
  }

  Future<void> fetchAllSalesInvoices() async {
    debugLog(
        'fetchAllSalesInvoices called with startDate: $_startDate, endDate: $_endDate',
        name: 'InvoicesProvider');
    try {
      _allSalesInvoices =
          await _invoicesDAO.getSalesInvoicesByDateRange(_startDate, _endDate);
      debugLog('Fetched ${_allSalesInvoices.length} sales invoices',
          name: 'InvoicesProvider');
      _calculateTotalPaidAmount();
      _calculateTotalUnpaidAmount();
      notifyListeners();
    } catch (e) {
      debugLog('Error fetching paid invoices: $e', name: 'InvoicesProvider');
      // Handle the error appropriately
    }
  }

  Future<void> fetchUnpaidInvoices() async {
    debugLog(
        'fetchUnpaidInvoices called with startDate: $_startDate, endDate: $_endDate',
        name: 'InvoicesProvider');
    try {
      _unpaidInvoices =
          await _invoicesDAO.getInvoicesByDateRangeAndPaymentStatus(
        _startDate,
        _endDate,
        'unpaid', // Assuming 'unpaid' is the status for unpaid invoices
      );
      debugLog('Fetched ${_unpaidInvoices.length} unpaid invoices',
          name: 'InvoicesProvider');
      _calculateTotalUnpaidAmount();
      notifyListeners();
    } catch (e) {
      debugLog('Error fetching unpaid invoices: $e', name: 'InvoicesProvider');
      // Handle the error appropriately
    }
  }

  void _calculateTotalUnpaidAmount() {
    _totalUnpaidAmount = _unpaidInvoices.fold(
      0,
      (sum, invoice) => sum + invoice.grandTotal,
    );
    debugLog('Total unpaid amount: $_totalUnpaidAmount',
        name: 'InvoicesProvider');
  }

  Future<void> fetchPaidInvoices() async {
    debugLog(
        'fetchPaidInvoices called with startDate: $_startDate, endDate: $_endDate',
        name: 'InvoicesProvider');
    try {
      _paidInvoices = await _invoicesDAO.getInvoicesByDateRangeAndPaymentStatus(
        _startDate,
        _endDate,
        'paid', // Assuming 'paid' is the status for paid invoices
      );
      debugLog('Fetched ${_paidInvoices.length} paid invoices',
          name: 'InvoicesProvider');
      _calculateTotalPaidAmount();
      notifyListeners();
    } catch (e) {
      debugLog('Error fetching paid invoices: $e', name: 'InvoicesProvider');
      // Handle the error appropriately
    }
  }

  void _calculateTotalPaidAmount() {
    _totalPaidAmount = _paidInvoices.fold(
      0,
      (sum, invoice) => sum + invoice.grandTotal,
    );
    debugLog('Total paid amount: $_totalPaidAmount', name: 'InvoicesProvider');
  }

  Future<void> markInvoiceAsPaid(Invoice invoice) async {
    try {
      await _invoicesDAO.markInvoiceAsPaid(invoice.invoiceId!);
      _unpaidInvoices.remove(invoice);
      _calculateTotalUnpaidAmount();
      _calculateTotalPaidAmount();
      notifyListeners();
    } catch (e) {
      debugLog('Error marking invoice as paid: $e', name: 'InvoicesProvider');
      // Handle the error appropriately
    }
  }
}
