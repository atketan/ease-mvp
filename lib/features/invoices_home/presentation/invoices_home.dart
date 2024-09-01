import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../data/invoices_provider.dart';
import '../widgets/unpaid_invoices_tab.dart';
import '../widgets/paid_invoices_tab.dart';

class InvoicesHomePage extends StatefulWidget {
  @override
  State<InvoicesHomePage> createState() => _InvoicesHomePageState();
}

class _InvoicesHomePageState extends State<InvoicesHomePage> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => InvoicesProvider(),
      child: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            leading: IconButton(
              onPressed: () {},
              icon: Icon(Icons.person_4_outlined),
            ),
            actions: [
              IconButton(
                onPressed: () async {
                  // Add date range filter on pressed and remove the logic from paid_invoices_tab.dart
                  // this date range filter should be applied on both the tabs
                  // default date range should be 1 month from today
                  final picked = await showDateRangePicker(
                    context: context,
                    firstDate: DateTime.now().subtract(Duration(days: 30)),
                    lastDate: DateTime.now(),
                    initialDateRange: DateTimeRange(
                      start: DateTime.now().subtract(Duration(days: 30)),
                      end: DateTime.now(),
                    ),
                  );

                  if (picked != null) {
                    final invoicesProvider =
                        Provider.of<InvoicesProvider>(context, listen: false);
                    invoicesProvider.setDateRange(picked.start, picked.end);
                  }
                },
                icon: Icon(
                  Icons.filter_list_outlined,
                ),
              ),
            ],
            title: Text(
              'Invoices',
              style: Theme.of(context)
                  .textTheme
                  .titleMedium!
                  .copyWith(fontWeight: FontWeight.bold),
            ),
            centerTitle: true,
            toolbarHeight: 40.0,
            bottom: TabBar(
              isScrollable: true,
              tabAlignment: TabAlignment.start,
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
