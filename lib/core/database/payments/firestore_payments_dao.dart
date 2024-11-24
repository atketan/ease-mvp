import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/payment.dart';
import 'payments_data_source.dart';
import 'package:intl/intl.dart';

class FirestorePaymentsDAO implements PaymentsDataSource {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String userId;

  FirestorePaymentsDAO({required this.userId});

  @override
  Future<String> insertPayment(Payment payment) async {
    final paymentSubCollectionName =
        getPaymentSubCollectionName(payment.paymentDate);

    final paymentData = payment.toJSON();

    // Store payment in the user's payments collection
    final userPaymentsRef = await _firestore
        .collection('users')
        .doc(userId)
        .collection(paymentSubCollectionName)
        .add(paymentData);

    // If the payment is associated with an invoice, store it as a subcollection under the invoice
    if (payment.invoiceId != null) {
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('invoices')
          .doc(payment.invoiceId.toString())
          .collection('payments')
          .add(paymentData);
    }

    return userPaymentsRef.id; // Firestore does not return an integer ID
  }

  @override
  Future<List<Payment>> getAllPayments() async {
    final snapshot = await _firestore
        .collectionGroup('payments')
        .where('userId', isEqualTo: userId)
        .get();
    return snapshot.docs.map((doc) {
      final payment = Payment.fromJSON(doc.data());
      payment.id = doc.id;
      payment.invoiceId = doc['invoice_id'] ?? '';
      return payment;
    }).toList();
  }

  @override
  Future<List<Payment>> getPaymentsByInvoiceId(String invoiceId) async {
    if (invoiceId.isEmpty) {
      return [];
    }

    final snapshot = await _firestore
        .collection('users')
        .doc(userId)
        .collection('invoices')
        .doc(invoiceId)
        .collection('payments')
        .get();
    return snapshot.docs.map((doc) {
      final payment = Payment.fromJSON(doc.data());
      payment.id = doc.id;
      payment.invoiceId = invoiceId;
      return payment;
    }).toList();
  }

  @override
  Future<int> updatePayment(Payment payment) async {
    final subCollectionName = getPaymentSubCollectionName(payment.paymentDate);
    await _firestore
        .collection('users')
        .doc(userId)
        .collection(subCollectionName)
        .doc(payment.id.toString())
        .update(payment.toJSON());

    if (payment.invoiceId != null) {
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('invoices')
          .doc(payment.invoiceId.toString())
          .collection('payments')
          .doc(payment.id.toString())
          .update(payment.toJSON());
    }

    return 1; // Firestore does not return an update count
  }

  @override
  Future<int> deletePayment(String id) async {
    final payment = await getPaymentById(id);
    if (payment == null) {
      throw Exception('Payment not found');
    }

    final subCollectionName = getPaymentSubCollectionName(payment.paymentDate);
    await _firestore
        .collection('users')
        .doc(userId)
        .collection(subCollectionName)
        .doc(id)
        .delete();

    if (payment.invoiceId != null) {
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('invoices')
          .doc(payment.invoiceId.toString())
          .collection('payments')
          .doc(id)
          .delete();
    }

    return 1; // Firestore does not return a delete count
  }

  Future<Payment?> getPaymentById(String id) async {
    final snapshot = await _firestore
        .collectionGroup('payments')
        .where('id', isEqualTo: id)
        .get();
    if (snapshot.docs.isNotEmpty) {
      return Payment.fromJSON(snapshot.docs.first.data());
    } else {
      return null;
    }
  }

  String getPaymentSubCollectionName(DateTime date) {
    return 'payments_' + DateFormat('yyyy_MM').format(date);
  }

  @override
  Future<Payment?> getPaymentByInvoiceId(String? invoiceId) async {
    final snapshot = await _firestore
        .collection('users')
        .doc(userId)
        .collection('invoices')
        .doc(invoiceId)
        .collection('payments')
        .get();

    if (snapshot.docs.isNotEmpty) {
      return Payment.fromJSON(snapshot.docs.first.data());
    } else {
      return null;
    }
  }
}
