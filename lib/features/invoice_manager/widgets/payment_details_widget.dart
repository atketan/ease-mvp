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
      child: Container( // previous Card
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

            // ----------------------------------------- //

            // Removing Payment Type for now, since when an invoice is paid, we can simply say it was a cash transaction, and when an invoice is unpaid, its a credit transaction.
            // This will make more sense to have as an input when there are multiple payment types available to choose from.
            // For now, we will keep it simple and just show the status of the invoice.
            // Row(
            //   crossAxisAlignment: CrossAxisAlignment.center,
            //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //   children: [
            //     Text(
            //       'Payment Type',
            //       style: Theme.of(context)
            //           .textTheme
            //           .titleSmall!
            //           .copyWith(fontWeight: FontWeight.bold),
            //     ),
            //     SizedBox(width: 16.0),
            //     Wrap(
            //       spacing: 8.0,
            //       children: <String>['cash', 'credit'].map((String value) {
            //         return ChoiceChip(
            //           label: Text(value),
            //           selected: context
            //                   .read<InvoiceManagerCubit>()
            //                   .invoice
            //                   .paymentType ==
            //               value,
            //           onSelected: (bool selected) {
            //             if (selected) {
            //               context
            //                   .read<InvoiceManagerCubit>()
            //                   .updatePaymentType(value);
            //             }
            //           },
            //         );
            //       }).toList(),
            //     ),
            //     // DropdownButtonFormField<String>(
            //     //   value: context.read<InvoiceManagerCubit>().invoice.paymentType,
            //     //   onChanged: (String? value) {
            //     //     context.read<InvoiceManagerCubit>().updatePaymentType(value!);
            //     //   },
            //     //   items: <String>['cash', 'credit']
            //     //       .map<DropdownMenuItem<String>>((String value) {
            //     //     return DropdownMenuItem<String>(
            //     //       value: value,
            //     //       child: Text(value),
            //     //     );
            //     //   }).toList(),
            //     // ),
            //   ],
            // ),

            // ----------------------------------------- //

            // SizedBox(height: 8.0),

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('PAYMENT STATUS',
                      style: Theme.of(context).textTheme.labelLarge!),
                  SizedBox(width: 16.0),
                  Wrap(
                    spacing: 8.0,
                    children: <String>['paid', 'unpaid'].map((String value) {
                      return ChoiceChip(
                        label: Text(value),
                        selected: context
                                .read<InvoiceManagerCubit>()
                                .invoice
                                .status ==
                            value,
                        onSelected: (bool selected) {
                          if (selected) {
                            context
                                .read<InvoiceManagerCubit>()
                                .updateStatus(value);
                          }
                        },
                      );
                    }).toList(),
                  ),
                  // DropdownButtonFormField<String>(
                  //   value: context.read<InvoiceManagerCubit>().invoice.status,
                  //   onChanged: (String? value) {
                  //     context.read<InvoiceManagerCubit>().updateStatus(value!);
                  //   },
                  //   items: <String>['paid', 'unpaid']
                  //       .map<DropdownMenuItem<String>>((String value) {
                  //     return DropdownMenuItem<String>(
                  //       value: value,
                  //       child: Text(value),
                  //     );
                  //   }).toList(),
                  // ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
