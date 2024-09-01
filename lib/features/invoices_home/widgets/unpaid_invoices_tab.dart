import 'package:ease/core/models/invoice.dart';
import 'package:flutter/material.dart';
import 'dart:developer' as developer;
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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<InvoicesProvider>(context, listen: false)
          .fetchUnpaidInvoices();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<InvoicesProvider>(
      builder: (context, invoicesProvider, child) {
        developer.log(
            'Building UnpaidInvoicesTab with ${invoicesProvider.unpaidInvoices.length} invoices');
        final groupedInvoices =
            _groupInvoicesByMonth(invoicesProvider.unpaidInvoices);

        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Text(
                'Total Amount to be Collected: ₹${invoicesProvider.totalUnpaidAmount.toStringAsFixed(2)}',
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: groupedInvoices.length,
                itemBuilder: (context, index) {
                  final month = groupedInvoices.keys.elementAt(index);
                  final invoices = groupedInvoices[month]!;
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          month,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ),
                      ...invoices
                          .map(
                            (invoice) => Dismissible(
                              key: Key(invoice.id.toString()),
                              background: Container(
                                color: Colors.green,
                                alignment: Alignment.centerRight,
                                padding: EdgeInsets.only(right: 20.0),
                                child: Icon(Icons.check, color: Colors.white),
                              ),
                              direction: DismissDirection.endToStart,
                              onDismissed: (direction) {
                                invoicesProvider.markInvoiceAsPaid(invoice);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content: Text('Invoice marked as paid')),
                                );
                              },
                              child: ListTile(
                                dense: true,
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
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium!
                                      .copyWith(
                                        fontWeight: FontWeight.bold,
                                      ),
                                ),
                              ),
                            ),
                          )
                          .toList(),
                    ],
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }

  Map<String, List<Invoice>> _groupInvoicesByMonth(List<Invoice> invoices) {
    final Map<String, List<Invoice>> groupedInvoices = {};
    for (var invoice in invoices) {
      final month = DateFormat('MMMM yyyy').format(invoice.date);
      if (!groupedInvoices.containsKey(month)) {
        groupedInvoices[month] = [];
      }
      groupedInvoices[month]!.add(invoice);
    }
    return groupedInvoices;
  }
}
