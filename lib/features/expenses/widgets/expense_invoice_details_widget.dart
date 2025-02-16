import 'package:ease/core/utils/date_time_utils.dart';
import 'package:ease/features/expenses/bloc/expense_manager_cubit.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ExpenseInvoiceDetailsWidget extends StatefulWidget {
  ExpenseInvoiceDetailsWidget({
    Key? key,
  }) : super(key: key);

  @override
  State<ExpenseInvoiceDetailsWidget> createState() =>
      _ExpenseInvoiceDetailsWidgetState();
}

class _ExpenseInvoiceDetailsWidgetState
    extends State<ExpenseInvoiceDetailsWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Text(
        //   'EXPENSE DETAILS',
        //   style: Theme.of(context).textTheme.labelLarge,
        // ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Expense Number',
                  style: Theme.of(context)
                      .textTheme
                      .titleSmall!
                      .copyWith(fontWeight: FontWeight.bold),
                ),
                Text(
                  "#" +
                      (context
                              .read<ExpenseManagerCubit>()
                              .ledgerEntry
                              .invNumber ??
                          ''),
                  style: Theme.of(context).textTheme.titleSmall,
                ),
              ],
            ),
            SizedBox(height: 8.0),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Expense Date',
                  style: Theme.of(context)
                      .textTheme
                      .titleSmall!
                      .copyWith(fontWeight: FontWeight.bold),
                ),
                InkWell(
                  onTap: () {
                    showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2100),
                    ).then((value) {
                      if (value != null) {
                        context
                            .read<ExpenseManagerCubit>()
                            .setTransactionDate(value);
                        setState(() {});
                      }
                    });
                  },
                  child: Text(
                    formatInvoiceDateWithoutTime(
                      context
                          .read<ExpenseManagerCubit>()
                          .ledgerEntry
                          .transactionDate,
                    ),
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          color: Theme.of(context).primaryColor,
                          decoration: TextDecoration.underline,
                        ),
                  ),
                )
              ],
            ),
          ],
        ),
        const SizedBox(height: 8.0),
      ],
    );
  }
}
