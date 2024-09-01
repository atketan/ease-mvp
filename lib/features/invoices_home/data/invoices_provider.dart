import 'package:flutter/material.dart';
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

  Future<void> fetchUnpaidInvoices() async {
    _unpaidInvoices = await _invoicesDAO.getAllInvoices(); // Filter unpaid invoices
    _totalUnpaidAmount = _unpaidInvoices.fold(0, (sum, invoice) => sum + invoice.totalAmount);
    notifyListeners();
  }

  Future<void> fetchPaidInvoices(DateTime startDate, DateTime endDate) async {
    _paidInvoices = await _invoicesDAO.getInvoicesByDateRangeAndPaymentStatus(startDate, endDate, "paid"); // Filter paid invoices
    _totalPaidAmount = _paidInvoices.fold(0, (sum, invoice) => sum + invoice.totalAmount);
    notifyListeners();
  }
}