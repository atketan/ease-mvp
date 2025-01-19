import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ease/core/database/ledger/ledger_entry_data_source.dart';
import 'package:ease/core/enums/transaction_type_enum.dart';
import 'package:ease/core/models/ledger_entry.dart';

class FirestoreLedgerEntryDAO implements LedgerEntryDataSource {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collectionName = 'ledger_entries';
  final String enterpriseId;

  FirestoreLedgerEntryDAO({required this.enterpriseId});

  /// Create a new LedgerEntry document
  @override
  Future<void> createLedgerEntry(LedgerEntry entry) async {
    // final docRef = _firestore
    //     .collection('enterprises')
    //     .doc(enterpriseId)
    //     .collection(_collectionName)
    //     .doc(entry.id);
    // await docRef.set(entry.toJSON());
    await _firestore
        .collection('enterprises')
        .doc(enterpriseId)
        .collection(_collectionName)
        .add(entry.toJSON());
  }

  /// Read a single LedgerEntry by ID
  @override
  Future<LedgerEntry?> getLedgerEntryById(String id) async {
    final doc = await _firestore
        .collection('enterprises')
        .doc(enterpriseId)
        .collection(_collectionName)
        .doc(id)
        .get();
    if (doc.exists) {
      return LedgerEntry.fromJSON(doc.data()!..['docId'] = doc.id);
    }
    return null;
  }

  /// Update an existing LedgerEntry
  @override
  Future<void> updateLedgerEntry(
      String id, Map<String, dynamic> updates) async {
    await _firestore
        .collection('enterprises')
        .doc(enterpriseId)
        .collection(_collectionName)
        .doc(id)
        .update(updates);
  }

  /// Delete a LedgerEntry by ID
  @override
  Future<void> deleteLedgerEntry(String id) async {
    await _firestore
        .collection('enterprises')
        .doc(enterpriseId)
        .collection(_collectionName)
        .doc(id)
        .delete();
  }

  /// Get all LedgerEntries as a list
  @override
  Future<List<LedgerEntry>> getAllLedgerEntries() async {
    final querySnapshot = await _firestore
        .collection('enterprises')
        .doc(enterpriseId)
        .collection(_collectionName)
        .get();
    return querySnapshot.docs.map((doc) {
      return LedgerEntry.fromJSON(doc.data()..['docId'] = doc.id);
    }).toList();
  }

  @override
  Stream<List<LedgerEntry>> subscribeToLedgerEntries() {
    return _firestore
        .collection('enterprises')
        .doc(enterpriseId)
        .collection(_collectionName)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return LedgerEntry.fromJSON(doc.data()..['docId'] = doc.id);
      }).toList();
    });
  }

  /// Stream LedgerEntries with a filter (e.g., type, associatedId, date range)
  @override
  Stream<List<LedgerEntry>> getLedgerEntriesStream({
    String? type,
    String? associatedId,
    DateTime? startDate,
    DateTime? endDate,
  }) {
    Query query = _firestore
        .collection('enterprises')
        .doc(enterpriseId)
        .collection(_collectionName);

    if (type != null) {
      query = query.where('type', isEqualTo: type);
    }

    if (associatedId != null) {
      query = query.where('associated_id', isEqualTo: associatedId);
    }

    if (startDate != null && endDate != null) {
      query = query.where('txn_date',
          isGreaterThanOrEqualTo: startDate.toIso8601String());
      query = query.where('txn_date',
          isLessThanOrEqualTo: endDate.toIso8601String());
    }

    return query.snapshots().map((snapshot) => snapshot.docs.map((doc) {
          final entry =
              LedgerEntry.fromJSON((doc.data() as Map<String, dynamic>));
          entry.docId = doc.id;
          return entry;
        }).toList());
  }

  /// Stream LedgerEntries for a specific customer/vendor
  @override
  Stream<List<LedgerEntry>> getLedgerEntriesByAssociatedId(
      String associatedId) {
    return _firestore
        .collection('enterprises')
        .doc(enterpriseId)
        .collection(_collectionName)
        .where('associated_id', isEqualTo: associatedId)
        .orderBy('txn_date', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) {
              return LedgerEntry.fromJSON(doc.data()..['docId'] = doc.id);
            }).toList());
  }

  /// Get summary for a customer/vendor ledger (balance calculation)
  @override
  Future<Map<String, double>> getLedgerSummaryByAssociatedId(String associatedId) async {
    final querySnapshot = await _firestore
        .collection('enterprises')
        .doc(enterpriseId)
        .collection(_collectionName)
        .where('associated_id', isEqualTo: associatedId)
        .get();

    double totalCredits = 0.0; // Payments received
    double totalDebits = 0.0; // Payments made or invoices issued
    double totalBalance = 0.0;

    for (var doc in querySnapshot.docs) {
      final entry = LedgerEntry.fromJSON(doc.data());
      if (entry.transactionType == TransactionType.credit) {
        totalCredits += entry.initialPaid!;
      } else if (entry.transactionType == TransactionType.debit) {
        totalDebits += entry.initialPaid!;
      }
      totalBalance += entry.remainingDue!;
    }

    return {
      'totalCredits': totalCredits,
      'totalDebits': totalDebits,
      'balance': totalBalance,
    };
  }
}
