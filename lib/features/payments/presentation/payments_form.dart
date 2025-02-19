import 'package:ease/core/enums/transaction_category_enum.dart';
import 'package:ease/core/models/ledger_entry.dart';
import 'package:ease/core/providers/short_uuid_generator.dart';
import 'package:ease/features/invoice_manager/widgets/invoice_manager_spacer.dart';
import 'package:ease/features/invoice_manager_v2/bloc/invoice_manager_v2_cubit.dart';
import 'package:ease/features/invoice_manager_v2/bloc/invoice_manager_v2_cubit_state.dart';
import 'package:ease/features/invoice_manager_v2/widgets/all_amounts_input_widget.dart';
import 'package:ease/features/invoice_manager_v2/widgets/entity_type_ahead_field_widget.dart';
import 'package:ease/features/invoice_manager_v2/widgets/invoice_order_details_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:share_plus/share_plus.dart';

enum PaymentsFormMode { Add, Edit }

class PaymentsForm extends StatefulWidget {
  final PaymentsFormMode paymentsFormMode;
  final LedgerEntry? ledgerEntry;

  PaymentsForm({
    Key? key,
    required this.paymentsFormMode,
    this.ledgerEntry,
  }) : super(key: key) {
    assert(paymentsFormMode != PaymentsFormMode.Edit || ledgerEntry != null,
        'Invoice cannot be null in Edit mode');
  }

  @override
  PaymentsFormState createState() => PaymentsFormState();
}

class PaymentsFormState extends State<PaymentsForm> {
  final String invoiceNumber = generateShort12CharUniqueKey().toUpperCase();
  late TransactionCategory transactionCategory;

  void initState() {
    super.initState();
    transactionCategory =
        context.read<InvoiceManagerCubit>().transactionCategory;
    context
        .read<InvoiceManagerCubit>()
        .initialiseInvoiceModelInstance(widget.ledgerEntry, invoiceNumber);
    if (widget.paymentsFormMode == PaymentsFormMode.Edit) {
      // Set the invoice number to the invoice number of the ledger entry
      // invoiceNumber = widget.ledgerEntry!.invoiceNumber;
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
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
              '${widget.paymentsFormMode == PaymentsFormMode.Add ? 'NEW' : 'UPDATE'} PAYMENT',
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
                children: [
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
                  AllAmountsInputWidget(
                    allAmountsFormMode:
                        widget.paymentsFormMode == PaymentsFormMode.Add
                            ? AllAmountsFormMode.Add
                            : AllAmountsFormMode.Edit,
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
                      return Center(
                        child: SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(),
                        ),
                      );
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
                        final LedgerEntry ledgerEntry = await context
                            .read<InvoiceManagerCubit>()
                            .ledgerEntry;
                        if (ledgerEntry.name!.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Entity name not selected'),
                            ),
                          );
                          return;
                        }

                        if (widget.paymentsFormMode == PaymentsFormMode.Edit) {
                          await context
                              .read<InvoiceManagerCubit>()
                              .updateInvoice()
                              .then(
                            (value) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Payment updated successfully'),
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
                                  content: Text('Payment created successfully'),
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
