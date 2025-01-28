import 'package:ease/core/enums/ledger_enum_type.dart';
import 'package:ease/core/utils/date_time_utils.dart';
import 'package:flutter/material.dart';
import 'package:ease/core/models/ledger_entry.dart';

class LedgerTableRow extends StatelessWidget {
  final LedgerEntry entry;

  const LedgerTableRow({required this.entry});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(right: 8.0, left: 8.0),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.grey[400]!),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Container(
              padding: EdgeInsets.only(top: 4, bottom: 4),
              decoration: BoxDecoration(
                  border: Border(
                      right: BorderSide(width: 1, color: Colors.grey[400]!))),
              child: Text(
                '${formatInvoiceDateShortForm(entry.transactionDate)} - ${entry.type.displayName}',
                style: Theme.of(context).textTheme.labelMedium,
                softWrap: true,
                overflow: TextOverflow.visible,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Container(
              padding: EdgeInsets.only(top: 4, bottom: 4, left: 4),
              decoration: BoxDecoration(
                  border: Border(
                      right: BorderSide(width: 1, color: Colors.grey[400]!))),
              child: Text(
                '₹ ${entry.grandTotal}',
                style: Theme.of(context).textTheme.labelMedium,
                softWrap: true,
                overflow: TextOverflow.visible,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Container(
              padding: EdgeInsets.only(top: 4, bottom: 4, left: 4),
              decoration: BoxDecoration(
                  border: Border(
                      right: BorderSide(width: 1, color: Colors.grey[400]!))),
              child: Text(
                '₹ ${entry.initialPaid}',
                style: Theme.of(context).textTheme.labelMedium,
                softWrap: true,
                overflow: TextOverflow.visible,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Container(
              padding: EdgeInsets.only(top: 4, bottom: 4, left: 4),
              child: Text(
                '₹ ${entry.remainingDue}',
                style: Theme.of(context).textTheme.labelMedium,
                softWrap: true,
                overflow: TextOverflow.visible,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
