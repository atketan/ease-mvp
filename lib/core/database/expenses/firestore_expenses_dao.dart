import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ease/core/utils/developer_log.dart';
import '../../models/expense.dart';
import 'expenses_data_source.dart';

class FirestoreExpensesDAO implements ExpensesDataSource {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String userId;

  FirestoreExpensesDAO({required this.userId});

  @override
  Future<String> insertExpense(Expense expense) async {
    debugLog("Inserting expense: ${expense.toJSON().toString()}",
        name: "FirestoreExpensesDAO");

    final docRef = await _firestore
        .collection('users')
        .doc(userId)
        .collection('expenses')
        .add(expense.toJSON());
    return docRef.id; // Firestore does not return an integer ID
  }

  @override
  Future<List<Expense>> getAllExpenses() async {
    final snapshot = await _firestore
        .collection('users')
        .doc(userId)
        .collection('expenses')
        .get();
    return snapshot.docs.map((doc) => Expense.fromJSON(doc.data())).toList();
  }

  @override
  Future<int> updateExpense(Expense expense) async {
    debugLog("Updating expense: ${expense.toJSON().toString()}",
        name: "FirestoreExpensesDAO");

    await _firestore
        .collection('users')
        .doc(userId)
        .collection('expenses')
        .doc(expense.id.toString())
        .update(expense.toJSON());
    return 1; // Firestore does not return an update count
  }

  @override
  Future<int> deleteExpense(String expenseId) async {
    debugLog("Deleting expense: ${expenseId.toString()}",
        name: "FirestoreExpensesDAO");

    await _firestore
        .collection('users')
        .doc(userId)
        .collection('expenses')
        .doc(expenseId.toString())
        .delete();
    return 1; // Firestore does not return a delete count
  }

  Stream<List<Expense>> subscribeToExpenses(
      DateTime startDate, DateTime endDate) {
    return _firestore
        .collection('users')
        .doc(userId)
        .collection('expenses')
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) {
            final expense = Expense.fromJSON(doc.data());
            expense.expenseId = doc.id;
            return expense;
          })
          .where((expense) =>
              expense.createdAt.isAfter(startDate) &&
              expense.createdAt.isBefore(endDate))
          .toList();
    });
  }
}
