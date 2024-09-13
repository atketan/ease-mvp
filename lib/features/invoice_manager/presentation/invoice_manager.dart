import 'package:ease/core/models/invoice.dart';
import 'package:ease/core/providers/short_uuid_generator.dart';
import 'package:ease/features/invoices/data_models/invoice_type_enum.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/invoice_manager_cubit.dart';
import '../bloc/invoice_manager_cubit_state.dart';
import '../widgets/amount_summary_widget.dart';
// import '../widgets/entity_delegate_widget.dart';
import '../widgets/entity_type_ahead_field.dart';
import '../widgets/invoice_items_list_widget.dart';
import '../widgets/invoice_manager_spacer.dart';
import '../widgets/invoice_order_details_widget.dart';
import '../widgets/payment_details_widget.dart';

enum InvoiceFormMode {
  Add,
  Edit,
}

// This is the main widget that will be used to create/update invoices
// It will act as a common form to create/update invoices
// Based on whether it is a sales or a purchase invoice, the form will have different fields
// In either case, the form will depend on InventoryItemsDAO to fetch the list of items
// For Sales invoices, the form will also depend on CustomersDAO to fetch the list of customers
// For Purchase invoices, the form will also depend on VendorsDAO to fetch the list of vendors
// Invoice items will be stored in a separate table in the database - InvoiceItems
// The form will have a list of items that can be added/removed
// The form will also have a field to add taxes
// The form will have a field to add discounts
// The form will have a field to add notes
// The form will have a field to show the total amount
// The form will have a field to show the total amount after taxes and discounts
// The form will have a field to show the total amount due
// The form will have a field to show the total amount paid

class InvoiceManager extends StatefulWidget {
  final InvoiceType invoiceType;
  final InvoiceFormMode invoiceFormMode;
  final Invoice? invoice;

  InvoiceManager({
    Key? key,
    required this.invoiceType,
    required this.invoiceFormMode,
    this.invoice,
  }) : super(key: key) {
    assert(invoiceFormMode != InvoiceFormMode.Edit || invoice != null,
        'Invoice cannot be null in Edit mode');
  }

  @override
  InvoiceManagerState createState() => InvoiceManagerState();
}

class InvoiceManagerState extends State<InvoiceManager> {
  final String invoiceId = generateShort12CharUniqueKey().toUpperCase();
  final DateTime invoiceCreateDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    context.read<InvoiceManagerCubit>().initialiseInvoiceModelInstance(
          widget.invoiceFormMode == InvoiceFormMode.Edit
              ? widget.invoice!
              : Invoice(
                  customerId: 0,
                  invoiceNumber: invoiceId,
                  date: invoiceCreateDate,
                  totalAmount: 0.0,
                  discount: 0.0,
                  taxes: 0.0,
                  grandTotal: 0.0,
                  paymentType: 'cash',
                  status: 'unpaid',
                ),
        );
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'INVOICE: #$invoiceId',
              style: Theme.of(context)
                  .textTheme
                  .labelLarge!
                  .copyWith(color: Theme.of(context).colorScheme.surface),
            ),
            Text(
              '${widget.invoiceFormMode == InvoiceFormMode.Add ? 'NEW' : 'UPDATE'} | ${widget.invoiceType == InvoiceType.Sales ? 'SALE' : 'PURCHASE'}',
              style: Theme.of(context)
                  .textTheme
                  .labelMedium!
                  .copyWith(color: Theme.of(context).colorScheme.surface),
            ),
          ],
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Get customer or vendor details
                  // EntityDelegateWidget(
                  //   invoiceType: widget.invoiceType,
                  // ),
                  SizedBox(height: 8),
                  EntityTypeAheadField(
                    invoiceType: widget.invoiceType,
                  ),
                  // Add separation space
                  InvoiceManagerSpacer(),
                  // Build invoice items list
                  BlocBuilder<InvoiceManagerCubit, InvoiceManagerCubitState>(
                    builder: (context, state) {
                      if (state is InvoiceManagerLoaded) {
                        return InvoiceItemsListWidget.searchBoxLayout();
                      } else if (state is InvoiceManagerLoading) {
                        return Center(child: CircularProgressIndicator());
                      } else if (state is InvoiceManagerError) {
                        return Center(child: Text('Error: ${state.message}'));
                      } else {
                        return Center(child: Text('Unknown state'));
                      }
                    },
                  ),

                  InvoiceManagerSpacer(),

                  // Manage discount, taxes and gross total
                  BlocBuilder<InvoiceManagerCubit, InvoiceManagerCubitState>(
                    builder: (context, state) {
                      if (state is InvoiceManagerLoaded) {
                        return AmountSummaryWidget();
                      } else if (state is InvoiceManagerLoading) {
                        return Center(child: CircularProgressIndicator());
                      } else if (state is InvoiceManagerError) {
                        return Center(child: Text('Error: ${state.message}'));
                      } else {
                        return Center(child: Text('Unknown state'));
                      }
                    },
                  ),

                  InvoiceManagerSpacer(height: 0),

                  // Payment type and status
                  BlocBuilder<InvoiceManagerCubit, InvoiceManagerCubitState>(
                    builder: (context, state) {
                      if (state is InvoiceManagerLoaded) {
                        return PaymentDetailsWidget();
                      } else if (state is InvoiceManagerLoading) {
                        return Center(child: CircularProgressIndicator());
                      } else if (state is InvoiceManagerError) {
                        return Center(child: Text('Error: ${state.message}'));
                      } else {
                        return Center(child: Text('Unknown state'));
                      }
                    },
                  ),

                  InvoiceManagerSpacer(height: 0),

                  // Show non-editable invoice headers
                  BlocBuilder<InvoiceManagerCubit, InvoiceManagerCubitState>(
                    builder: (context, state) {
                      if (state is InvoiceManagerLoaded) {
                        return InvoiceOrderDetailsWidget();
                      } else if (state is InvoiceManagerLoading) {
                        return Center(child: CircularProgressIndicator());
                      } else if (state is InvoiceManagerError) {
                        return Center(child: Text('Error: ${state.message}'));
                      } else {
                        return Center(child: Text('Unknown state'));
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
          Container(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    flex: 4,
                    child: Container(),
                    // child: TextButton(
                    //   onPressed: () {
                    //     // Share action
                    //   },
                    //   child: Text(
                    //     'Share',
                    //     style: TextStyle().copyWith(
                    //       fontWeight: FontWeight.bold,
                    //     ),
                    //   ),
                    //   style: ButtonStyle().copyWith(
                    //     backgroundColor: MaterialStateProperty.all<Color>(
                    //       Theme.of(context).colorScheme.background,
                    //     ),
                    //     foregroundColor: MaterialStateProperty.all<Color>(
                    //       Theme.of(context).colorScheme.primary,
                    //     ),
                    //     side: MaterialStateProperty.all<BorderSide>(
                    //       BorderSide(
                    //         color: Theme.of(context).colorScheme.primary,
                    //         width: 1.0,
                    //       ),
                    //     ),
                    //   ),
                    // ),
                  ),
                  Spacer(flex: 1),
                  Expanded(
                    flex: 4,
                    child: OutlinedButton(
                      onPressed: () async {
                        await context
                            .read<InvoiceManagerCubit>()
                            .saveInvoice()
                            .then(
                          (value) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Invoice updated successfully!'),
                              ),
                            );
                            Navigator.pop(context);
                          },
                        );
                      },
                      child: Text(
                        'SAVE',
                        style: TextStyle().copyWith(
                          fontWeight: FontWeight.bold,
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
  }
}
