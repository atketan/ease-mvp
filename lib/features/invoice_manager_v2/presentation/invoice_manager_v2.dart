import 'package:ease/core/enums/transaction_category_enum.dart';
// import 'package:ease/core/models/invoice.dart';
import 'package:ease/core/models/ledger_entry.dart';
import 'package:ease/core/providers/short_uuid_generator.dart';
// import 'package:ease/features/invoice_manager_v2/widgets/invoice_payment_widget.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:share_plus/share_plus.dart';

import '../../invoice_manager/widgets/invoice_manager_spacer.dart';
import '../bloc/invoice_manager_v2_cubit.dart';
import '../bloc/invoice_manager_v2_cubit_state.dart';
import '../widgets/all_amounts_input_widget.dart';
import '../widgets/entity_type_ahead_field_widget.dart';
import '../widgets/invoice_notes_widget.dart';
import '../widgets/invoice_order_details_widget.dart';
import '../widgets/invoice_upload_widget.dart';

enum InvoiceFormMode {
  Add,
  Edit,
}

class InvoiceManagerV2 extends StatefulWidget {
  final InvoiceFormMode invoiceFormMode;
  // final Invoice? invoice;
  final LedgerEntry? ledgerEntry;
  InvoiceManagerV2({
    Key? key,
    required this.invoiceFormMode,
    // this.invoice,
    this.ledgerEntry,
  }) : super(key: key) {
    assert(invoiceFormMode != InvoiceFormMode.Edit || ledgerEntry != null,
        'Invoice cannot be null in Edit mode');
  }

  @override
  InvoiceManagerV2State createState() => InvoiceManagerV2State();
}

class InvoiceManagerV2State extends State<InvoiceManagerV2> {
  final String invoiceNumber = generateShort12CharUniqueKey().toUpperCase();
  late TransactionCategory transactionCategory;

  @override
  void initState() {
    super.initState();
    transactionCategory =
        context.read<InvoiceManagerCubit>().transactionCategory;
    context
        .read<InvoiceManagerCubit>()
        .initialiseInvoiceModelInstance(widget.ledgerEntry, invoiceNumber);
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
              '${widget.invoiceFormMode == InvoiceFormMode.Add ? 'NEW' : 'UPDATE'} | ${transactionCategory == TransactionCategory.sales ? 'SALE' : 'PURCHASE'}',
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
                              Icon(Icons.person_2_outlined),
                              Text(
                                transactionCategory == TransactionCategory.sales
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
                            transactionCategory: transactionCategory,
                          ),
                        ),
                      ],
                    ),
                  ),
                  InvoiceManagerSpacer(height: 0),
                  InvoiceUploadWidget(),
                  // InvoiceManagerSpacer(height: 0),
                  AllAmountsInputWidget(
                    allAmountsFormMode:
                        widget.invoiceFormMode == InvoiceFormMode.Add
                            ? AllAmountsFormMode.Add
                            : AllAmountsFormMode.Edit,
                  ),
                  InvoiceManagerSpacer(height: 0),
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
                                    .ledgerEntry
                                    .notes ??
                                "",
                          ),
                        ),
                      ],
                    ),
                  ),
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
                                .ledgerEntry
                                .remainingDue
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
                            },
                          );
                        }
                        Navigator.pop(context);
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
