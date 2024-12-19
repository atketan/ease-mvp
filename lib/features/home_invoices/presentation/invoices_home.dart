import 'package:ease/core/utils/developer_log.dart';
import 'package:ease/features/expenses/presentation/expenses_list_page.dart';
import 'package:ease/features/expenses/providers/expense_provider.dart';
import 'package:ease/features/home_invoices/widgets/purchases_summary_widget.dart';
import 'package:ease/features/home_invoices/widgets/sales_invoices_list_page.dart';
import 'package:ease/features/home_invoices/widgets/sales_summary_widget.dart';
import 'package:ease/features/manage/presentation/manage_options_bottomsheet.dart';
import 'package:ease/widgets/time_range_provider.dart';
import 'package:ease/widgets/time_range_selector.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import '../data/invoices_provider.dart';

class InvoicesHomePage extends StatefulWidget {
  @override
  State<InvoicesHomePage> createState() => _InvoicesHomePageState();
}

class _InvoicesHomePageState extends State<InvoicesHomePage> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<InvoicesProvider>(context, listen: false)
          .subscribeToInvoices();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Consumer<InvoicesProvider>(
        builder: (context, invoicesProvider, child) {
          return Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: false,
              actions: [
                IconButton(
                  onPressed: () {
                    // Scaffold.of(context).openDrawer(); // Open the drawer
                    showModalBottomSheet(
                      context: context,
                      // isScrollControlled: true, // Allow full-screen height
                      showDragHandle: true,
                      builder: (BuildContext context) {
                        return ManageOptionsBottomsheet();
                      },
                    );
                  },
                  icon: Icon(Icons.apps_outlined),
                ),
                // Stack(
                //   alignment: Alignment.center,
                //   children: [
                //     IconButton(
                //       icon: Icon(Icons.calendar_month_outlined),
                //       onPressed: () async {
                //         final picked = await showDateRangePicker(
                //           context: context,
                //           firstDate: DateTime(2000),
                //           lastDate: DateTime.now(),
                //           initialEntryMode: DatePickerEntryMode.input,
                //           initialDateRange: DateTimeRange(
                //             start: invoicesProvider.startDate,
                //             end: invoicesProvider.endDate,
                //           ),
                //         );
                //         if (picked != null) {
                //           invoicesProvider.setDateRange(
                //             picked.start,
                //             picked.end,
                //           );
                //         }
                //       },
                //     ),
                //     if (invoicesProvider.isFilterApplied)
                //       Positioned(
                //         top: 8,
                //         right: 8,
                //         child: Container(
                //           width: 8,
                //           height: 8,
                //           decoration: BoxDecoration(
                //             color: Colors.red,
                //             shape: BoxShape.circle,
                //           ),
                //         ),
                //       ),
                //   ],
                // ),
              ],
              title: Text(
                'SimpleHisaab',
                style: Theme.of(context)
                    .textTheme
                    .titleLarge!
                    .copyWith(color: Theme.of(context).canvasColor),
              ),
              // bottom: TabBar(
              //   isScrollable: true,
              //   tabAlignment: TabAlignment.start,
              //   tabs: [
              //     Tab(text: 'Unpaid'),
              //     Tab(text: 'Paid'),
              //   ],
              // ),
            ),
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TimeRangeSelector(
                  onRangeSelected: (startDate, endDate) {
                    debugLog(
                      'Selected range: ${startDate.toString()} - ${endDate.toString()}',
                      name: 'InvoicesHomePage',
                    );
                    invoicesProvider.setDateRange(
                      startDate,
                      endDate,
                    );
                    // Provider.of<ExpensesProvider>(context, listen: false)
                    //     .setDateRange(startDate, endDate);
                  },
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(right: 8.0, left: 8.0, bottom: 8.0),
                  child: Row(
                    children: [
                      Expanded(flex: 5, child: SalesSummaryWidget()),
                      SizedBox(width: 8.0),
                      Expanded(flex: 5, child: PurchasesSummaryWidget()),
                    ],
                  ),
                ),
                // Center(
                //   child: IntrinsicHeight(
                //     child: Row(
                //       mainAxisAlignment: MainAxisAlignment.center,
                //       mainAxisSize: MainAxisSize.min,
                //       children: [
                //         Expanded(
                //           flex: 5,
                //           child: Card(
                //             child: Padding(
                //               padding: const EdgeInsets.all(16.0),
                //               child: Column(
                //                 mainAxisAlignment: MainAxisAlignment.center,
                //                 children: [
                //                   Text(
                //                     'Total Sales',
                //                     textAlign: TextAlign.center,
                //                     style:
                //                         Theme.of(context).textTheme.titleSmall,
                //                   ),
                //                   Text(
                //                     "₹" +
                //                         invoicesProvider.totalSalesAmount
                //                             .toString(),
                //                     style: Theme.of(context)
                //                         .textTheme
                //                         .bodyLarge!
                //                         .copyWith(
                //                             color: Colors.green,
                //                             fontWeight: FontWeight.bold),
                //                   ),
                //                 ],
                //               ),
                //             ),
                //           ),
                //         ),
                //         Expanded(
                //           flex: 5,
                //           child: Card(
                //             child: Padding(
                //               padding: const EdgeInsets.all(16.0),
                //               child: Column(
                //                 mainAxisAlignment: MainAxisAlignment.center,
                //                 children: [
                //                   Text(
                //                     'Balance Amount',
                //                     textAlign: TextAlign.center,
                //                     style:
                //                         Theme.of(context).textTheme.titleSmall,
                //                   ),
                //                   Text(
                //                     "₹" +
                //                         invoicesProvider.totalUnpaidAmount
                //                             .toString(), // Replace with dynamic value
                //                     style: Theme.of(context)
                //                         .textTheme
                //                         .bodyLarge!
                //                         .copyWith(
                //                             color: Colors.red,
                //                             fontWeight: FontWeight.bold),
                //                   ),
                //                 ],
                //               ),
                //             ),
                //           ),
                //         ),
                //       ],
                //     ),
                //   ),
                // ),
                Container(
                  color: Theme.of(context).primaryColor,
                  margin: EdgeInsets.all(0.0),
                  child: TabBar(
                    isScrollable: true,
                    tabAlignment: TabAlignment.start,
                    tabs: [
                      Tab(text: 'Sales'),
                      Tab(text: 'Purchases'),
                      Tab(text: 'Expenses'),
                      Tab(text: 'Payments'),
                      // Tab(text: 'Reports'),
                      // Tab(text: 'Unpaid'),
                      // Tab(text: 'Paid'),
                    ],
                  ),
                ),
                Expanded(
                  child: TabBarView(
                    children: [
                      SalesInvoicesListPage(),
                      Container(
                        child: Center(child: Text("Coming soon")),
                      ),
                      ExpensesListPage(
                        timeRangeProvider: GetIt.instance<TimeRangeProvider>(),
                      ),
                      Container(
                        child: Center(child: Text("Coming soon")),
                      ),
                      // Container(
                      //   child: Center(child: Text("Coming soon")),
                      // ),
                      // UnpaidInvoicesTab(),
                      // PaidInvoicesTab(),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
