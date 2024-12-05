import 'package:ease/core/database/expenses/firestore_expenses_dao.dart';
import 'package:ease/core/database/payments/firestore_payments_dao.dart';
import 'package:ease/core/models/expense.dart';
import 'package:ease/core/models/payment.dart';
import 'package:flutter/material.dart';
import 'dart:async';

class ExpensesProvider with ChangeNotifier {
  final FirestoreExpensesDAO _expensesDAO;
  final FirestorePaymentsDAO _paymentsDAO;
  StreamSubscription<dynamic>? _expensesSubscription;

  List<Expense> _expenses = [];
  List<Expense> get expenses => _expenses;

  List<Payment> _payments = [];
  List<Payment> get payments => _payments;

  ExpensesProvider(this._expensesDAO, this._paymentsDAO) {
    subscribeToExpenses();
  }

  void subscribeToExpenses() {
    _expensesSubscription =
        _expensesDAO.subscribeToExpenses().listen((expenses) {
      _expenses = expenses;
      notifyListeners();
    }, onError: (e) {
      debugPrint('Error fetching expenses: $e');
    });
  }

  Future<void> insertExpense(Expense expense) async {
    try {
      await _expensesDAO.insertExpense(expense);
    } catch (e) {
      debugPrint('Error inserting expense: $e');
    }
  }

  Future<void> updateExpense(Expense expense) async {
    try {
      await _expensesDAO.updateExpense(expense);
    } catch (e) {
      debugPrint('Error updating expense: $e');
    }
  }

  Future<void> insertPayment(Payment payment, String expenseId) async {
    try {
      await _paymentsDAO.insertPayment(payment);
    } catch (e) {
      debugPrint('Error inserting payment: $e');
    }
  }

  Future<void> updatePayment(Payment payment, String expenseId) async {
    try {
      await _paymentsDAO.updatePayment(payment);
    } catch (e) {
      debugPrint('Error updating payment: $e');
    }
  }

  Future<List<Payment>> getPaymentsForExpense(String expenseId) async {
    try {
      _payments = await _paymentsDAO.getPaymentsByExpenseId(expenseId);
    } catch (e) {
      debugPrint('Error fetching payments: $e');
      _payments = [];
    }
    return _payments;
  }

  @override
  void dispose() {
    _expensesSubscription?.cancel();
    super.dispose();
  }

  void addPaymentToArray(newPayment) {
    _payments.add(newPayment);
  }
}
