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
    return DefaultTabController(
      length: 2,
      child: Consumer<InvoicesProvider>(
        builder: (context, invoicesProvider, child) {
          return Scaffold(
            appBar: AppBar(
              leading: IconButton(
                onPressed: () {},
                icon: Icon(Icons.person_4_outlined),
              ),
              actions: [
                Stack(
                  alignment: Alignment.center,
                  children: [
                    IconButton(
                      icon: Icon(Icons.filter_list),
                      onPressed: () async {
                        final picked = await showDateRangePicker(
                          context: context,
                          firstDate: DateTime(2000),
                          lastDate: DateTime.now(),
                          initialEntryMode: DatePickerEntryMode.input,
                          initialDateRange: DateTimeRange(
                            start: invoicesProvider.startDate,
                            end: invoicesProvider.endDate,
                          ),
                        );
                        if (picked != null) {
                          invoicesProvider.setDateRange(
                            picked.start,
                            picked.end,
                          );
                        }
                      },
                    ),
                    if (invoicesProvider.isFilterApplied)
                      Positioned(
                        top: 8,
                        right: 8,
                        child: Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                  ],
                ),
              ],
              title: Text('Invoices'),
              bottom: TabBar(
                isScrollable: true,
                tabAlignment: TabAlignment.start,
                // labelStyle: Theme.of(context)
                //     .textTheme
                //     .titleMedium!
                //     .copyWith(fontWeight: FontWeight.bold),
                tabs: [
                  Tab(text: 'Unpaid'),
                  Tab(text: 'Paid'),
                ],
              ),
              // backgroundColor: Colors.white,
            ),
            body: TabBarView(
              children: [
                UnpaidInvoicesTab(),
                PaidInvoicesTab(),
              ],
            ),
          );
        },
      ),
    );
  }
} // Add this closing brace
