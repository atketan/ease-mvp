import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/expense_category.dart';
import 'expense_categories_data_source.dart';

class FirestoreExpenseCategoriesDAO implements ExpenseCategoriesDataSource {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String userId;

  FirestoreExpenseCategoriesDAO({required this.userId});

  @override
  Future<int> insertExpenseCategory(ExpenseCategory category) async {
    final docRef = await _firestore
        .collection('users')
        .doc(userId)
        .collection('expenseCategories')
        .add(category.toJSON());
    return docRef.id.hashCode; // Firestore does not return an integer ID
  }

  @override
  Future<List<ExpenseCategory>> getAllExpenseCategories() async {
    final snapshot = await _firestore
        .collection('users')
        .doc(userId)
        .collection('expenseCategories')
        .get();
    return snapshot.docs
        .map((doc) => ExpenseCategory.fromJSON(doc.data()))
        .toList();
  }

  @override
  Future<int> updateExpenseCategory(ExpenseCategory category) async {
    await _firestore
        .collection('users')
        .doc(userId)
        .collection('expenseCategories')
        .doc(category.id.toString())
        .update(category.toJSON());
    return 1; // Firestore does not return an update count
  }

  @override
  Future<int> deleteExpenseCategory(String expenseId) async {
    await _firestore
        .collection('users')
        .doc(userId)
        .collection('expenseCategories')
        .doc(expenseId.toString())
        .delete();
    return 1; // Firestore does not return a delete count
  }

  Stream<List<ExpenseCategory>> subscribeToExpenseCategories() {
    return _firestore
        .collection('users')
        .doc(userId)
        .collection('expenseCategories')
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        final expenseCategory = ExpenseCategory.fromJSON(doc.data());
        expenseCategory.categoryId = doc.id;
        return expenseCategory;
      }).toList();
    });
  }
}
