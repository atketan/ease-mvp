import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/expense.dart';
import 'expenses_data_source.dart';

class FirestoreExpensesDAO implements ExpensesDataSource {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String userId;

  FirestoreExpensesDAO({required this.userId});

  @override
  Future<int> insertExpense(Expense expense) async {
    final docRef = await _firestore
        .collection('users')
        .doc(userId)
        .collection('expenses').add(expense.toJSON());
    return docRef.id.hashCode; // Firestore does not return an integer ID
  }

  @override
  Future<List<Expense>> getAllExpenses() async {
    final snapshot = await _firestore
        .collection('users')
        .doc(userId)
        .collection('expenses').get();
    return snapshot.docs.map((doc) => Expense.fromJSON(doc.data())).toList();
  }

  @override
  Future<int> updateExpense(Expense expense) async {
    await _firestore
        .collection('users')
        .doc(userId)
        .collection('expenses').doc(expense.id.toString()).update(expense.toJSON());
    return 1; // Firestore does not return an update count
  }

  @override
  Future<int> deleteExpense(String expenseId) async {
    await _firestore
        .collection('users')
        .doc(userId)
        .collection('expenses').doc(expenseId.toString()).delete();
    return 1; // Firestore does not return a delete count
  }
}