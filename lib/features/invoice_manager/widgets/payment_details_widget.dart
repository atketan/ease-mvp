import 'package:ease/features/invoice_manager/widgets/invoice_manager_spacer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/invoice_manager_cubit.dart';

class PaymentDetailsWidget extends StatefulWidget {
  @override
  PaymentDetailsWidgetState createState() => PaymentDetailsWidgetState();
}

class PaymentDetailsWidgetState extends State<PaymentDetailsWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8.0),
      child: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Text(
            //   'Payment Details',
            //   style: Theme.of(context).textTheme.titleMedium!.copyWith(
            //         color: Colors.black,
            //         fontWeight: FontWeight.bold,
            //       ),
            // ),
            // SizedBox(height: 8.0),

            PaymentDetailsRowWidget(
                title: 'Total Amount',
                value:
                    '₹${context.read<InvoiceManagerCubit>().invoice.totalAmount}'),
            PaymentDetailsRowWidget(
                title: 'Discount',
                value:
                    '-₹${context.read<InvoiceManagerCubit>().invoice.discount}'),
            PaymentDetailsRowWidget(
                title: 'Grand Total',
                value:
                    '₹${context.read<InvoiceManagerCubit>().invoice.grandTotal}'),
            InvoiceManagerSpacer(),
            PaymentDetailsRowWidget(
                title: 'Total Paid',
                value:
                    '₹${context.read<InvoiceManagerCubit>().invoice.totalPaid}'),
            PaymentDetailsRowWidget(
                title: 'Total Due',
                value:
                    '₹${context.read<InvoiceManagerCubit>().invoice.totalDue}'),

            // Padding(
            //   padding: const EdgeInsets.all(8.0),
            //   child: Row(
            //     crossAxisAlignment: CrossAxisAlignment.center,
            //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //     children: [
            //       Text('PAYMENT STATUS',
            //           style: Theme.of(context).textTheme.labelLarge!),
            //       SizedBox(width: 16.0),
            //       Wrap(
            //         spacing: 8.0,
            //         children: <String>['paid', 'unpaid'].map((String value) {
            //           return ChoiceChip(
            //             label: Text(value),
            //             selected: context
            //                     .read<InvoiceManagerCubit>()
            //                     .invoice
            //                     .status ==
            //                 value,
            //             onSelected: (bool selected) {
            //               if (selected) {
            //                 context
            //                     .read<InvoiceManagerCubit>()
            //                     .updateStatus(value);
            //               }
            //             },
            //           );
            //         }).toList(),
            //       ),
            //     ],
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}

class PaymentDetailsRowWidget extends StatelessWidget {
  final String title;
  final String value;

  PaymentDetailsRowWidget({required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: Theme.of(context).textTheme.labelLarge),
          Text(
            value,
            style: Theme.of(context).textTheme.labelLarge,
          ),
        ],
      ),
    );
  }
}
