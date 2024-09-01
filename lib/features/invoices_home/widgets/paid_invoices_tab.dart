import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../data/invoices_provider.dart';

class PaidInvoicesTab extends StatefulWidget {
  @override
  _PaidInvoicesTabState createState() => _PaidInvoicesTabState();
}

class _PaidInvoicesTabState extends State<PaidInvoicesTab> {
  DateTime _startDate = DateTime.now().subtract(Duration(days: 30));
  DateTime _endDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    final invoicesProvider =
        Provider.of<InvoicesProvider>(context, listen: false);
    invoicesProvider.fetchPaidInvoices(_startDate, _endDate);
  }

  @override
  Widget build(BuildContext context) {
    final invoicesProvider = Provider.of<InvoicesProvider>(context);

    return Column(
      children: [
        SizedBox(height: 8.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            TextButton(
              onPressed: () async {
                final picked = await showDateRangePicker(
                  context: context,
                  firstDate: DateTime(2000),
                  lastDate: DateTime.now(),
                  initialDateRange:
                      DateTimeRange(start: _startDate, end: _endDate),
                );
                if (picked != null) {
                  setState(() {
                    _startDate = picked.start;
                    _endDate = picked.end;
                  });
                  invoicesProvider.fetchPaidInvoices(_startDate, _endDate);
                }
              },
              child: Text('Select Date Range'),
            ),
            Text('From: ${DateFormat.yMMMd().format(_startDate)}'),
            Text('To: ${DateFormat.yMMMd().format(_endDate)}'),
          ],
        ),
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
