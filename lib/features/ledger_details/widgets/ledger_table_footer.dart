import 'package:flutter/material.dart';

class LedgerTableFooter extends StatelessWidget {
  final Map<String, dynamic> ledgerSummary;

  const LedgerTableFooter({super.key, required this.ledgerSummary});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.only(right: 8.0, left: 8.0),
          color: Colors.grey[200],
          child: Row(
            children: [
              Expanded(
                  flex: 3,
                  child: Container(
                    padding: EdgeInsets.only(top: 4, bottom: 4),
                    child: Text(
                      "Total",
                      style: Theme.of(context).textTheme.labelLarge,
                    ),
                  )),
              Expanded(
                  flex: 2,
                  child: Container(
                    padding: EdgeInsets.only(top: 4, bottom: 4, left: 4),
                    child: Text(
                      "₹ ${ledgerSummary['totalSalesPurchase'].toString()}",
                      style: Theme.of(context).textTheme.labelLarge,
                    ),
                  )),
              Expanded(
                  flex: 2,
                  child: Container(
                    padding: EdgeInsets.only(top: 4, bottom: 4, left: 4),
                    child: Text(
                      "₹ ${ledgerSummary['totalPaid'].toString()}",
                      style: Theme.of(context).textTheme.labelLarge,
                    ),
                  )),
              Expanded(
                  flex: 2,
                  child: Container(
                    padding: EdgeInsets.only(top: 4, bottom: 4, left: 4),
                    child: Text(
                      "-",
                      style: Theme.of(context).textTheme.labelLarge,
                    ),
                  )),
            ],
          ),
        ),
        Container(
          padding: EdgeInsets.only(right: 8.0, left: 8.0),
          color: Colors.blueGrey[200],
          child: Row(
            children: [
              Expanded(
                  flex: 3,
                  child: Container(
                    padding: EdgeInsets.only(top: 4, bottom: 4),
                    child: Text(
                      "Balance",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  )),
              Expanded(
                  flex: 2,
                  child: Container(
                    padding: EdgeInsets.only(top: 4, bottom: 4, left: 4),
                    child: Text(
                      "",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  )),
              Expanded(
                  flex: 2,
                  child: Container(
                    padding: EdgeInsets.only(top: 4, bottom: 4, left: 4),
                    child: Text(
                      "",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  )),
              Expanded(
                  flex: 2,
                  child: Container(
                    padding: EdgeInsets.only(top: 4, bottom: 4, left: 4),
                    child: Text(
                      "₹ ${ledgerSummary['balance'].toString()}",
                      style: Theme.of(context)
                          .textTheme
                          .labelLarge
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                  )),
            ],
          ),
        ),
      ],
    );
  }
}
