import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/payment.dart';
import 'payments_data_source.dart';

class FirestorePaymentsDAO implements PaymentsDataSource {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Future<int> insertPayment(Payment payment) async {
    final docRef =
        await _firestore.collection('payments').add(payment.toJSON());
    return docRef.id.hashCode; // Firestore does not return an integer ID
  }

  @override
  Future<List<Payment>> getAllPayments() async {
    final snapshot = await _firestore.collection('payments').get();
    return snapshot.docs.map((doc) => Payment.fromJSON(doc.data())).toList();
  }

  @override
  Future<int> updatePayment(Payment payment) async {
    await _firestore
        .collection('payments')
        .doc(payment.id.toString())
        .update(payment.toJSON());
    return 1; // Firestore does not return an update count
  }

  @override
  Future<int> deletePayment(String id) async {
    await _firestore.collection('payments').doc(id.toString()).delete();
    return 1; // Firestore does not return a delete count
  }

  @override
  Future<Payment?> getPaymentById(String paymentId) async {
    final doc =
        await _firestore.collection('payments').doc(paymentId.toString()).get();
    if (doc.exists) {
      return Payment.fromJSON(doc.data()!);
    } else {
      return null;
    }
  }

  @override
  Future<Payment?> getPaymentByInvoiceId(String? invoiceId) async {
    final snapshot = await _firestore
        .collection('payments')
        .where('invoice_id', isEqualTo: invoiceId)
        .get();
    if (snapshot.docs.isNotEmpty) {
      return Payment.fromJSON(snapshot.docs.first.data());
    } else {
      return null;
    }
  }
}
