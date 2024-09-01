import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../data/invoices_provider.dart';

class UnpaidInvoicesTab extends StatefulWidget {
  @override
  _UnpaidInvoicesTabState createState() => _UnpaidInvoicesTabState();
}

class _UnpaidInvoicesTabState extends State<UnpaidInvoicesTab> {
  @override
  void initState() {
    super.initState();
    final invoicesProvider =
        Provider.of<InvoicesProvider>(context, listen: false);
    invoicesProvider.fetchUnpaidInvoices();
  }

  @override
  Widget build(BuildContext context) {
    final invoicesProvider = Provider.of<InvoicesProvider>(context);

    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            itemCount: invoicesProvider.unpaidInvoices.length,
            itemBuilder: (context, index) {
              final invoice = invoicesProvider.unpaidInvoices[index];
              return ListTile(
                title: Text(invoice.customerId.toString()),
                subtitle: Text(
                    'Invoice #: ${invoice.invoiceNumber}\nDate: ${DateFormat.yMMMd().format(invoice.date)}'),
                trailing: Text(
                  '₹${invoice.totalAmount.toStringAsFixed(2)}',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              );
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            'Total Amount to be Collected: ₹${invoicesProvider.totalUnpaidAmount.toStringAsFixed(2)}',
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ),
      ],
    );
  }
}
