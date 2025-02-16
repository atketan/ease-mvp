import 'package:ease/features/home_invoices/data/invoices_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ReceivablesSummaryWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => ReceivablesSummaryWidgetState();
}

class ReceivablesSummaryWidgetState extends State<ReceivablesSummaryWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 16.0, right: 16.0, bottom: 8.0),
      decoration: BoxDecoration(
        border: Border.all(color: Theme.of(context).primaryColorLight),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text('Outstanding', style: Theme.of(context).textTheme.titleMedium),
              IconButton(
                onPressed: () {
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(
                  //     builder: (context) => PaymentsProviderWidget(),
                  //   ),
                  // );
                },
                icon: Icon(
                  Icons.chevron_right_outlined,
                  size: 16.0,
                ),
              ),
            ],
          ),
          // SizedBox(height: 16.0),
          Text(
            "₹" + context.watch<InvoicesProvider>().totalUnpaidAmount.toString(),
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'To be Received',
                style: Theme.of(context).textTheme.labelSmall,
              ),
              Text(
                context.watch<InvoicesProvider>().totalUnpaidAmount.toString(),
                style: Theme.of(context).textTheme.labelSmall,
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'To be Paid',
                style: Theme.of(context).textTheme.labelSmall,
              ),
              Text(
                context.watch<InvoicesProvider>().totalUnpaidAmount.toString(),
                style: Theme.of(context).textTheme.labelSmall,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
