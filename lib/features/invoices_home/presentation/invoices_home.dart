import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../data/invoices_provider.dart';

class InvoicesHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => InvoicesProvider(),
      child: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            // title: Text('Invoices'),
            // centerTitle: true,
            toolbarHeight: 0.0,
            bottom: TabBar(
              labelStyle: Theme.of(context)
                  .textTheme
                  .titleMedium!
                  .copyWith(fontWeight: FontWeight.bold),
              tabs: [
                Tab(text: 'Unpaid'),
                Tab(text: 'Paid'),
              ],
            ),
            backgroundColor: Colors.white,
          ),
          body: TabBarView(
            children: [
              UnpaidInvoicesTab(),
              PaidInvoicesTab(),
            ],
          ),
        ),
      ),
    );
  }
}

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
        Expanded(
          child: ListView.builder(
            itemCount: invoicesProvider.paidInvoices.length,
            itemBuilder: (context, index) {
              final invoice = invoicesProvider.paidInvoices[index];
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
            'Total Amount Received: ₹${invoicesProvider.totalPaidAmount.toStringAsFixed(2)}',
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ),
      ],
    );
  }
}
