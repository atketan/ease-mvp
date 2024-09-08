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
    debugPrint('TEST: AmountSummaryWidget build');
    debugPrint(
        'TEST: AmountSummaryWidget state: ${context.read<InvoiceManagerCubit>().invoice.totalAmount.toString()},${context.read<InvoiceManagerCubit>().invoice.discount.toString()},${context.read<InvoiceManagerCubit>().invoice.grandTotal.toString()}');

    return Container(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Text(
                  'Gross Total',
                  style: Theme.of(context).textTheme.titleSmall,
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
                  style: Theme.of(context).textTheme.titleSmall,
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
                    style: Theme.of(context).textTheme.titleSmall!.copyWith(
                          color: Colors.blue,
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
                  style: Theme.of(context).textTheme.titleSmall,
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
                      .titleMedium!
                      .copyWith(fontWeight: FontWeight.w900),
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
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                        fontWeight: FontWeight.w900,
                        color: Colors.red,
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
