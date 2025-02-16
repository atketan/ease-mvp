import 'package:ease/core/database/ledger/ledger_entry_dao.dart';
import 'package:ease/core/utils/developer_log.dart';
import 'package:ease/features/expenses/bloc/expense_manager_cubit.dart';
import 'package:ease/features/expenses/widgets/expense_form_v2.dart';
import 'package:ease/features/home_invoices/data/invoices_provider.dart';
// import 'package:ease/features/home_invoices/widgets/custom_chip_tags_widget.dart';

import 'package:ease/widgets/time_range_selector.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';

import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

class ExpenseInvoicesProviderWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => InvoicesProvider(context.read<LedgerEntryDAO>()),
      child: ExpenseInvoicesPage(),
    );
  }
}

class ExpenseInvoicesPage extends StatefulWidget {
  @override
  State<ExpenseInvoicesPage> createState() => _ExpenseInvoicesPageState();
}

class _ExpenseInvoicesPageState extends State<ExpenseInvoicesPage> {
  late LedgerEntryDAO _ledgerEntryDAO;

  @override
  void initState() {
    super.initState();
  }

  void _refreshInvoices() {
    debugLog('Refresh all expense invoices called',
        name: 'ExpenseInvoicesPage');
    Provider.of<InvoicesProvider>(context, listen: false).subscribeToInvoices();
  }

  @override
  Widget build(BuildContext context) {
    _ledgerEntryDAO = Provider.of<LedgerEntryDAO>(context);

    return Consumer<InvoicesProvider>(
      builder: (context, invoicesProvider, child) {
        debugLog(
            'Building ExpenseInvoicesPage with ${invoicesProvider.allSalesInvoices.length} invoices',
            name: 'ExpenseInvoicesPage');

        return Scaffold(
          appBar: AppBar(
            title: Text('Expenses'),
          ),
          body: Column(
            children: [
              TimeRangeSelector(
                onRangeSelected: (startDate, endDate) {
                  debugLog(
                    'Selected range: ${startDate.toString()} - ${endDate.toString()}',
                    name: 'ExpenseInvoicesPage',
                  );
                  invoicesProvider.setDateRange(
                    startDate,
                    endDate,
                  );
                },
              ),
              Divider(),
              Expanded(
                child: ListView.builder(
                  itemCount: invoicesProvider.allExpenseInvoices.length,
                  itemBuilder: (context, index) {
                    final invoice = invoicesProvider.allExpenseInvoices[index];
                    
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Slidable(
                          key: Key(invoice.docId.toString()),
                          endActionPane: ActionPane(
                            motion: ScrollMotion(),
                            children: [
                              SlidableAction(
                                onPressed: (context) async {
                                  // await Navigator.push(
                                  //   context,
                                  //   MaterialPageRoute(
                                  //     builder: (BuildContext context) =>
                                  //         BlocProvider(
                                  //       create: (context) =>
                                  //           InvoiceManagerCubit(
                                  //         _customersDAO,
                                  //         _vendorsDAO,
                                  //         _ledgerEntryDAO,
                                  //         TransactionCategory.sales,
                                  //       ),
                                  //       child: InvoiceManagerV2(
                                  //         invoiceFormMode: InvoiceFormMode.Edit,
                                  //         ledgerEntry: invoice,
                                  //       ),
                                  //     ),
                                  //   ),
                                  // );
                                  _refreshInvoices();
                                },
                                icon: Icons.edit,
                                label: 'Edit',
                              ),
                            ],
                          ),
                          child: ListTile(
                            dense: true,
                            leading: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  DateFormat('MMM')
                                      .format(invoice.transactionDate),
                                  style:
                                      Theme.of(context).textTheme.labelMedium,
                                ),
                                Text(
                                  DateFormat('d')
                                      .format(invoice.transactionDate),
                                  style: Theme.of(context).textTheme.titleLarge,
                                ),
                              ],
                            ),
                            title: Row(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${invoice.name}',
                                  style: Theme.of(context).textTheme.labelLarge,
                                ),
                                SizedBox(width: 8),
                                // Add the tag for paid/unpaid status
                                // .. Commented out as expenses would always be Paid (current feature)
                                // if (invoice.status == "paid")
                                //   CustomChipTagsWidget(
                                //     tagTitle: 'Paid',
                                //     tagColor: Colors.green,
                                //   )
                                // else
                                //   CustomChipTagsWidget(
                                //     tagTitle: 'Unpaid',
                                //     tagColor: Colors.red,
                                //   )
                              ],
                            ),
                            subtitle: Row(
                              children: [
                                // Text('#${invoice.invNumber}\t\t'),
                                Text('${invoice.notes}\t\t'),
                                // SizedBox(width: 8),
                                // if (invoice.notes != null &&
                                //     invoice.notes!.isNotEmpty)
                                // InkWell(
                                //   child: Text(
                                //     'Notes',
                                //     style: Theme.of(context)
                                //         .textTheme
                                //         .labelMedium
                                //         ?.copyWith(
                                //           color: Colors.blue[800],
                                //           decoration:
                                //               TextDecoration.underline,
                                //         ),
                                //   ),
                                //   onTap: () {
                                //     showDialog(
                                //       context: context,
                                //       builder: (context) {
                                //         return AlertDialog(
                                //           title: Text('Notes'),
                                //           content: Text(invoice.notes ?? "-"),
                                //           actions: [
                                //             TextButton(
                                //               onPressed: () {
                                //                 Navigator.pop(context);
                                //               },
                                //               child: Text('Close'),
                                //             ),
                                //           ],
                                //         );
                                //       },
                                //     );
                                //   },
                                // ),
                              ],
                            ),
                            trailing: Text(
                              '₹${invoice.grandTotal?.toStringAsFixed(2)}',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium!
                                  .copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                            onLongPress: () async {
                              await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      BlocProvider(
                                    create: (context) => ExpenseManagerCubit(
                                      _ledgerEntryDAO,
                                    ),
                                    child: ExpenseFormV2(
                                      ledgerEntry: invoice,
                                    ),
                                  ),
                                ),
                              );
                              _refreshInvoices();
                            },
                          ),
                        ),
                        Divider(
                          color: Theme.of(context).highlightColor,
                          indent: 16.0,
                          endIndent: 16.0,
                        ),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
