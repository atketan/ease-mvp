import 'package:ease/core/models/invoice.dart';
import 'package:ease/core/utils/developer_log.dart';
import 'package:ease/features/home_invoices/widgets/custom_chip_tags_widget.dart';
import 'package:ease/features/invoice_manager/bloc/invoice_manager_cubit.dart';
import 'package:ease/features/invoice_manager/presentation/invoice_manager.dart';
import 'package:ease/features/invoices/data_models/invoice_type_enum.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../data/invoices_provider.dart';

class AllSalesInvoicesTab extends StatefulWidget {
  @override
  _AllSalesInvoicesTabState createState() => _AllSalesInvoicesTabState();
}

class _AllSalesInvoicesTabState extends State<AllSalesInvoicesTab> {
  @override
  void initState() {
    super.initState();
    // not needed if the parent is calling same method, use when to be run as a separate widget
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<InvoicesProvider>(context, listen: false)
          .fetchAllSalesInvoices();
    });
  }

  void _refreshInvoices() {
    debugLog('Refresh all sales invoices called', name: 'AllSalesInvoicesTab');
    Provider.of<InvoicesProvider>(context, listen: false)
        .fetchAllSalesInvoices();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<InvoicesProvider>(
      builder: (context, invoicesProvider, child) {
        debugLog(
            'Building AllSalesInvoicesTab with ${invoicesProvider.allSalesInvoices.length} invoices',
            name: 'InvoicesProvider');
        final groupedInvoices =
            _groupInvoicesByMonth(invoicesProvider.allSalesInvoices);

        return Column(
          children: [
            // Padding(
            //   padding: const EdgeInsets.all(12.0),
            //   child: Text(
            //     'Total Amount to be Collected: ₹${invoicesProvider.totalUnpaidAmount.toStringAsFixed(2)}',
            //     style: Theme.of(context).textTheme.titleMedium,
            //   ),
            // ),
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
                      ListView.separated(
                        itemCount: invoices.length,
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        separatorBuilder: (context, index) => Divider(
                          color: Theme.of(context).cardColor,
                          thickness: 1,
                          indent: 24.0,
                          endIndent: 24.0,
                        ),
                        itemBuilder: (context, index) {
                          final invoice = invoices[index];
                          return Slidable(
                            key: Key(invoice.id.toString()),
                            startActionPane: ActionPane(
                              motion: ScrollMotion(),
                              children: [
                                (invoice.status != "paid")
                                    ? SlidableAction(
                                        onPressed: (context) {
                                          // Handle action for left swipe
                                          // For example, mark as paid
                                          invoicesProvider
                                              .markInvoiceAsPaid(invoice);
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                                content: Text(
                                                    'Invoice marked as paid')),
                                          );
                                          Provider.of<InvoicesProvider>(context,
                                                  listen: false)
                                              .fetchAllSalesInvoices();
                                        },
                                        backgroundColor: Colors.blueGrey,
                                        foregroundColor: Colors.white,
                                        icon: Icons.check,
                                        label: 'Mark as Paid',
                                      )
                                    : SlidableAction(
                                        onPressed: (context) {
                                          // Handle action for left swipe
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                                content: Text(
                                                    'Invoice is fully paid')),
                                          );
                                        },
                                        backgroundColor: Colors.green,
                                        foregroundColor: Colors.white,
                                        icon: Icons.check,
                                        label: 'Fully Paid',
                                      ),
                                // SlidableAction(
                                //   onPressed: (context) {
                                //     // Handle action for right swipe
                                //     // To Do
                                //   },
                                //   backgroundColor: Colors.red,
                                //   foregroundColor: Colors.white,
                                //   icon: Icons.delete,
                                //   label: 'Delete',
                                // ),
                              ],
                            ),
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
                                              InvoiceManagerCubit(),
                                          child: InvoiceManager(
                                            invoiceType: InvoiceType.Sales,
                                            invoiceFormMode:
                                                InvoiceFormMode.Edit,
                                            invoice: invoice,
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
                            child: Card(
                              child: ListTile(
                                dense: true,
                                title: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          '${invoice.name}',
                                          style: Theme.of(context)
                                              .textTheme
                                              .labelLarge,
                                        ),
                                        Text(
                                          '#${invoice.invoiceNumber}',
                                          style: Theme.of(context)
                                              .textTheme
                                              .labelMedium,
                                        ),
                                      ],
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
                                subtitle: Text(
                                  'Date: ${DateFormat.yMMMd().format(invoice.date)}',
                                  style:
                                      Theme.of(context).textTheme.labelMedium,
                                ),
                                trailing: Text(
                                  '₹${invoice.grandTotal.toStringAsFixed(2)}',
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
                                        create: (context) =>
                                            InvoiceManagerCubit(),
                                        child: InvoiceManager(
                                          invoiceType: InvoiceType.Sales,
                                          invoiceFormMode: InvoiceFormMode.Edit,
                                          invoice: invoice,
                                        ),
                                      ),
                                    ),
                                  );
                                  _refreshInvoices();
                                },
                              ),
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

  Map<String, List<Invoice>> _groupInvoicesByMonth(List<Invoice> invoices) {
    final Map<String, List<Invoice>> groupedInvoices = {};
    for (var invoice in invoices) {
      final month = DateFormat('MMMM yyyy').format(invoice.date);
      if (!groupedInvoices.containsKey(month)) {
        groupedInvoices[month] = [];
      }
      groupedInvoices[month]!.add(invoice);
    }
    return groupedInvoices;
  }
}
