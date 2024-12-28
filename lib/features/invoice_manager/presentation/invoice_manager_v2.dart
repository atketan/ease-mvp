import 'package:ease/core/enums/invoice_type_enum.dart';
import 'package:ease/core/models/invoice.dart';
import 'package:ease/core/providers/short_uuid_generator.dart';
import 'package:ease/core/utils/developer_log.dart';
import 'package:ease/features/invoice_manager/widgets/discount_manager_widget.dart';
import 'package:ease/features/invoice_manager/widgets/entity_type_ahead_field.dart';
import 'package:ease/features/invoice_manager/widgets/invoice_items_list_widget.dart';
import 'package:ease/features/invoice_manager/widgets/invoice_notes_widget.dart';
import 'package:ease/features/invoice_manager/widgets/invoice_order_details_widget.dart';
import 'package:ease/features/invoice_manager/widgets/payment_details_widget.dart';
import 'package:ease/features/invoice_manager/widgets/payments_manager_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:share_plus/share_plus.dart';

import '../bloc/invoice_manager_cubit.dart';
import '../bloc/invoice_manager_cubit_state.dart';
import '../widgets/invoice_manager_spacer.dart';

enum InvoiceFormMode {
  Add,
  Edit,
}

class InvoiceManagerV2 extends StatefulWidget {
  final InvoiceFormMode invoiceFormMode;
  final Invoice? invoice;
  InvoiceManagerV2({
    Key? key,
    required this.invoiceFormMode,
    this.invoice,
  }) : super(key: key) {
    assert(invoiceFormMode != InvoiceFormMode.Edit || invoice != null,
        'Invoice cannot be null in Edit mode');
  }

  @override
  InvoiceManagerV2State createState() => InvoiceManagerV2State();
}

class InvoiceManagerV2State extends State<InvoiceManagerV2> {
  final String invoiceNumber = generateShort12CharUniqueKey().toUpperCase();
  late InvoiceType invoiceType;
  // final DateTime invoiceCreateDate = DateTime.now();

  List<bool> _isOpen = [false, false, false, false, false];

  @override
  void initState() {
    super.initState();
    invoiceType = context.read<InvoiceManagerCubit>().invoiceType;
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
              '${widget.invoiceFormMode == InvoiceFormMode.Add ? 'NEW' : 'UPDATE'} | ${invoiceType == InvoiceType.Sales ? 'SALE' : 'PURCHASE'}',
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
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16.0,
                      vertical: 8.0,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          flex: 3,
                          child: Row(
                            children: [
                              Icon(
                                Icons.person_2_outlined,
                              ),
                              Text(
                                invoiceType == InvoiceType.Sales
                                    ? 'CUSTOMER'
                                    : 'VENDOR',
                                style: Theme.of(context).textTheme.labelLarge,
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: 16.0),
                        Expanded(
                          flex: 7,
                          child: EntityTypeAheadField(
                            invoiceType: invoiceType,
                            onClientSelected: (clientName) {
                              context
                                  .read<InvoiceManagerCubit>()
                                  .setEntityName(clientName);
                              // selectedClientName = clientName;
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  InvoiceManagerSpacer(height: 0),
                  ExpansionPanelList(
                    expandIconColor: Theme.of(context).primaryColorDark,
                    materialGapSize: 2,
                    expandedHeaderPadding: EdgeInsets.symmetric(vertical: 0),
                    dividerColor: Theme.of(context).primaryColorLight,
                    children: [
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
                                  debugLog(
                                      'Discount builder, cubit state: $state',
                                      name: 'InvoiceManager');
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
                        isExpanded: _isOpen[4],
                        headerBuilder: (context, isExpanded) {
                          return Container(
                            color: isExpanded
                                ? Theme.of(context).secondaryHeaderColor
                                : Colors.transparent,
                            child: ListTile(
                              leading: Icon(Icons.payment_outlined),
                              title: Text(
                                'PAYMENTS',
                                style: Theme.of(context).textTheme.labelLarge,
                              ),
                            ),
                          );
                        },
                        body: BlocBuilder<InvoiceManagerCubit,
                            InvoiceManagerCubitState>(
                          builder: (context, state) {
                            if (state is InvoiceManagerLoaded) {
                              return PaymentsManagerWidget();
                            } else if (state is InvoiceManagerLoading) {
                              return Center(child: CircularProgressIndicator());
                            } else if (state is InvoiceManagerError) {
                              return Center(
                                  child: Text('Error: ${state.message}'));
                            } else {
                              return Center(child: Text('Unknown state'));
                            }
                          },
                        ),
                      ),
                    ],
                    expansionCallback: (panelIndex, isExpanded) => setState(() {
                      _isOpen[panelIndex] = isExpanded;
                    }),
                  ),
                  InvoiceManagerSpacer(),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16.0,
                      vertical: 8.0,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          flex: 3,
                          child: Row(
                            children: [
                              Icon(Icons.notes_outlined),
                              Text(
                                'NOTES',
                                style: Theme.of(context).textTheme.labelLarge,
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: 16.0),
                        Expanded(
                          flex: 7,
                          child: InvoiceNotesWidget(
                            initialNotes: context
                                    .read<InvoiceManagerCubit>()
                                    .invoice
                                    .notes ??
                                "",
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Payment details
                  // BlocBuilder<InvoiceManagerCubit, InvoiceManagerCubitState>(
                  //   builder: (context, state) {
                  //     if (state is InvoiceManagerLoaded) {
                  //       return PaymentDetailsWidget();
                  //     } else if (state is InvoiceManagerLoading) {
                  //       return Center(child: CircularProgressIndicator());
                  //     } else if (state is InvoiceManagerError) {
                  //       return Center(child: Text('Error: ${state.message}'));
                  //     } else {
                  //       return Center(child: Text('Unknown state'));
                  //     }
                  //   },
                  // ),
                ],
              ),
            ),
          ),
          Column(
            children: [
              ListTile(
                tileColor: Theme.of(context).primaryColorLight,
                leading: Icon(Icons.account_balance_outlined),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.zero, // Remove circular edges
                ),
                title: Text(
                  "TOTAL BALANCE",
                  style: Theme.of(context).textTheme.labelLarge,
                ),
                trailing:
                    BlocBuilder<InvoiceManagerCubit, InvoiceManagerCubitState>(
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
                                  content:
                                      Text('Invoice updated successfully!'),
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
                                  content:
                                      Text('Invoice created successfully!'),
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
        ],
      ),
    );
  }
}
