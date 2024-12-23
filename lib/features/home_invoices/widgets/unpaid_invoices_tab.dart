import 'package:ease/core/database/customers/customers_dao.dart';
import 'package:ease/core/database/inventory/inventory_items_dao.dart';
import 'package:ease/core/database/invoice_items/invoice_items_dao.dart';
import 'package:ease/core/database/invoices/invoices_dao.dart';
import 'package:ease/core/database/payments/payments_dao.dart';
import 'package:ease/core/database/vendors/vendors_dao.dart';
import 'package:ease/core/enums/invoice_type_enum.dart';
import 'package:ease/core/models/invoice.dart';
import 'package:ease/core/utils/developer_log.dart';
import 'package:ease/features/invoice_manager/bloc/invoice_manager_cubit.dart';
import 'package:ease/features/invoice_manager/presentation/invoice_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../data/invoices_provider.dart';

class UnpaidInvoicesTab extends StatefulWidget {
  @override
  _UnpaidInvoicesTabState createState() => _UnpaidInvoicesTabState();
}

class _UnpaidInvoicesTabState extends State<UnpaidInvoicesTab> {
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
      // Provider.of<InvoicesProvider>(context, listen: false)
      //     .fetchUnpaidInvoices();
    });
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
            'Building UnpaidInvoicesTab with ${invoicesProvider.unpaidInvoices.length} invoices',
            name: 'InvoicesProvider');
        final groupedInvoices =
            _groupInvoicesByMonth(invoicesProvider.unpaidInvoices);

        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Text(
                'Total Amount to be Collected: ₹${invoicesProvider.totalUnpaidAmount.toStringAsFixed(2)}',
                style: Theme.of(context).textTheme.titleMedium,
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
                      ...invoices
                          .map(
                            (invoice) => Dismissible(
                              key: Key(invoice.id.toString()),
                              background: Container(
                                color: Colors.green,
                                alignment: Alignment.centerRight,
                                padding: EdgeInsets.only(right: 20.0),
                                child: Icon(Icons.check, color: Colors.white),
                              ),
                              direction: DismissDirection.endToStart,
                              onDismissed: (direction) {
                                invoicesProvider.markInvoiceAsPaid(invoice);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content: Text('Invoice marked as paid')),
                                );
                              },
                              child: ListTile(
                                dense: true,
                                title: Text(
                                  '#${invoice.invoiceNumber}',
                                  style: Theme.of(context).textTheme.titleSmall,
                                ),
                                subtitle: Text(
                                  'Date: ${DateFormat.yMMMd().format(invoice.date)}',
                                  style: Theme.of(context).textTheme.titleSmall,
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
                                onLongPress: () {
                                  Navigator.push(
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
                                          InvoiceType
                                              .Sales, // if we are tracking unpaid invoices, it could either be Sales/Purchases both, so we need to pass the invoice type dynamically
                                        ),
                                        child: InvoiceManager(
                                          invoiceFormMode: InvoiceFormMode.Edit,
                                          invoice: invoice,
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          )
                          .toList(),
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
