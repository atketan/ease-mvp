import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ease/core/enums/payment_against_enum.dart';
import 'package:ease/core/utils/developer_log.dart';
import '../../models/payment.dart';
import 'payments_data_source.dart';
import 'package:intl/intl.dart';

class FirestorePaymentsDAO implements PaymentsDataSource {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String enterpriseId;

  FirestorePaymentsDAO({required this.enterpriseId});

  @override
  Future<String> insertPayment(Payment payment) async {
    final subCollectionName = getSubCollectionName(payment.paymentDate);
    final paymentData = payment.toJSON();

    debugLog('Inserting payment: ${payment.toJSON()}',
        name: 'FirestorePaymentsDAO');

    return await _firestore.runTransaction((transaction) async {
      // Store payment in the user's payments collection
      final userPaymentsRef = _firestore
          .collection('enterprises')
          .doc(enterpriseId)
          .collection(subCollectionName)
          .doc();
      transaction.set(userPaymentsRef, paymentData);

      // If the payment is associated with an invoice, store it as a subcollection under the invoice
      if (payment.invoiceId != null) {
        if (payment.paymentAgainst == PaymentType.sales ||
            payment.paymentAgainst == PaymentType.purchase) {
          final invoicePaymentsRef = _firestore
              .collection('enterprises')
              .doc(enterpriseId)
              .collection('invoices')
              .doc(payment.invoiceId.toString())
              .collection('payments')
              .doc(userPaymentsRef.id); // Use the same document ID
          transaction.set(invoicePaymentsRef, paymentData);
        } else if (payment.paymentAgainst == PaymentType.expense) {
          final invoicePaymentsRef = _firestore
              .collection('enterprises')
              .doc(enterpriseId)
              .collection('expenses')
              .doc(payment.invoiceId.toString())
              .collection('payments')
              .doc(userPaymentsRef.id); // Use the same document ID
          transaction.set(invoicePaymentsRef, paymentData);
        }
      }

      return userPaymentsRef.id; // Firestore does not return an integer ID
    });
  }

  @override
  Future<List<Payment>> getAllPayments() async {
    final snapshot = await _firestore
        .collectionGroup('payments')
        .where('enterpriseId', isEqualTo: enterpriseId)
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
        .collection('enterprises')
        .doc(enterpriseId)
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
    final subCollectionName = getSubCollectionName(payment.paymentDate);
    final paymentData = payment.toJSON();

    debugLog('Updating payment: ${payment.toJSON()}',
        name: 'FirestorePaymentsDAO');

    return await _firestore.runTransaction((transaction) async {
      // Update payment in the user's payments collection
      final userPaymentsRef = _firestore
          .collection('enterprises')
          .doc(enterpriseId)
          .collection(subCollectionName)
          .doc(payment.id.toString());
      transaction.update(userPaymentsRef, paymentData);

      // If the payment is associated with an invoice, update it in the subcollection under the invoice
      if (payment.invoiceId != null) {
        if (payment.paymentAgainst == PaymentType.sales ||
            payment.paymentAgainst == PaymentType.purchase) {
          final invoicePaymentsRef = _firestore
              .collection('enterprises')
              .doc(enterpriseId)
              .collection('invoices')
              .doc(payment.invoiceId.toString())
              .collection('payments')
              .doc(payment.id.toString());
          transaction.update(invoicePaymentsRef, paymentData);
        } else if (payment.paymentAgainst == PaymentType.expense) {
          final invoicePaymentsRef = _firestore
              .collection('enterprises')
              .doc(enterpriseId)
              .collection('expenses')
              .doc(payment.invoiceId.toString())
              .collection('payments')
              .doc(payment.id.toString());
          transaction.update(invoicePaymentsRef, paymentData);
        }
      }

      return 1; // Firestore does not return an update count
    });
  }

  @override
  Future<int> deletePayment(String id) async {
    final payment = await getPaymentById(id);
    if (payment == null) {
      throw Exception('Payment not found');
    }

    final subCollectionName = getSubCollectionName(payment.paymentDate);

    return await _firestore.runTransaction((transaction) async {
      // Delete payment from the user's payments collection
      final userPaymentsRef = _firestore
          .collection('enterprises')
          .doc(enterpriseId)
          .collection(subCollectionName)
          .doc(id);
      transaction.delete(userPaymentsRef);

      // If the payment is associated with an invoice, delete it from the subcollection under the invoice
      if (payment.invoiceId != null) {
        if (payment.paymentAgainst == PaymentType.sales ||
            payment.paymentAgainst == PaymentType.purchase) {
          final invoicePaymentsRef = _firestore
              .collection('enterprises')
              .doc(enterpriseId)
              .collection('invoices')
              .doc(payment.invoiceId.toString())
              .collection('payments')
              .doc(id);
          transaction.delete(invoicePaymentsRef);
        } else if (payment.paymentAgainst == PaymentType.expense) {
          final invoicePaymentsRef = _firestore
              .collection('enterprises')
              .doc(enterpriseId)
              .collection('expenses')
              .doc(payment.invoiceId.toString())
              .collection('payments')
              .doc(id);
          transaction.delete(invoicePaymentsRef);
        }
      }

      return 1; // Firestore does not return a delete count
    });
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

  String getSubCollectionName(DateTime date) {
    return 'payments_' + DateFormat('yyyy_MM').format(date);
  }

  @override
  Future<Payment?> getPaymentByInvoiceId(String? invoiceId) async {
    final snapshot = await _firestore
        .collection('enterprises')
        .doc(enterpriseId)
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

  @override
  Future<List<Payment>> getPaymentsByExpenseId(String expenseId) async {
    if (expenseId.isEmpty) {
      return [];
    }

    final snapshot = await _firestore
        .collection('enterprises')
        .doc(enterpriseId)
        .collection('expenses')
        .doc(expenseId)
        .collection('payments')
        .get();
    return snapshot.docs.map((doc) {
      final payment = Payment.fromJSON(doc.data());
      payment.id = doc.id;
      payment.invoiceId = expenseId;
      return payment;
    }).toList();
  }
}
