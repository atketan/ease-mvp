import 'package:ease/core/database/expenses/firestore_expenses_dao.dart';
import 'package:ease/core/database/payments/firestore_payments_dao.dart';
import 'package:ease/core/enums/payment_against_enum.dart';
import 'package:ease/core/models/expense.dart';
import 'package:ease/core/models/payment.dart';
import 'package:ease/core/utils/developer_log.dart';
import 'package:flutter/material.dart';
import 'dart:async';

class ExpensesProvider with ChangeNotifier {
  final FirestoreExpensesDAO _expensesDAO;
  final FirestorePaymentsDAO _paymentsDAO;

  DateTime _startDate = DateTime.now()
      .subtract(Duration(days: 30))
      .copyWith(hour: 0, minute: 0, second: 0, millisecond: 0, microsecond: 0);
  DateTime _endDate = DateTime.now().copyWith(
      hour: 23, minute: 59, second: 59, millisecond: 999, microsecond: 0);

  DateTime get startDate => _startDate;
  DateTime get endDate => _endDate;

  StreamSubscription<dynamic>? _expensesSubscription;

  List<Expense> _expenses = [];
  List<Expense> get expenses => _expenses;

  List<Payment> _payments = [];
  List<Payment> get payments => _payments;

  ExpensesProvider(this._expensesDAO, this._paymentsDAO) {
    subscribeToExpenses();
  }

  void setDateRange(DateTime start, DateTime end) {
    debugLog('setDateRange called with start: $start, end: $end',
        name: 'ExpenseProvider');

    // Cancel existing subscription
    _expensesSubscription?.cancel();

    _startDate = DateTime(start.year, start.month, start.day)
        .copyWith(hour: 0, minute: 0, second: 0, millisecond: 0);
    _endDate = DateTime(end.year, end.month, end.day, 23, 59, 59, 999);

    subscribeToExpenses();
  }

  void subscribeToExpenses() {
    _expensesSubscription = _expensesDAO
        .subscribeToExpenses(_startDate, _endDate)
        .listen((expenses) {
      _expenses = expenses;

      debugLog('SubscribeToExpenses, Fetched ${_expenses.length} expenses',
          name: 'ExpenseProvider');

      notifyListeners();
    }, onError: (e) {
      debugPrint('Error fetching expenses: $e');
    });
  }

  Future<void> insertExpense(Expense expense) async {
    String expenseId;
    try {
      expenseId = await _expensesDAO.insertExpense(expense);

      payments.forEach((payment) async {
        payment.invoiceId = expenseId;
        payment.paymentAgainst = PaymentAgainst.expense;
        await _paymentsDAO.insertPayment(payment);
      });
    } catch (e) {
      debugPrint('Error inserting expense: $e');
    }
  }

  Future<void> updateExpense(Expense expense) async {
    try {
      await _expensesDAO.updateExpense(expense);

      payments.forEach((payment) async {
        if (payment.id != null) {
          // Update existing payment
          await _paymentsDAO.updatePayment(payment);
        } else {
          // Insert new payment
          payment.invoiceId = expense.expenseId;
          await _paymentsDAO.insertPayment(payment);
        }
      });
    } catch (e) {
      debugPrint('Error updating expense: $e');
    }
  }

  Future<void> getPaymentsForExpense(String expenseId) async {
    try {
      debugPrint("Calling getPaymentsByExpenseId, expenseId: $expenseId");
      _payments = await _paymentsDAO.getPaymentsByExpenseId(expenseId);
      _payments.forEach((payment) {
        debugPrint("Payment: ${payment.toJSON().toString()}");
      });
    } catch (e) {
      debugPrint('Error fetching payments: $e');
      _payments = [];
    }
    notifyListeners();
  }

  @override
  void dispose() {
    _expensesSubscription?.cancel();
    super.dispose();
  }

  void addPaymentToArray(newPayment) {
    _payments.add(newPayment);
    notifyListeners();
  }
}
