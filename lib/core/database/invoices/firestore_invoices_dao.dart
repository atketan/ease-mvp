import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:intl/intl.dart';
import '../../models/invoice.dart';
import 'invoices_data_source.dart';

class FirestoreInvoicesDAO implements InvoicesDataSource {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String enterpriseId;

  FirestoreInvoicesDAO({required this.enterpriseId});

  @override
  Future<String> insertInvoice(Invoice invoice) async {
    // final invoiceSubCollectionName = getInvoiceSubCollectionName(
    //   invoice.date,
    // ); // Using time-based sharding collections to store invoices

    final docRef = await _firestore
        .collection('enterprises')
        .doc(enterpriseId)
        .collection('invoices')
        .add(invoice.toJSON());

    return docRef.id; // Firestore does not return an integer ID
  }

  @override
  Future<List<Invoice>> getAllInvoices() async {
    final snapshot = await _firestore
        .collection('enterprises')
        .doc(enterpriseId)
        .collection('invoices')
        .get();
    return snapshot.docs.map((doc) {
      final invoice = Invoice.fromJSON(doc.data());
      invoice.invoiceId = doc.id;
      return invoice;
    }).toList();
  }

  @override
  Future<Invoice?> getInvoiceById(String invoiceId) async {
    final doc = await _firestore
        .collection('enterprises')
        .doc(enterpriseId)
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
        .collection('enterprises')
        .doc(enterpriseId)
        .collection('invoices')
        .doc(invoice.invoiceId.toString())
        .update(invoice.toJSON());
    return 1; // Firestore does not return an update count
  }

  @override
  Future<int> deleteInvoice(String invoiceId) async {
    await _firestore
        .collection('enterprises')
        .doc(enterpriseId)
        .collection('invoices')
        .doc(invoiceId.toString())
        .delete();
    return 1; // Firestore does not return a delete count
  }

  @override
  Future<int> markInvoiceAsPaid(String invoiceId) async {
    await _firestore
        .collection('enterprises')
        .doc(enterpriseId)
        .collection('invoices')
        .doc(invoiceId.toString())
        .update({'status': 'paid'});
    return 1; // Firestore does not return an update count
  }

  @override
  Future<List<Invoice>> getInvoicesByDateRangeAndPaymentStatus(
      DateTime startDate, DateTime endDate, String status) async {
    final snapshot = await _firestore
        .collection('enterprises')
        .doc(enterpriseId)
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
        .collection('enterprises')
        .doc(enterpriseId)
        .collection('invoices')
        .where('date', isGreaterThanOrEqualTo: startDate.toIso8601String())
        .where('date', isLessThanOrEqualTo: endDate.toIso8601String())
        // .where('type', isEqualTo: 'sales')
        // TODO: temporarily removing the search filters to avoid index failure in Firestore
        // Also, may need to rethink this entire logic to ensure the database is not overloaded with filtration especially since its a NoSQL database now
        .get();
    return snapshot.docs.map((doc) {
      Invoice invoice = Invoice.fromJSON(doc.data());
      invoice.invoiceId = doc.id;
      return invoice;
    }).toList();
  }

  // getInvoiceSubCollectionName(DateTime date) {
  //   return 'invoices_' + DateFormat('yyyy_MM').format(date);
  // }

  @override
  Stream<List<Invoice>> subscribeToInvoices(
      DateTime startDate, DateTime endDate) {
    return _firestore
        .collection('enterprises')
        .doc(enterpriseId)
        .collection('invoices')
        .where('date', isGreaterThanOrEqualTo: startDate.toIso8601String())
        .where('date', isLessThanOrEqualTo: endDate.toIso8601String())
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) {
            final invoice = Invoice.fromJSON(doc.data());
            invoice.invoiceId = doc.id;
            return invoice;
          })
          // .where((invoice) =>
          //     invoice.date.isAfter(startDate) && invoice.date.isBefore(endDate))
          .toList();
    });
  }
}
