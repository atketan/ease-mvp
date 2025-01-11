import '../../models/ledger_entry.dart';
import 'ledger_entry_data_source.dart';

class LedgerEntryDAO {
  final LedgerEntryDataSource _dataSource;

  LedgerEntryDAO(this._dataSource);

  Future<void> createLedgerEntry(LedgerEntry entry) {
    return _dataSource.createLedgerEntry(entry);
  }

  Future<LedgerEntry?> getLedgerEntryById(String id) {
    return _dataSource.getLedgerEntryById(id);
  }

  Future<void> updateLedgerEntry(String id, Map<String, dynamic> updates) {
    return _dataSource.updateLedgerEntry(id, updates);
  }

  Future<void> deleteLedgerEntry(String id) {
    return _dataSource.deleteLedgerEntry(id);
  }

  Future<List<LedgerEntry>> getAllLedgerEntries() {
    return _dataSource.getAllLedgerEntries();
  }

  Stream<List<LedgerEntry>> subscribeToLedgerEntries() {
    return _dataSource.subscribeToLedgerEntries();
  }
}