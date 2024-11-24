import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:intl/intl.dart';
import '../../models/invoice.dart';
import 'invoices_data_source.dart';

class FirestoreInvoicesDAO implements InvoicesDataSource {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String userId;

  FirestoreInvoicesDAO({required this.userId});

  @override
  Future<String> insertInvoice(Invoice invoice) async {
    // final invoiceSubCollectionName = getInvoiceSubCollectionName(
    //   invoice.date,
    // ); // Using time-based sharding collections to store invoices

    final docRef = await _firestore
        .collection('users')
        .doc(userId)
        .collection('invoices')
        .add(invoice.toJSON());

    return docRef.id; // Firestore does not return an integer ID
  }

  @override
  Future<List<Invoice>> getAllInvoices() async {
    final snapshot = await _firestore
        .collection('users')
        .doc(userId)
        .collection('invoices')
        .get();
    return snapshot.docs.map((doc) => Invoice.fromJSON(doc.data())).toList();
  }

  @override
  Future<Invoice?> getInvoiceById(String invoiceId) async {
    final doc = await _firestore
        .collection('users')
        .doc(userId)
        .collection('invoices')
        .doc(invoiceId.toString())
        .get();
    if (doc.exists) {
      return Invoice.fromJSON(doc.data()!);
    } else {
      return null;
    }
  }

  @override
  Future<int> updateInvoice(Invoice invoice) async {
    await _firestore
        .collection('users')
        .doc(userId)
        .collection('invoices')
        .doc(invoice.id.toString())
        .update(invoice.toJSON());
    return 1; // Firestore does not return an update count
  }

  @override
  Future<int> deleteInvoice(String invoiceId) async {
    await _firestore
        .collection('users')
        .doc(userId)
        .collection('invoices')
        .doc(invoiceId.toString())
        .delete();
    return 1; // Firestore does not return a delete count
  }

  @override
  Future<int> markInvoiceAsPaid(String invoiceId) async {
    await _firestore
        .collection('users')
        .doc(userId)
        .collection('invoices')
        .doc(invoiceId.toString())
        .update({'status': 'paid'});
    return 1; // Firestore does not return an update count
  }

  @override
  Future<List<Invoice>> getInvoicesByDateRangeAndPaymentStatus(
      DateTime startDate, DateTime endDate, String status) async {
    final snapshot = await _firestore
        .collection('users')
        .doc(userId)
        .collection('invoices')
        // .where('date', isGreaterThanOrEqualTo: startDate.toIso8601String())
        // .where('date', isLessThanOrEqualTo: endDate.toIso8601String())
        // .where('status', isEqualTo: status)
        .get();
    // TODO: temporarily removing the search filters to avoid index failure in Firestore
    // Also, may need to rethink this entire logic to ensure the database is not overloaded with filtration especially since its a NoSQL database now
    return snapshot.docs.map((doc) => Invoice.fromJSON(doc.data())).toList();
  }

  @override
  Future<List<Invoice>> getSalesInvoicesByDateRange(
      DateTime startDate, DateTime endDate) async {
    final snapshot = await _firestore
        .collection('users')
        .doc(userId)
        .collection('invoices')
        // .where('date', isGreaterThanOrEqualTo: startDate.toIso8601String())
        // .where('date', isLessThanOrEqualTo: endDate.toIso8601String())
        // .where('type', isEqualTo: 'sales')
        // TODO: temporarily removing the search filters to avoid index failure in Firestore
        // Also, may need to rethink this entire logic to ensure the database is not overloaded with filtration especially since its a NoSQL database now
        .get();
    return snapshot.docs.map((doc) => Invoice.fromJSON(doc.data())).toList();
  }

  // getInvoiceSubCollectionName(DateTime date) {
  //   return 'invoices_' + DateFormat('yyyy_MM').format(date);
  // }
}
