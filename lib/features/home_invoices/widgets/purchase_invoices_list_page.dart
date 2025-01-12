import 'package:ease/core/database/customers/customers_dao.dart';
import 'package:ease/core/database/ledger/ledger_entry_dao.dart';
import 'package:ease/core/database/vendors/vendors_dao.dart';
import 'package:ease/core/enums/transaction_category_enum.dart';
import 'package:ease/core/models/ledger_entry.dart';
// import 'package:ease/core/models/invoice.dart';
import 'package:ease/core/utils/developer_log.dart';
import 'package:ease/features/home_invoices/widgets/custom_chip_tags_widget.dart';
import 'package:ease/features/invoice_manager_v2/bloc/invoice_manager_v2_cubit.dart';
import 'package:ease/features/invoice_manager_v2/presentation/invoice_manager_v2.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../data/invoices_provider.dart';

class PurchaseInvoicesListPage extends StatefulWidget {
  @override
  _PurchaseInvoicesListPageState createState() =>
      _PurchaseInvoicesListPageState();
}

class _PurchaseInvoicesListPageState extends State<PurchaseInvoicesListPage> {
  late CustomersDAO _customersDAO;
  late VendorsDAO _vendorsDAO;
  late LedgerEntryDAO _ledgerEntryDAO;

  @override
  void initState() {
    super.initState();
  }

  void _refreshInvoices() {
    debugLog('Refresh all purchase invoices called',
        name: 'PurchaseInvoicesListPage');
    Provider.of<InvoicesProvider>(context, listen: false).subscribeToInvoices();
  }

  @override
  Widget build(BuildContext context) {
    _customersDAO = Provider.of<CustomersDAO>(context);
    _vendorsDAO = Provider.of<VendorsDAO>(context);
    _ledgerEntryDAO = Provider.of<LedgerEntryDAO>(context);

    return Consumer<InvoicesProvider>(
      builder: (context, invoicesProvider, child) {
        debugLog(
            'Building AllPurchaseInvoicesTab with ${invoicesProvider.allPurchaseInvoices.length} invoices',
            name: 'InvoicesProvider');
        final groupedInvoices =
            _groupInvoicesByMonth(invoicesProvider.allPurchaseInvoices);

        return Column(
          children: [
            if (groupedInvoices.isEmpty)
              Expanded(
                child: Center(
                  child: Text('No purchases found for the selected period'),
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
                      ListView.builder(
                        itemCount: invoices.length,
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          final invoice = invoices[index];
                          return Slidable(
                            key: Key(invoice.docId.toString()),
                            // startActionPane: ActionPane(
                            //   motion: ScrollMotion(),
                            //   children: [
                            //     (invoice.status != "paid")
                            //         ? SlidableAction(
                            //             onPressed: (context) {
                            //               // Handle action for left swipe
                            //               // For example, mark as paid
                            //               invoicesProvider
                            //                   .markInvoiceAsPaid(invoice);
                            //               ScaffoldMessenger.of(context)
                            //                   .showSnackBar(
                            //                 SnackBar(
                            //                     content: Text(
                            //                         'Invoice marked as paid')),
                            //               );
                            //               // Provider.of<InvoicesProvider>(context,
                            //               //         listen: false)
                            //               //     .fetchAllPurchaseInvoices();
                            //             },
                            //             backgroundColor: Colors.blueGrey,
                            //             foregroundColor: Colors.white,
                            //             icon: Icons.check,
                            //             label: 'Mark as Paid',
                            //           )
                            //         : SlidableAction(
                            //             onPressed: (context) {
                            //               // Handle action for left swipe
                            //               ScaffoldMessenger.of(context)
                            //                   .showSnackBar(
                            //                 SnackBar(
                            //                     content: Text(
                            //                         'Invoice is fully paid')),
                            //               );
                            //             },
                            //             backgroundColor: Colors.green,
                            //             foregroundColor: Colors.white,
                            //             icon: Icons.check,
                            //             label: 'Fully Paid',
                            //           ),
                            //     // SlidableAction(
                            //     //   onPressed: (context) {
                            //     //     // Handle action for right swipe
                            //     //     // To Do
                            //     //   },
                            //     //   backgroundColor: Colors.red,
                            //     //   foregroundColor: Colors.white,
                            //     //   icon: Icons.delete,
                            //     //   label: 'Delete',
                            //     // ),
                            //   ],
                            // ),
                            endActionPane: ActionPane(
                              motion: ScrollMotion(),
                              children: [
                                SlidableAction(
                                  onPressed: (context) async {
                                    await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (BuildContext context) =>
                                            BlocProvider(
                                          create: (context) =>
                                              InvoiceManagerCubit(
                                            _customersDAO,
                                            _vendorsDAO,
                                            _ledgerEntryDAO,
                                            TransactionCategory.purchase,
                                          ),
                                          child: InvoiceManagerV2(
                                            invoiceFormMode:
                                                InvoiceFormMode.Edit,
                                            ledgerEntry: invoice,
                                          ),
                                        ),
                                      ),
                                    );
                                    _refreshInvoices();
                                  },
                                  backgroundColor:
                                      Theme.of(context).primaryColor,
                                  foregroundColor: Colors.white,
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
                                    style:
                                        Theme.of(context).textTheme.titleLarge,
                                  ),
                                ],
                              ),
                              title: Row(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '${invoice.name}',
                                    style:
                                        Theme.of(context).textTheme.labelLarge,
                                  ),
                                  SizedBox(width: 8),
                                  // Add the tag for paid/unpaid status
                                  if (invoice.status == "paid")
                                    CustomChipTagsWidget(
                                      tagTitle: 'Paid',
                                      tagColor: Colors.green,
                                    )
                                  else
                                    CustomChipTagsWidget(
                                      tagTitle: 'Unpaid',
                                      tagColor: Colors.red,
                                    )
                                ],
                              ),
                              subtitle: Text('#${invoice.invNumber}'),
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
                                      create: (context) => InvoiceManagerCubit(
                                        _customersDAO,
                                        _vendorsDAO,
                                        _ledgerEntryDAO,
                                        TransactionCategory.purchase,
                                      ),
                                      child: InvoiceManagerV2(
                                        invoiceFormMode: InvoiceFormMode.Edit,
                                        ledgerEntry: invoice,
                                      ),
                                    ),
                                  ),
                                );
                                _refreshInvoices();
                              },
                            ),
                          );
                        },
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
        );
      },
    );
  }

  Map<String, List<LedgerEntry>> _groupInvoicesByMonth(
      List<LedgerEntry> invoices) {
    final Map<String, List<LedgerEntry>> groupedInvoices = {};
    for (var invoice in invoices) {
      final month = DateFormat('MMMM yyyy').format(invoice.transactionDate);
      if (!groupedInvoices.containsKey(month)) {
        groupedInvoices[month] = [];
      }
      groupedInvoices[month]!.add(invoice);
    }
    return groupedInvoices;
  }
}
