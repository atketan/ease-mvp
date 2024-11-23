import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/invoice_item.dart';
import 'invoice_items_data_source.dart';

class FirestoreInvoiceItemsDAO implements InvoiceItemsDataSource {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Future<int> insertInvoiceItem(InvoiceItem invoiceItem) async {
    final docRef = await _firestore.collection('invoiceItems').add(invoiceItem.toJSON());
    return docRef.id.hashCode; // Firestore does not return an integer ID
  }

  @override
  Future<List<InvoiceItem>> getInvoiceItemsByInvoiceId(String invoiceId) async {
    final snapshot = await _firestore.collection('invoiceItems')
        .where('invoice_id', isEqualTo: invoiceId).get();
    return snapshot.docs.map((doc) => InvoiceItem.fromJSON(doc.data())).toList();
  }

  @override
  Future<int> updateInvoiceItem(InvoiceItem invoiceItem) async {
    await _firestore.collection('invoiceItems').doc(invoiceItem.id.toString()).update(invoiceItem.toJSON());
    return 1; // Firestore does not return an update count
  }

  @override
  Future<int> deleteInvoiceItem(String id) async {
    await _firestore.collection('invoiceItems').doc(id.toString()).delete();
    return 1; // Firestore does not return a delete count
  }
}