import 'package:ease/core/enums/invoice_type_enum.dart';
import 'package:ease/core/models/invoice.dart';
import 'package:ease/core/providers/short_uuid_generator.dart';
import 'package:ease/features/invoice_manager/widgets/discount_manager_widget.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:share_plus/share_plus.dart';

import '../bloc/invoice_manager_cubit.dart';
import '../bloc/invoice_manager_cubit_state.dart';
// import '../widgets/amount_summary_widget.dart';
// import '../widgets/entity_delegate_widget.dart';
import '../widgets/entity_type_ahead_field.dart';
import '../widgets/invoice_items_list_widget.dart';
import '../widgets/invoice_manager_spacer.dart';
import '../widgets/invoice_notes_widget.dart';
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
  final String invoiceNumber = generateShort12CharUniqueKey().toUpperCase();
  // final DateTime invoiceCreateDate = DateTime.now();

  List<bool> _isOpen = [false, false, false, false];

  @override
  void initState() {
    super.initState();
    context
        .read<InvoiceManagerCubit>()
        .initialiseInvoiceModelInstance(widget.invoice, invoiceNumber);
    if (widget.invoiceFormMode == InvoiceFormMode.Edit) {
      context.read<InvoiceManagerCubit>().populateInvoiceData();
    }
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
              'INVOICE: #$invoiceNumber',
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
                  InvoiceManagerSpacer(height: 4, horizontalPadding: 0),
                  ExpansionPanelList(
                    expandIconColor: Theme.of(context).primaryColorDark,
                    materialGapSize: 2,
                    expandedHeaderPadding: EdgeInsets.symmetric(vertical: 0),
                    dividerColor: Theme.of(context).primaryColorLight,
                    children: [
                      ExpansionPanel(
                        canTapOnHeader: true,
                        isExpanded: _isOpen[0],
                        headerBuilder: (context, isExpanded) {
                          return Container(
                            color: isExpanded
                                ? Theme.of(context).secondaryHeaderColor
                                : Colors.transparent,
                            child: ListTile(
                              leading: Icon(Icons.person_2_outlined),
                              title: Text(
                                widget.invoiceType == InvoiceType.Sales
                                    ? 'CUSTOMER'
                                    : 'VENDOR',
                                style: Theme.of(context).textTheme.labelLarge,
                              ),
                              trailing: BlocBuilder<InvoiceManagerCubit,
                                  InvoiceManagerCubitState>(
                                builder: (context, state) {
                                  if (state is InvoiceManagerLoaded) {
                                    String? selectedClientName =
                                        state.invoice.name;
                                    if (selectedClientName.isEmpty)
                                      selectedClientName = null;
                                    return Text(
                                      widget.invoiceType == InvoiceType.Sales
                                          ? '${selectedClientName ?? 'Select a customer'}'
                                          : '${selectedClientName ?? 'Select a vendor'}',
                                      style: Theme.of(context)
                                          .textTheme
                                          .labelLarge,
                                    );
                                  } else if (state is InvoiceManagerLoading) {
                                    return Center(
                                        child: CircularProgressIndicator());
                                  } else if (state is InvoiceManagerError) {
                                    return Center(
                                        child: Text('Error: ${state.message}'));
                                  } else {
                                    return Center(child: Text('Err'));
                                  }
                                },
                              ),
                            ),
                          );
                        },
                        body: Card(
                          child: EntityTypeAheadField(
                            invoiceType: widget.invoiceType,
                            onClientSelected: (clientName) {
                              context
                                  .read<InvoiceManagerCubit>()
                                  .setEntityName(clientName);
                              // selectedClientName = clientName;
                            },
                          ),
                        ),
                      ),
                      ExpansionPanel(
                        canTapOnHeader: true,
                        isExpanded: _isOpen[1],
                        headerBuilder: (context, isExpanded) {
                          return Container(
                            color: isExpanded
                                ? Theme.of(context).secondaryHeaderColor
                                : Colors.transparent,
                            child: ListTile(
                              leading: Icon(Icons.shopping_cart_outlined),
                              title: Text(
                                'ITEMS',
                                style: Theme.of(context).textTheme.labelLarge,
                              ),
                              trailing: BlocBuilder<InvoiceManagerCubit,
                                  InvoiceManagerCubitState>(
                                builder: (context, state) {
                                  if (state is InvoiceManagerLoaded) {
                                    return Text(
                                      "+₹" +
                                          context
                                              .read<InvoiceManagerCubit>()
                                              .invoice
                                              .totalAmount
                                              .toString(),
                                      style: Theme.of(context)
                                          .textTheme
                                          .labelLarge,
                                    );
                                  } else if (state is InvoiceManagerLoading) {
                                    return Center(
                                        child: CircularProgressIndicator());
                                  } else if (state is InvoiceManagerError) {
                                    return Center(
                                        child: Text('Error: ${state.message}'));
                                  } else {
                                    return Center(child: Text('Err'));
                                  }
                                },
                              ),
                            ),
                          );
                        },
                        body: Card(
                          child: BlocBuilder<InvoiceManagerCubit,
                              InvoiceManagerCubitState>(
                            builder: (context, state) {
                              if (state is InvoiceManagerLoaded) {
                                return InvoiceItemsListWidget.searchBoxLayout();
                              } else if (state is InvoiceManagerLoading) {
                                return Center(
                                    child: CircularProgressIndicator());
                              } else if (state is InvoiceManagerError) {
                                return Center(
                                    child: Text('Error: ${state.message}'));
                              } else {
                                return Center(child: Text('Unknown state'));
                              }
                            },
                          ),
                        ),
                      ),
                      ExpansionPanel(
                        canTapOnHeader: true,
                        isExpanded: _isOpen[2],
                        headerBuilder: (context, isExpanded) {
                          return Container(
                            color: isExpanded
                                ? Theme.of(context).secondaryHeaderColor
                                : Colors.transparent,
                            child: ListTile(
                              leading: Icon(Icons.discount_outlined),
                              title: Text(
                                'DISCOUNT',
                                style: Theme.of(context).textTheme.labelLarge,
                              ),
                              trailing: BlocBuilder<InvoiceManagerCubit,
                                  InvoiceManagerCubitState>(
                                builder: (context, state) {
                                  if (state is InvoiceManagerLoaded) {
                                    return Text(
                                      "-₹" +
                                          context
                                              .read<InvoiceManagerCubit>()
                                              .invoice
                                              .discount
                                              .toString(),
                                      style: Theme.of(context)
                                          .textTheme
                                          .labelLarge,
                                    );
                                  } else if (state is InvoiceManagerLoading) {
                                    return Center(
                                        child: CircularProgressIndicator());
                                  } else if (state is InvoiceManagerError) {
                                    return Center(
                                        child: Text('Error: ${state.message}'));
                                  } else {
                                    return Center(child: Text('Err'));
                                  }
                                },
                              ),
                            ),
                          );
                        },
                        body: Card(
                          child: DiscountManagerWidget(),
                        ),
                      ),
                      ExpansionPanel(
                        canTapOnHeader: true,
                        isExpanded: _isOpen[3],
                        headerBuilder: (context, isExpanded) {
                          return Container(
                            color: isExpanded
                                ? Theme.of(context).secondaryHeaderColor
                                : Colors.transparent,
                            child: ListTile(
                              leading: Icon(Icons.notes_outlined),
                              title: Text(
                                'NOTES',
                                style: Theme.of(context).textTheme.labelLarge,
                              ),
                            ),
                          );
                        },
                        body: Card(
                          child: InvoiceNotesWidget(
                            initialNotes: context
                                    .read<InvoiceManagerCubit>()
                                    .invoice
                                    .notes ??
                                "",
                          ),
                          // Payment type and status
                          //     BlocBuilder<InvoiceManagerCubit,
                          //         InvoiceManagerCubitState>(
                          //   builder: (context, state) {
                          //     debugLog(context
                          //         .read<InvoiceManagerCubit>()
                          //         .invoice
                          //         .notes
                          //         .toString());
                          //     if (state is InvoiceManagerLoaded) {
                          //       return InvoiceNotesWidget(
                          //           initialNotes: context
                          //                   .read<InvoiceManagerCubit>()
                          //                   .invoice
                          //                   .notes ??
                          //               "");
                          //     } else if (state is InvoiceManagerLoading) {
                          //       return Center(
                          //           child: CircularProgressIndicator());
                          //     } else if (state is InvoiceManagerError) {
                          //       return Center(
                          //           child: Text('Error: ${state.message}'));
                          //     } else {
                          //       return Center(child: Text('Unknown state'));
                          //     }
                          //   },
                          // ),
                        ),
                      ),
                    ],
                    expansionCallback: (panelIndex, isExpanded) => setState(() {
                      _isOpen[panelIndex] = isExpanded;
                    }),
                  ),
                  ListTile(
                    tileColor: Theme.of(context).primaryColorLight,
                    leading: Icon(Icons.account_balance_outlined),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.zero, // Remove circular edges
                    ),
                    title: Text(
                      "TOTAL PAYABLE",
                      style: Theme.of(context).textTheme.labelLarge,
                    ),
                    trailing: BlocBuilder<InvoiceManagerCubit,
                        InvoiceManagerCubitState>(
                      builder: (context, state) {
                        if (state is InvoiceManagerLoaded) {
                          return Text(
                            "₹" +
                                context
                                    .read<InvoiceManagerCubit>()
                                    .invoice
                                    .grandTotal
                                    .toString(),
                            style: Theme.of(context)
                                .textTheme
                                .bodyLarge!
                                .copyWith(fontWeight: FontWeight.bold),
                          );
                        } else if (state is InvoiceManagerLoading) {
                          return Center(child: CircularProgressIndicator());
                        } else if (state is InvoiceManagerError) {
                          return Center(child: Text('Error: ${state.message}'));
                        } else {
                          return Center(child: Text('Err'));
                        }
                      },
                    ),
                  ),
                  SizedBox(height: 8),
                  InvoiceManagerSpacer(height: 4, horizontalPadding: 0),

                  // EntityTypeAheadField(
                  //   invoiceType: widget.invoiceType,
                  // ),
                  // Add separation space
                  // InvoiceManagerSpacer(),
                  // Build invoice items list
                  // BlocBuilder<InvoiceManagerCubit, InvoiceManagerCubitState>(
                  //   builder: (context, state) {
                  //     if (state is InvoiceManagerLoaded) {
                  //       return InvoiceItemsListWidget.searchBoxLayout();
                  //     } else if (state is InvoiceManagerLoading) {
                  //       return Center(child: CircularProgressIndicator());
                  //     } else if (state is InvoiceManagerError) {
                  //       return Center(child: Text('Error: ${state.message}'));
                  //     } else {
                  //       return Center(child: Text('Unknown state'));
                  //     }
                  //   },
                  // ),

                  InvoiceManagerSpacer(),

                  // Manage discount, taxes and gross total
                  // BlocBuilder<InvoiceManagerCubit, InvoiceManagerCubitState>(
                  //   builder: (context, state) {
                  //     if (state is InvoiceManagerLoaded) {
                  //       return AmountSummaryWidget();
                  //     } else if (state is InvoiceManagerLoading) {
                  //       return Center(child: CircularProgressIndicator());
                  //     } else if (state is InvoiceManagerError) {
                  //       return Center(child: Text('Error: ${state.message}'));
                  //     } else {
                  //       return Center(child: Text('Unknown state'));
                  //     }
                  //   },
                  // ),

                  // InvoiceManagerSpacer(height: 0),

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
                ],
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Expanded(
                flex: 5,
                child: Container(
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.zero,
                      ),
                    ),
                    onPressed: () async {
                      String formattedDetails = context
                          .read<InvoiceManagerCubit>()
                          .formatInvoiceDetails();
                      await Share.share(formattedDetails);
                    },
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.share_outlined),
                        SizedBox(width: 4),
                        Text('SHARE'),
                      ],
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 5,
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.zero,
                    ),
                  ),
                  onPressed: () async {
                    if (widget.invoiceFormMode == InvoiceFormMode.Edit) {
                      await context
                          .read<InvoiceManagerCubit>()
                          .updateInvoice()
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
                    } else {
                      await context
                          .read<InvoiceManagerCubit>()
                          .saveInvoice()
                          .then(
                        (value) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Invoice created successfully!'),
                            ),
                          );
                          Navigator.pop(context);
                        },
                      );
                    }
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.save_outlined),
                      SizedBox(width: 4),
                      Text('SAVE'),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
