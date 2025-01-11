import '../../models/ledger_entry.dart';

abstract class LedgerEntryDataSource {
  Future<void> createLedgerEntry(LedgerEntry entry);
  Future<LedgerEntry?> getLedgerEntryById(String id);
  Future<void> updateLedgerEntry(String id, Map<String, dynamic> updates);
  Future<void> deleteLedgerEntry(String id);
  Future<List<LedgerEntry>> getAllLedgerEntries();
  Stream<List<LedgerEntry>> subscribeToLedgerEntries();
  Stream<List<LedgerEntry>> getLedgerEntriesStream({
    String? type,
    String? associatedId,
    DateTime? startDate,
    DateTime? endDate,
  });
  Stream<List<LedgerEntry>> getLedgerEntriesByAssociatedId(String associatedId);
  Future<Map<String, double>> getLedgerSummary(String associatedId);
}
