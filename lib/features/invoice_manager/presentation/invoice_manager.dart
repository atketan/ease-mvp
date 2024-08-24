import 'package:ease_mvp/core/database/inventory_items_dao.dart';
import 'package:ease_mvp/core/database/invoice_items_dao.dart';
import 'package:ease_mvp/core/database/invoices_dao.dart';
import 'package:ease_mvp/core/models/customer.dart';
import 'package:ease_mvp/core/models/invoice.dart';
import 'package:ease_mvp/core/models/invoice_item.dart';
import 'package:ease_mvp/core/models/vendor.dart';
import 'package:ease_mvp/core/providers/short_uuid_generator.dart';
import 'package:ease_mvp/features/invoice_manager/bloc/invoice_manager_cubit_state.dart';
import 'package:ease_mvp/features/invoice_manager/widgets/invoice_item_delegate_widget.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/invoice_manager_cubit.dart';
import '../widgets/entity_delegate_widget.dart';
import '../widgets/invoice_order_details_widget.dart';

enum InvoiceType {
  Sales,
  Purchase,
}

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
  late List<InvoiceItem> _invoiceItems;
  late Customer _customer;
  late Vendor _vendor;

  late double _totalAmount;
  late double _taxes;
  late double _discounts;
  double _grandTotal = 0.0;

  final _itemsDAO = InventoryItemsDAO();
  final _invoiceDAO = InvoicesDAO();
  final _invoiceItemsDAO = InvoiceItemsDAO();

  // final String invoiceId = 'INV-${UniqueKey().toString()}';
  final String invoiceId = generateShort12CharUniqueKey().toUpperCase();
  final DateTime invoiceCreateDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    _invoiceItems = [];
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => InvoiceManagerCubit(),
      child: BlocListener<InvoiceManagerCubit, InvoiceManagerCubitState>(
        listener: (context, state) {
          // Handle state changes here
          if (state is InvoiceManagerInitial) {
            context.read<InvoiceManagerCubit>().initialiseInvoice(
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
        },
        child: Scaffold(
          appBar: AppBar(
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'INVOICE: #' + invoiceId,
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      (widget.invoiceFormMode == InvoiceFormMode.Add
                              ? 'NEW | '
                              : 'UPDATE | ') +
                          (widget.invoiceType == InvoiceType.Sales
                              ? 'SALE'
                              : 'PURCHASE'),
                      // +
                      // ' | \₹ ' +
                      // _grandTotal.toString(),
                      style: Theme.of(context)
                          .textTheme
                          .titleSmall!
                          .copyWith(color: Colors.white),
                    ),
                  ],
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
                      // (widget.invoiceType == InvoiceType.Sales)
                      //     ? CustomerDetailsWidget()
                      //     : VendorDetailsWidget(),

                      EntityDelegateWidget(
                        invoice: context.read<InvoiceManagerCubit>().invoice,
                        invoiceType: widget.invoiceType,
                      ),
                      InvoiceManagerSpacer(),

                      InvoiceItemsListWidget(invoiceItems: _invoiceItems),

                      // Taxes
                      // Discounts
                      // Total amount
                      // Total amount after taxes and discounts
                      // Total amount due
                      // Total amount paid

                      InvoiceManagerSpacer(),

                      // Show non-editable invoice headers
                      InvoiceOrderDetailsWidget(
                        invoice: context.read<InvoiceManagerCubit>().invoice,
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                color: Colors.white,
                padding: EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      flex: 4,
                      child: TextButton(
                        onPressed: () {
                          // Share action
                        },
                        child: Text(
                          'Share',
                          style: TextStyle().copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        style: ButtonStyle().copyWith(
                          backgroundColor: MaterialStateProperty.all<Color>(
                            Theme.of(context).colorScheme.background,
                          ),
                          foregroundColor: MaterialStateProperty.all<Color>(
                            Theme.of(context).colorScheme.primary,
                          ),
                          side: MaterialStateProperty.all<BorderSide>(
                            BorderSide(
                              color: Theme.of(context).colorScheme.primary,
                              width: 1.0,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Spacer(flex: 1),
                    Expanded(
                      flex: 4,
                      child: TextButton(
                        onPressed: () {
                          // Save action
                        },
                        child: Text(
                          'Save',
                          style: TextStyle().copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class InvoiceManagerSpacer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 12,
      color: Theme.of(context).colorScheme.surfaceVariant,
    );
  }
}

class InvoiceItemsListWidget extends StatefulWidget {
  final List<InvoiceItem> invoiceItems;

  InvoiceItemsListWidget({
    Key? key,
    required this.invoiceItems,
  }) : super(key: key);

  @override
  InvoiceItemsListWidgetState createState() => InvoiceItemsListWidgetState();
}

class InvoiceItemsListWidgetState extends State<InvoiceItemsListWidget> {
  late List<InvoiceItem> _invoiceItems;
  @override
  void initState() {
    _invoiceItems = widget.invoiceItems;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Items",
                style: Theme.of(context).textTheme.titleLarge!.copyWith(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
              ),
              IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    new MaterialPageRoute(
                      builder: (BuildContext context) =>
                          InvoiceItemDelegateWidget(),
                    ),
                  ).then(
                    (invoiceItem) {
                      debugPrint((invoiceItem as InvoiceItem).name);
                      setState(() {
                        _invoiceItems.add(invoiceItem);
                      });
                    },
                  );
                },
                icon: Icon(
                  Icons.add_circle_outline,
                  size: 36,
                ),
              ),
            ],
          ),
          SizedBox(height: 12),
          ListView.builder(
            shrinkWrap: true,
            itemCount: _invoiceItems.length,
            physics: NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              final item = _invoiceItems[index];
              return Container(
                padding: const EdgeInsets.only(bottom: 6, top: 6),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: Theme.of(context).colorScheme.tertiaryContainer,
                      width: 1.0,
                    ),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.name,
                            softWrap: true,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium!
                                .copyWith(fontWeight: FontWeight.bold),
                          ),
                          Text(
                            'Unit Price: ${item.unitPrice}',
                            style: Theme.of(context).textTheme.titleSmall,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 4),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Theme.of(context).colorScheme.primary,
                              width: 1.0,
                            ),
                            borderRadius: BorderRadius.circular(4.0),
                          ),
                          child: Row(
                            children: [
                              IconButton(
                                icon: Icon(Icons.remove),
                                onPressed: () {
                                  if (item.quantity == 1) {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          shape: ContinuousRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              8.0,
                                            ),
                                          ),
                                          title: Text(
                                            'Confirm Deletion',
                                          ),
                                          content: Text(
                                            'Are you sure you want to delete this item?',
                                          ),
                                          actions: [
                                            TextButton(
                                              child: Text('Cancel'),
                                              onPressed: () {
                                                Navigator.of(context)
                                                    .pop(); // Close the dialog
                                              },
                                            ),
                                            TextButton(
                                              child: Text('Delete'),
                                              onPressed: () {
                                                setState(() {
                                                  _invoiceItems.removeAt(index);
                                                });
                                                Navigator.of(context)
                                                    .pop(); // Close the dialog
                                              },
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  }
                                  if (item.quantity > 1) {
                                    setState(() {
                                      item.quantity--;
                                      item.totalPrice =
                                          item.quantity * item.unitPrice;
                                    });
                                  }
                                },
                              ),
                              Text(
                                '${item.quantity}',
                                style: TextStyle(fontSize: 18),
                              ),
                              IconButton(
                                icon: Icon(Icons.add),
                                onPressed: () {
                                  setState(() {
                                    item.quantity++;
                                    item.totalPrice =
                                        item.quantity * item.unitPrice;
                                  });
                                },
                              ),
                            ],
                          ),
                        ),
                        Container(
                          width: 64,
                          alignment: Alignment.centerRight,
                          child: Text(
                            "\₹" + item.totalPrice.toString(),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
