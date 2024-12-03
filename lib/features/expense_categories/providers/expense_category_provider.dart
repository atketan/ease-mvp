import 'package:ease/core/database/expense_categories/firestore_expense_categories_dao.dart';
import 'package:ease/core/models/expense_category.dart';
import 'package:flutter/material.dart';
import 'dart:async';

class ExpenseCategoryProvider with ChangeNotifier {
  final FirestoreExpenseCategoriesDAO _expenseCategoriesDAO;
  StreamSubscription<dynamic>? _expenseCategoriesSubscription;

  List<ExpenseCategory> _expenseCategories = [];
  List<ExpenseCategory> get expenseCategories => _expenseCategories;

  ExpenseCategoryProvider(this._expenseCategoriesDAO) {
    subscribeToExpenseCategories();
  }

  void subscribeToExpenseCategories() {
    _expenseCategoriesSubscription = _expenseCategoriesDAO
        .subscribeToExpenseCategories()
        .listen((categories) {
      _expenseCategories = categories;
      notifyListeners();
    }, onError: (e) {
      debugPrint('Error fetching expense categories: $e');
    });
  }

  Future<void> insertExpenseCategory(ExpenseCategory category) async {
    try {
      await _expenseCategoriesDAO.insertExpenseCategory(category);
    } catch (e) {
      debugPrint('Error inserting expense category: $e');
    }
  }

  Future<void> updateExpenseCategory(ExpenseCategory category) async {
    try {
      await _expenseCategoriesDAO.updateExpenseCategory(category);
    } catch (e) {
      debugPrint('Error updating expense category: $e');
    }
  }

  @override
  void dispose() {
    _expenseCategoriesSubscription?.cancel();
    super.dispose();
  }
}
