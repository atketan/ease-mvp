import 'package:ease/core/enums/transaction_category_enum.dart';
import 'package:flutter/material.dart';

class LedgerTableHeader extends StatelessWidget {
  final TransactionCategory transactionCategory;

  LedgerTableHeader({required this.transactionCategory});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(right: 8.0, left: 8.0),
      color: Colors.grey[300],
      child: Row(
        children: [
          Expanded(
              flex: 3,
              child: Container(
                padding: EdgeInsets.only(top: 4, bottom: 4),
                decoration: BoxDecoration(
                    border: Border(
                        right: BorderSide(width: 1, color: Colors.grey[400]!))),
                child: Text('Particular',
                    style: TextStyle(fontWeight: FontWeight.bold)),
              )),
          Expanded(
              flex: 2,
              child: Container(
                  padding: EdgeInsets.only(top: 4, bottom: 4, left: 4),
                  decoration: BoxDecoration(
                      border: Border(
                          right:
                              BorderSide(width: 1, color: Colors.grey[400]!))),
                  child: Text(transactionCategory.displayName,
                      style: TextStyle(fontWeight: FontWeight.bold)))),
          Expanded(
              flex: 2,
              child: Container(
                padding: EdgeInsets.only(top: 4, bottom: 4, left: 4),
                decoration: BoxDecoration(
                    border: Border(
                        right: BorderSide(width: 1, color: Colors.grey[400]!))),
                child: Text('Payment',
                    style: TextStyle(fontWeight: FontWeight.bold)),
              )),
          Expanded(
              flex: 2,
              child: Container(
                padding: EdgeInsets.only(top: 4, bottom: 4, left: 4),
                child: Text('Balance',
                    style: TextStyle(fontWeight: FontWeight.bold)),
              )),
        ],
      ),
    );
  }
}
