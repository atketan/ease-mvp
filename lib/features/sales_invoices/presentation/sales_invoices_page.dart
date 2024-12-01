import 'package:ease/core/database/customers/customers_dao.dart';
import 'package:ease/core/database/inventory/inventory_items_dao.dart';
import 'package:ease/core/database/invoice_items/invoice_items_dao.dart';
import 'package:ease/core/database/invoices/invoices_dao.dart';
import 'package:ease/core/database/payments/payments_dao.dart';
import 'package:ease/core/database/vendors/vendors_dao.dart';
import 'package:ease/core/enums/invoice_type_enum.dart';
import 'package:ease/core/utils/developer_log.dart';
import 'package:ease/features/home_invoices/data/invoices_provider.dart';
import 'package:ease/features/home_invoices/widgets/custom_chip_tags_widget.dart';
import 'package:ease/features/invoice_manager/bloc/invoice_manager_cubit.dart';
import 'package:ease/features/invoice_manager/presentation/invoice_manager.dart';
import 'package:ease/widgets/time_range_selector.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';

import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

class SalesInvoicesProviderWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => InvoicesProvider(context.read<InvoicesDAO>()),
      child: SalesInvoicesPage(),
    );
  }
}

class SalesInvoicesPage extends StatefulWidget {
  @override
  State<SalesInvoicesPage> createState() => _SalesInvoicesPageState();
}

class _SalesInvoicesPageState extends State<SalesInvoicesPage> {
  late InvoicesDAO _invoicesDAO;
  late InventoryItemsDAO _inventoryItemsDAO;
  late PaymentsDAO _paymentsDAO;
  late InvoiceItemsDAO _invoiceItemsDAO;
  late CustomersDAO _customersDAO;
  late VendorsDAO _vendorsDAO;

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
    _invoicesDAO = Provider.of<InvoicesDAO>(context);
    _inventoryItemsDAO = Provider.of<InventoryItemsDAO>(context);
    _paymentsDAO = Provider.of<PaymentsDAO>(context);
    _invoiceItemsDAO = Provider.of<InvoiceItemsDAO>(context);
    _customersDAO = Provider.of<CustomersDAO>(context);
    _vendorsDAO = Provider.of<VendorsDAO>(context);

    return Consumer<InvoicesProvider>(
      builder: (context, invoicesProvider, child) {
        debugLog(
            'Building SalesInvoicesPage with ${invoicesProvider.allSalesInvoices.length} invoices',
            name: 'SalesInvoicesPage');

        return Scaffold(
          appBar: AppBar(
            title: Text('Sales Invoices'),
          ),
          body: Column(
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
                },
              ),
              Divider(),
              Expanded(
                child: ListView.builder(
                  itemCount: invoicesProvider.allSalesInvoices.length,
                  itemBuilder: (context, index) {
                    final invoice = invoicesProvider.allSalesInvoices[index];
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Slidable(
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
                                            InvoiceManagerCubit(
                                          _invoicesDAO,
                                          _inventoryItemsDAO,
                                          _paymentsDAO,
                                          _invoiceItemsDAO,
                                          _customersDAO,
                                          _vendorsDAO,
                                          InvoiceType.Sales,
                                        ),
                                        child: InvoiceManager(
                                          invoiceFormMode: InvoiceFormMode.Edit,
                                          invoice: invoice,
                                        ),
                                      ),
                                    ),
                                  );
                                  _refreshInvoices();
                                },
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
                                style: Theme.of(context).textTheme.labelMedium,
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
                                      create: (context) => InvoiceManagerCubit(
                                        _invoicesDAO,
                                        _inventoryItemsDAO,
                                        _paymentsDAO,
                                        _invoiceItemsDAO,
                                        _customersDAO,
                                        _vendorsDAO,
                                        InvoiceType.Sales,
                                      ),
                                      child: InvoiceManager(
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
