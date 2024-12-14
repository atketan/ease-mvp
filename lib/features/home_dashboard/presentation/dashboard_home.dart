import 'package:ease/core/utils/developer_log.dart';
import 'package:ease/features/home_invoices/data/invoices_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DashboardHomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return DashboardHomePageState();
  }
}

class DashboardHomePageState extends State<DashboardHomePage> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Provider.of<InvoicesProvider>(context, listen: false)
      //     .fetchUnpaidInvoices();
      // Provider.of<InvoicesProvider>(context, listen: false).fetchPaidInvoices();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<InvoicesProvider>(
      builder: (context, invoicesProvider, child) {
        debugLog(
            "Total Paid Amount: " + invoicesProvider.totalPaidAmount.toString(),
            name: 'Dashboard Home');
        return Scaffold(
          appBar: AppBar(
            leading: IconButton(
              onPressed: () {},
              icon: Icon(Icons.menu_outlined),
            ),
            title: Text('Dashboard'),
          ),
          body: Column(
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
                                  'Total Collection',
                                  textAlign: TextAlign.center,
                                  style: Theme.of(context).textTheme.bodyLarge,
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
                                  'Potential Collection',
                                  textAlign: TextAlign.center,
                                  style: Theme.of(context).textTheme.bodyLarge,
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
            ],
          ),
        );
      },
    );
  }
}
