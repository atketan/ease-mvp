import 'package:ease/core/database/customers/customers_dao.dart';
import 'package:ease/core/database/ledger/ledger_entry_dao.dart';
import 'package:ease/core/database/vendors/vendors_dao.dart';
import 'package:ease/core/enums/transaction_category_enum.dart';
import 'package:ease/core/utils/developer_log.dart';
import 'package:ease/features/home_invoices/data/invoices_provider.dart';
import 'package:ease/features/home_invoices/widgets/custom_chip_tags_widget.dart';
import 'package:ease/features/invoice_manager_v2/bloc/invoice_manager_v2_cubit.dart';
import 'package:ease/features/invoice_manager_v2/presentation/invoice_manager_v2.dart';

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
      create: (context) => InvoicesProvider(context.read<LedgerEntryDAO>()),
      child: SalesInvoicesPage(),
    );
  }
}

class SalesInvoicesPage extends StatefulWidget {
  @override
  State<SalesInvoicesPage> createState() => _SalesInvoicesPageState();
}

class _SalesInvoicesPageState extends State<SalesInvoicesPage> {
  late CustomersDAO _customersDAO;
  late VendorsDAO _vendorsDAO;
  late LedgerEntryDAO _ledgerEntryDAO;

  @override
  void initState() {
    super.initState();
  }

  void _refreshInvoices() {
    debugLog('Refresh all sales invoices called', name: 'SalesInvoicesPage');
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
                    name: 'SalesInvoicesPage',
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
                                          TransactionCategory.sales,
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
                            subtitle: Text('#${invoice.id}'),
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
                                      TransactionCategory.sales,
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
