import 'package:ease/core/enums/payment_method_enum.dart';
import 'package:ease/core/enums/transaction_type_enum.dart';
import 'package:ease/core/models/payment.dart';
import 'package:ease/core/utils/date_time_utils.dart';
import 'package:ease/core/utils/string_casing_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/invoice_manager_cubit.dart';
import '../bloc/invoice_manager_cubit_state.dart';
import 'payments_add_payment_form.dart';

class PaymentsManagerWidget extends StatefulWidget {
  @override
  State<PaymentsManagerWidget> createState() => _PaymentsManagerWidgetState();
}

class _PaymentsManagerWidgetState extends State<PaymentsManagerWidget> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    InvoiceManagerCubit _invoiceManagerCubit =
        context.read<InvoiceManagerCubit>();
    return BlocBuilder<InvoiceManagerCubit, InvoiceManagerCubitState>(
      bloc: _invoiceManagerCubit,
      builder: (context, state) {
        if (state is InvoiceManagerLoading) {
          return Center(child: CircularProgressIndicator());
        } else if (state is InvoiceManagerLoaded) {
          final payments = state.invoice.payments.toList();
          final totalPaid =
              payments.fold(0.0, (sum, payment) => sum + payment.amount);

          return Column(
            children: [
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: payments.length,
                itemBuilder: (context, index) {
                  final payment = payments[index];
                  return ListTile(
                    title: Text(
                      payment.paymentMethod.displayName,
                      style: Theme.of(context).textTheme.labelLarge,
                    ),
                    subtitle: Text(
                      formatInvoiceDate(payment.paymentDate),
                      style: Theme.of(context).textTheme.labelSmall,
                    ),
                    trailing: Text(
                      (payment.transactionType == TransactionType.credit)
                          ? '+' + '₹${payment.amount}'
                          : '-' + '₹${payment.amount}',
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                  );
                },
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => AddPaymentForm(
                        invoiceId: _invoiceManagerCubit.invoice.invoiceId ?? "",
                        totalAmountPayable:
                            _invoiceManagerCubit.invoice.grandTotal,
                        totalPaid: totalPaid,
                      ),
                    ).then((newPayment) {
                      if (newPayment != null) {
                        _invoiceManagerCubit.addPayment(newPayment);
                      }
                    });
                  },
                  child: Text('Add Payment'),
                ),
              ),
            ],
          );
        } else if (state is InvoiceManagerError) {
          return Center(child: Text('Error: ${state.message}'));
        } else {
          return Center(child: Text('Unknown state'));
        }
      },
    );
  }
}
