import 'package:ease/features/home_invoices/data/invoices_provider.dart';
import 'package:ease/features/sales_invoices/presentation/sales_invoices_page.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

class SalesSummaryWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => SalesSummaryWidgetState();
}

class SalesSummaryWidgetState extends State<SalesSummaryWidget> {
  @override
  Widget build(BuildContext context) {
    return Consumer<InvoicesProvider>(
        builder: (context, invoicesProvider, child) {
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
                Text('Sales', style: Theme.of(context).textTheme.titleMedium),
                IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SalesInvoicesProviderWidget(),
                      ),
                    );
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
              "₹" +
                  context.watch<InvoicesProvider>().totalSalesAmount.toString(),
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Paid',
                  style: Theme.of(context).textTheme.labelSmall,
                ),
                Text(
                  context
                      .watch<InvoicesProvider>()
                      .paidInvoices
                      .length
                      .toString(),
                  style: Theme.of(context).textTheme.labelSmall,
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Unpaid',
                  style: Theme.of(context).textTheme.labelSmall,
                ),
                Text(
                  context
                      .watch<InvoicesProvider>()
                      .unpaidInvoices
                      .length
                      .toString(),
                  style: Theme.of(context).textTheme.labelSmall,
                ),
              ],
            ),
          ],
        ),
      );
    });
  }
}
