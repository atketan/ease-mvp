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
        .doc(invoiceId.toString())
        .collection('invoiceItems')
        .get();
    return snapshot.docs
        .map((doc) => InvoiceItem.fromJSON(doc.data()))
        .toList();
  }

  @override
  Future<int> updateInvoiceItem(InvoiceItem invoiceItem) async {
    await _firestore
        .collection('users')
        .doc(userId)
        .collection('invoices')
        .doc(invoiceItem.invoiceId.toString())
        .collection('invoiceItems')
        .doc(invoiceItem.id.toString())
        .update(invoiceItem.toJSON());
    return 1; // Firestore does not return an update count
  }

  @override
  Future<int> deleteInvoiceItem(String invoiceItemId) async {
    // Assuming you have the invoiceId to locate the document
    final invoiceId = await _getInvoiceIdByInvoiceItemId(invoiceItemId);
    await _firestore
        .collection('users')
        .doc(userId)
        .collection('invoices')
        .doc(invoiceId.toString())
        .collection('invoiceItems')
        .doc(invoiceItemId.toString())
        .delete();
    return 1; // Firestore does not return a delete count
  }

  Future<String> _getInvoiceIdByInvoiceItemId(String id) async {
    // Implement logic to retrieve the invoiceId by invoiceItemId
    // This is a placeholder implementation
    final snapshot = await _firestore
        .collectionGroup('invoiceItems')
        .where('id', isEqualTo: id)
        .get();
    if (snapshot.docs.isNotEmpty) {
      return snapshot.docs.first.reference.parent.parent!.id;
    } else {
      throw Exception('InvoiceItem not found');
    }
  }
}
