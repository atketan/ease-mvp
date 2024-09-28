import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/invoice_manager_cubit.dart';
import 'discount_manager_widget.dart';

class AmountSummaryWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return AmountSummaryWidgetState();
  }
}

class AmountSummaryWidgetState extends State<AmountSummaryWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text('SUMMARY', style: Theme.of(context).textTheme.labelLarge),
          ),
          Card(
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Text(
                          'Sub Total',
                          style: Theme.of(context).textTheme.labelLarge,
                        ),
                      ),
                      Flexible(
                        child: Text(
                          "₹" +
                              context
                                  .read<InvoiceManagerCubit>()
                                  .invoice
                                  .totalAmount
                                  .toString(),
                          style: Theme.of(context).textTheme.labelLarge,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: InkWell(
                          onTap: () async {
                            final discount = await showModalBottomSheet<double>(
                              context: context,
                              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                              isScrollControlled: true,
                              builder: (BuildContext context) {
                                return DiscountManagerWidget();
                              },
                            );
            
                            if (discount != null) {
                              context.read<InvoiceManagerCubit>().setDiscount(discount);
                            }
                          },
                          child: Text(
                            'Discount',
                            style: Theme.of(context).textTheme.labelLarge!.copyWith(
                                  color: Colors.blue[600],
                                  decoration: TextDecoration.underline,
                                  decorationColor: Colors.blue,
                                ),
                          ),
                        ),
                      ),
                      Flexible(
                        child: Text(
                          "₹" +
                              context
                                  .read<InvoiceManagerCubit>()
                                  .invoice
                                  .discount
                                  .toString(),
                          style: Theme.of(context).textTheme.labelLarge,
                        ),
                      )
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Text(
                          'Total Payable',
                          style: Theme.of(context)
                              .textTheme
                              .labelLarge!
                              .copyWith(fontWeight: FontWeight.bold),
                        ),
                      ),
                      Flexible(
                        child: Text(
                          "₹" +
                              context
                                  .read<InvoiceManagerCubit>()
                                  .invoice
                                  .grandTotal
                                  .toString(),
                          style: Theme.of(context).textTheme.labelLarge!.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Colors.red,
                              ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
