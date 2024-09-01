import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../data/invoices_provider.dart';
import '../widgets/unpaid_invoices_tab.dart';
import '../widgets/paid_invoices_tab.dart';

class InvoicesHomePage extends StatelessWidget {
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
