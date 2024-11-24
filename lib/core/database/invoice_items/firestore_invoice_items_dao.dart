import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/invoice_item.dart';
import 'invoice_items_data_source.dart';

class FirestoreInvoiceItemsDAO implements InvoiceItemsDataSource {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String userId;

  FirestoreInvoiceItemsDAO({required this.userId});

  @override
  Future<String> insertInvoiceItem(InvoiceItem invoiceItem) async {
    final docRef = await _firestore
        .collection('users')
        .doc(userId)
        .collection('invoices')
        .doc(invoiceItem.invoiceId.toString())
        .collection('invoiceItems')
        .add(invoiceItem.toJSON());
    return docRef.id; // Firestore does not return an integer ID
  }

  @override
  Future<List<InvoiceItem>> getInvoiceItemsByInvoiceId(String invoiceId) async {
    final snapshot = await _firestore
        .collection('users')
        .doc(userId)
        .collection('invoices')
        .doc(invoiceId)
        .collection('invoiceItems')
        .get();
    return snapshot.docs.map((doc) {
      final invoiceItem = InvoiceItem.fromJSON(doc.data());
      invoiceItem.id = doc.id;
      invoiceItem.invoiceId = invoiceId;
      return invoiceItem;
    }).toList();
  }

  @override
  Future<int> updateInvoiceItem(InvoiceItem invoiceItem) async {
    await _firestore
        .collection('users')
        .doc(userId)
        .collection('invoices')
        .doc(invoiceItem.invoiceId)
        .collection('invoiceItems')
        .doc(invoiceItem.id)
        .update(invoiceItem.toJSON());
    return 1; // Firestore does not return an update count
  }

  @override
  Future<int> deleteInvoiceItem(InvoiceItem invoiceItem) async {
    await _firestore
        .collection('users')
        .doc(userId)
        .collection('invoices')
        .doc(invoiceItem.invoiceId)
        .collection('invoiceItems')
        .doc(invoiceItem.id)
        .delete();
    return 1; // Firestore does not return a delete count
  }
}
