import 'package:flutter/material.dart';
import 'dart:developer' as developer;
import 'package:intl/intl.dart';
import '../../../core/database/invoices_dao.dart';
import '../../../core/database/vendors_dao.dart';
import '../../../core/database/customers_dao.dart';
import '../../../core/database/payment_history_dao.dart';
import '../../../core/models/invoice.dart';
import '../../../core/models/vendor.dart';
import '../../../core/models/customer.dart';
import '../../../core/models/payment_history.dart';

class InvoicesProvider with ChangeNotifier {
  final InvoicesDAO _invoicesDAO = InvoicesDAO();
  final VendorsDAO _vendorsDAO = VendorsDAO();
  final CustomersDAO _customersDAO = CustomersDAO();
  final PaymentHistoryDAO _paymentHistoryDAO = PaymentHistoryDAO();

  List<Invoice> _unpaidInvoices = [];
  List<Invoice> _paidInvoices = [];
  double _totalUnpaidAmount = 0.0;
  double _totalPaidAmount = 0.0;

  List<Invoice> get unpaidInvoices => _unpaidInvoices;
  List<Invoice> get paidInvoices => _paidInvoices;
  double get totalUnpaidAmount => _totalUnpaidAmount;
  double get totalPaidAmount => _totalPaidAmount;

  DateTime _startDate = DateTime.now().subtract(Duration(days: 30));
  DateTime _endDate = DateTime.now();
  DateTime get startDate => _startDate;
  DateTime get endDate => _endDate;

  bool _isFilterApplied = false;
  bool get isFilterApplied => _isFilterApplied;

  void setDateRange(DateTime start, DateTime end) {
    _startDate = DateTime(start.year, start.month, start.day);
    _endDate = DateTime(end.year, end.month, end.day, 23, 59, 59, 999);
    _isFilterApplied =
        (_startDate != DateTime.now().subtract(Duration(days: 30))) ||
            (_endDate.year != DateTime.now().year ||
                _endDate.month != DateTime.now().month ||
                _endDate.day != DateTime.now().day);
    debugPrint(_isFilterApplied.toString());
    fetchUnpaidInvoices();
    fetchPaidInvoices();
    notifyListeners();
  }

  void clearFilter() {
    _startDate = DateTime.now().subtract(Duration(days: 30));
    _endDate = DateTime.now();
    _isFilterApplied = false;
    fetchUnpaidInvoices();
    notifyListeners();
  }

  Future<void> fetchUnpaidInvoices() async {
    developer.log(
        'fetchUnpaidInvoices called with startDate: $_startDate, endDate: $_endDate');
    try {
      _unpaidInvoices =
          await _invoicesDAO.getInvoicesByDateRangeAndPaymentStatus(
        _startDate,
        _endDate,
        'unpaid', // Assuming 'unpaid' is the status for unpaid invoices
      );
      developer.log('Fetched ${_unpaidInvoices.length} unpaid invoices');
      _calculateTotalUnpaidAmount();
      notifyListeners();
    } catch (e) {
      developer.log('Error fetching unpaid invoices: $e');
      // Handle the error appropriately
    }
  }

  void _calculateTotalUnpaidAmount() {
    _totalUnpaidAmount = _unpaidInvoices.fold(
      0,
      (sum, invoice) => sum + invoice.totalAmount,
    );
    developer.log('Total unpaid amount: $_totalUnpaidAmount');
  }

  Future<void> fetchPaidInvoices() async {
    // print("Fetching paid invoices");
    // print("Start Date: $_startDate, End Date: $_endDate");
    _paidInvoices = await _invoicesDAO.getInvoicesByDateRangeAndPaymentStatus(
        _startDate, _endDate, "paid"); // Filter paid invoices
    print("Paid invoices: $_paidInvoices");
    _totalPaidAmount =
        _paidInvoices.fold(0, (sum, invoice) => sum + invoice.totalAmount);
    notifyListeners();
  }
}
