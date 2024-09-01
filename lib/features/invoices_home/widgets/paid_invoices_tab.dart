import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../data/invoices_provider.dart';

class PaidInvoicesTab extends StatefulWidget {
  @override
  _PaidInvoicesTabState createState() => _PaidInvoicesTabState();
}

class _PaidInvoicesTabState extends State<PaidInvoicesTab> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<InvoicesProvider>(context, listen: false).fetchPaidInvoices();
    });
  }

  @override
  Widget build(BuildContext context) {
    final invoicesProvider = Provider.of<InvoicesProvider>(context);

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: Text(
            'Total Amount Received: ₹${invoicesProvider.totalPaidAmount.toStringAsFixed(2)}',
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: invoicesProvider.paidInvoices.length,
            itemBuilder: (context, index) {
              final invoice = invoicesProvider.paidInvoices[index];
              return ListTile(
                title: Text(
                  '#${invoice.invoiceNumber}',
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                subtitle: Text(
                  'Date: ${DateFormat.yMMMd().format(invoice.date)}',
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                trailing: Text(
                  '₹${invoice.totalAmount.toStringAsFixed(2)}',
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
