import 'package:ease/core/database/inventory/inventory_items_dao.dart';
import 'package:ease/core/database/invoice_items/invoice_items_dao.dart';
import 'package:ease/core/database/invoices/invoices_dao.dart';
import 'package:ease/core/database/payments/payments_dao.dart';
import 'package:ease/core/enums/invoice_type_enum.dart';
import 'package:ease/features/invoice_manager/bloc/invoice_manager_cubit.dart';
import 'package:ease/features/invoice_manager/presentation/invoice_manager.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../data/invoices_provider.dart';

class PaidInvoicesTab extends StatefulWidget {
  @override
  _PaidInvoicesTabState createState() => _PaidInvoicesTabState();
}

class _PaidInvoicesTabState extends State<PaidInvoicesTab> {
  late InvoicesDAO _invoicesDAO;
  late InventoryItemsDAO _inventoryItemsDAO;
  late PaymentsDAO _paymentsDAO;
  late InvoiceItemsDAO _invoiceItemsDAO;

  @override
  void initState() {
    super.initState();
    // not needed if the parent is calling same method, use when to be run as a separate widget
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Provider.of<InvoicesProvider>(context, listen: false).fetchPaidInvoices();
    });
  }

  @override
  Widget build(BuildContext context) {
    _invoicesDAO = Provider.of<InvoicesDAO>(context);
    _inventoryItemsDAO = Provider.of<InventoryItemsDAO>(context);
    _paymentsDAO = Provider.of<PaymentsDAO>(context);
    _invoiceItemsDAO = Provider.of<InvoiceItemsDAO>(context);

    final invoicesProvider = Provider.of<InvoicesProvider>(context);

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: Text(
            'Total Amount Received: ₹${invoicesProvider.totalPaidAmount.toStringAsFixed(2)}',
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: invoicesProvider.paidInvoices.length,
            itemBuilder: (context, index) {
              final invoice = invoicesProvider.paidInvoices[index];
              return ListTile(
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
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                onLongPress: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (BuildContext context) => BlocProvider(
                        create: (context) => InvoiceManagerCubit(_invoicesDAO,
                            _inventoryItemsDAO, _paymentsDAO, _invoiceItemsDAO),
                        child: InvoiceManager(
                          invoiceType: InvoiceType.Sales,
                          invoiceFormMode: InvoiceFormMode.Edit,
                          invoice: invoice,
                        ),
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
