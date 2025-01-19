import 'package:ease/core/database/ledger/ledger_entry_dao.dart';
import 'package:ease/core/enums/transaction_category_enum.dart';
import 'package:ease/core/models/ledger_entry.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/ledger_table_header.dart';
import '../widgets/ledger_table_row.dart';

class LedgerDetailsPage extends StatefulWidget {
  final String associatedId;
  final TransactionCategory transactionCategory;

  const LedgerDetailsPage({
    super.key,
    required this.associatedId,
    required this.transactionCategory,
  });

  @override
  State<StatefulWidget> createState() => LedgerDetailsPageState();
}

class LedgerDetailsPageState extends State<LedgerDetailsPage> {
  late LedgerEntryDAO _ledgerEntryDAO;

  @override
  Widget build(BuildContext context) {
    _ledgerEntryDAO = Provider.of<LedgerEntryDAO>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Transaction History / Ledger'),
      ),
      body: StreamBuilder<List<LedgerEntry>>(
        stream:
            _ledgerEntryDAO.getLedgerEntriesByAssociatedId(widget.associatedId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No ledger entries found.'));
          }

          final ledgerEntries = snapshot.data!;

          return Column(
            children: [
              LedgerTableHeader(
                transactionCategory: widget.transactionCategory,
              ),
              ...ledgerEntries
                  .map((entry) => LedgerTableRow(entry: entry))
                  .toList(),
            ],
          );
        },
      ),
    );
  }
}
