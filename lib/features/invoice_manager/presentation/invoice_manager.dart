import 'package:ease_mvp/core/database/customers_dao.dart';
import 'package:ease_mvp/core/database/inventory_items_dao.dart';
import 'package:ease_mvp/core/database/invoice_items_dao.dart';
import 'package:ease_mvp/core/database/invoices_dao.dart';
import 'package:ease_mvp/core/database/vendors_dao.dart';
import 'package:ease_mvp/core/models/customer.dart';
import 'package:ease_mvp/core/models/inventory_item.dart';
import 'package:ease_mvp/core/models/invoice.dart';
import 'package:ease_mvp/core/models/invoice_item.dart';
import 'package:ease_mvp/core/models/vendor.dart';
import 'package:ease_mvp/core/providers/short_uuid_generator.dart';
import 'package:flutter/material.dart';

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
  const InvoiceManager({
    Key? key,
    required this.invoiceType,
    required this.invoiceFormMode,
  }) : super(key: key);

  @override
  InvoiceManagerState createState() => InvoiceManagerState();
}

class InvoiceManagerState extends State<InvoiceManager> {
  late List<InvoiceItem> _invoiceItems;
  late Customer _customer;
  late Vendor _vendor;

  late Invoice _invoice;

  late double _totalAmount;
  late double _taxes;
  late double _discounts;
  double _grandTotal = 0.0;
  late double _totalAmountDue;
  late double _totalAmountPaid;

  final _itemsDAO = InventoryItemsDAO();
  final _customersDAO = CustomersDAO();
  final _vendorsDAO = VendorsDAO();
  final _invoiceDAO = InvoicesDAO();
  final _invoiceItemsDAO = InvoiceItemsDAO();

  // final String invoiceId = 'INV-${UniqueKey().toString()}';
  final String invoiceId = generateShort12CharUniqueKey().toUpperCase();

  @override
  void initState() {
    super.initState();
    // _fetchItems();
    // if (widget.invoiceType == InvoiceType.Sales) {
    //   _fetchCustomers();
    // } else {
    //   _fetchVendors();
    // }
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
                      '\₹ ' +
                      _grandTotal.toString(),
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
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // Invoice type
                  // Invoice number
                  // Invoice date
                  // Invoice due date
                  // Invoice items
                  // Taxes
                  // Discounts
                  // Notes
                  // Total amount
                  // Total amount after taxes and discounts
                  // Total amount due
                  // Total amount paid
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
    );
  }
}
