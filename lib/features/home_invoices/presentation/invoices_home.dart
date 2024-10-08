import 'package:ease/core/utils/developer_log.dart';
import 'package:ease/features/home_invoices/widgets/all_sales_invoices_tab.dart';
import 'package:ease/features/manage/presentation/manage_landing_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../data/invoices_provider.dart';
// import '../widgets/unpaid_invoices_tab.dart';
// import '../widgets/paid_invoices_tab.dart';

class InvoicesHomePage extends StatefulWidget {
  @override
  State<InvoicesHomePage> createState() => _InvoicesHomePageState();
}

class _InvoicesHomePageState extends State<InvoicesHomePage> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<InvoicesProvider>(context, listen: false).fetchPaidInvoices();
      Provider.of<InvoicesProvider>(context, listen: false)
          .fetchUnpaidInvoices();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 5,
      child: Consumer<InvoicesProvider>(
        builder: (context, invoicesProvider, child) {
          debugLog('Invoices Home Rebuild triggered', name: "InvoicesHome");
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
                      builder: (BuildContext context) {
                        return ManageLandingPage(); // Your full-screen dialog content
                      },
                    );
                  },
                  icon: Icon(Icons.apps_outlined),
                ),
                Stack(
                  alignment: Alignment.center,
                  children: [
                    IconButton(
                      icon: Icon(Icons.calendar_month_outlined),
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
              title: Text(
                'Invoices',
                style: Theme.of(context).textTheme.titleLarge!.copyWith(
                      color: Theme.of(context).canvasColor,
                    ),
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
            // drawer: Drawer(
            //   child: ListView(
            //     padding: EdgeInsets.zero,
            //     children: <Widget>[
            //       DrawerHeader(
            //         decoration: BoxDecoration(
            //           color: Colors.blue,
            //         ),
            //         child: Text(
            //           'Drawer Header',
            //           style: TextStyle(
            //             color: Colors.white,
            //             fontSize: 24,
            //           ),
            //         ),
            //       ),
            //       ListTile(
            //         leading: Icon(Icons.home),
            //         title: Text('Home'),
            //         onTap: () {
            //           // Handle navigation to home
            //           Navigator.pop(context); // Close the drawer
            //         },
            //       ),
            //       ListTile(
            //         leading: Icon(Icons.settings),
            //         title: Text('Settings'),
            //         onTap: () {
            //           // Handle navigation to settings
            //           Navigator.pop(context); // Close the drawer
            //         },
            //       ),
            //       ListTile(
            //         leading: Icon(Icons.info),
            //         title: Text('About'),
            //         onTap: () {
            //           // Handle navigation to about
            //           Navigator.pop(context); // Close the drawer
            //         },
            //       ),
            //     ],
            //   ),
            // ),

            body: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: IntrinsicHeight(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Expanded(
                          flex: 5,
                          child: Card(
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Total Sales',
                                    textAlign: TextAlign.center,
                                    style:
                                        Theme.of(context).textTheme.titleSmall,
                                  ),
                                  Text(
                                    "₹" +
                                        invoicesProvider.totalPaidAmount
                                            .toString(), // Replace with dynamic value
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyLarge!
                                        .copyWith(
                                            color: Colors.green,
                                            fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 5,
                          child: Card(
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Balance Amount',
                                    textAlign: TextAlign.center,
                                    style:
                                        Theme.of(context).textTheme.titleSmall,
                                  ),
                                  Text(
                                    "₹" +
                                        invoicesProvider.totalUnpaidAmount
                                            .toString(), // Replace with dynamic value
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyLarge!
                                        .copyWith(
                                            color: Colors.red,
                                            fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
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
                      Tab(text: 'Reports'),
                      // Tab(text: 'Unpaid'),
                      // Tab(text: 'Paid'),
                    ],
                  ),
                ),
                Expanded(
                  child: TabBarView(
                    children: [
                      AllSalesInvoicesTab(),
                      Container(
                        child: Center(child: Text("Coming soon")),
                      ),
                      Container(
                        child: Center(child: Text("Coming soon")),
                      ),
                      Container(
                        child: Center(child: Text("Coming soon")),
                      ),
                      Container(
                        child: Center(child: Text("Coming soon")),
                      ),
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
} // Add this closing brace
