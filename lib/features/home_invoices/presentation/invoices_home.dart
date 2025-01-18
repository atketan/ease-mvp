import 'package:ease/core/utils/developer_log.dart';
import 'package:ease/features/expenses/presentation/expenses_list_page.dart';
import 'package:ease/features/home_invoices/widgets/expenses_summary_widget.dart';
import 'package:ease/features/home_invoices/widgets/payments_summary_widget.dart';
import 'package:ease/features/home_invoices/widgets/purchase_invoices_list_page.dart';
import 'package:ease/features/home_invoices/widgets/purchases_summary_widget.dart';
import 'package:ease/features/home_invoices/widgets/receivables_summary_widget.dart';
import 'package:ease/features/home_invoices/widgets/sales_invoices_list_page.dart';
import 'package:ease/features/home_invoices/widgets/sales_summary_widget.dart';
import 'package:ease/features/ledgers_clients/presentation/clients_ledger_summary_page.dart';
import 'package:ease/features/ledgers_vendors/presentation/vendors_ledger_summary_page.dart';
import 'package:ease/features/manage/presentation/manage_options_bottomsheet.dart';
import 'package:ease/widgets/time_range_provider.dart';
import 'package:ease/widgets/time_range_selector.dart';
import 'package:flutter/foundation.dart';
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
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              surfaceTintColor: Theme.of(context).scaffoldBackgroundColor,
              leading: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image(
                  image: AssetImage('assets/images/icon-512.png'),
                ),
              ),
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
                  icon: Icon(
                    Icons.apps_outlined,
                    color: Theme.of(context).primaryColor,
                  ),
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
                'Simple Hisaab',
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 1,
                  margin: EdgeInsets.only(
                    left: 8.0,
                    right: 8.0,
                  ),
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColorLight,
                  ),
                ),
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
                // Padding(
                //   padding:
                //       const EdgeInsets.only(right: 8.0, left: 8.0, bottom: 8.0),
                //   child: Row(
                //     children: [
                //       // Expanded(flex: 5, child: SalesSummaryWidget()),
                //       // SizedBox(width: 8.0),
                //       Expanded(flex: 5, child: PurchasesSummaryWidget()),
                //     ],
                //   ),
                // ),
                Padding(
                  padding:
                      const EdgeInsets.only(right: 8.0, left: 8.0, bottom: 8.0),
                  child: Row(
                    children: [
                      Expanded(flex: 5, child: PaymentsSummaryWidget()),
                      SizedBox(width: 8.0),
                      Expanded(flex: 5, child: ReceivablesSummaryWidget()),
                    ],
                  ),
                ),
                // Padding(
                //   padding:
                //       const EdgeInsets.only(right: 8.0, left: 8.0, bottom: 8.0),
                //   child: Row(
                //     children: [
                //       // Expanded(flex: 5, child: PaymentsSummaryWidget()),
                //       // SizedBox(width: 8.0),
                //       Expanded(flex: 5, child: ReceivablesSummaryWidget()),
                //     ],
                //   ),
                // ),
                Padding(
                  padding:
                      const EdgeInsets.only(right: 8.0, left: 8.0, bottom: 8.0),
                  child: Row(
                    children: [
                      Expanded(flex: 5, child: ExpensesSummaryWidget()),
                      SizedBox(width: 8.0),
                      Expanded(flex: 5, child: Container()),
                    ],
                  ),
                ),
                Card(
                  elevation: 1.0,
                  child: ListTile(
                    dense: true,
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => ClientsLedgerSummaryPage(),
                        ),
                      );
                    },
                    title: Text(
                      'Client Ledgers',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    subtitle: Text(
                      'Sales records, customer accounts, and reports',
                      style: Theme.of(context).textTheme.labelMedium,
                    ),
                    trailing: Icon(Icons.arrow_forward_ios),
                  ),
                ),
                SizedBox(height: 8.0),
                Card(
                  elevation: 1.0,
                  child: ListTile(
                    dense: true,
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => VendorsLedgerSummaryPage(),
                        ),
                      );
                    },
                    title: Text(
                      'Vendor Ledgers',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    subtitle: Text(
                      'Purchase records, vendor accounts, and reports',
                      style: Theme.of(context).textTheme.labelMedium,
                    ),
                    trailing: Icon(Icons.arrow_forward_ios),
                  ),
                ),
                SizedBox(height: 8.0),
                if (kDebugMode)
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
                if (kDebugMode)
                  Expanded(
                    child: TabBarView(
                      children: [
                        SalesInvoicesListPage(),
                        PurchaseInvoicesListPage(),
                        ExpensesListPage(
                          timeRangeProvider:
                              GetIt.instance<TimeRangeProvider>(),
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
