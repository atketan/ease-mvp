import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/invoice_manager_v2_cubit.dart';

class AllAmountsInputWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => AllAmountsInputWidgetState();
}

class AllAmountsInputWidgetState extends State<AllAmountsInputWidget> {
  final TextEditingController _totalAmountTextController =
      TextEditingController();
  final TextEditingController _discountTextController = TextEditingController();
  final TextEditingController _grandTotalTextController =
      TextEditingController();

  @override
  void dispose() {
    _totalAmountTextController.dispose();
    _discountTextController.dispose();
    _grandTotalTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _grandTotalTextController.text =
        context.read<InvoiceManagerCubit>().invoice.grandTotal.toString();
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: Column(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    flex: 3,
                    child: Text(
                      'Total Amount:',
                      style: Theme.of(context).textTheme.labelLarge,
                    ),
                  ),
                  SizedBox(width: 16.0),
                  Expanded(
                    flex: 7,
                    child: TextField(
                      controller: _totalAmountTextController,
                      style: Theme.of(context).textTheme.labelLarge,
                      keyboardType:
                          TextInputType.numberWithOptions(decimal: true),
                      decoration: InputDecoration(
                        prefixText: '₹',
                      ),
                      onChanged: (value) {
                        if (value.isEmpty) value = "0";
                        context
                            .read<InvoiceManagerCubit>()
                            .invoice
                            .totalAmount = double.parse(value);
                      },
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    flex: 3,
                    child: Text(
                      'Discount:',
                      style: Theme.of(context).textTheme.labelLarge,
                    ),
                  ),
                  SizedBox(width: 16.0),
                  Expanded(
                    flex: 7,
                    child: TextField(
                      controller: _discountTextController,
                      style: Theme.of(context).textTheme.labelLarge,
                      keyboardType:
                          TextInputType.numberWithOptions(decimal: true),
                      decoration: InputDecoration(
                        prefixText: '₹',
                      ),
                      onChanged: (value) {
                        if (value.isEmpty) value = "0";
                        context
                            .read<InvoiceManagerCubit>()
                            .setDiscount(double.parse(value));
                      },
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    flex: 3,
                    child: Text(
                      'Grand Total:',
                      style: Theme.of(context).textTheme.labelLarge,
                    ),
                  ),
                  SizedBox(width: 16.0),
                  Expanded(
                    flex: 7,
                    child: TextField(
                      controller: _grandTotalTextController,
                      style: Theme.of(context).textTheme.labelLarge,
                      enabled: false,
                      keyboardType:
                          TextInputType.numberWithOptions(decimal: true),
                      decoration: InputDecoration(
                        prefixText: '₹',
                      ),
                      onChanged: (value) {
                        if (value.isEmpty) value = "0";
                        context
                            .read<InvoiceManagerCubit>()
                            .invoice
                            .totalAmount = double.parse(value);
                      },
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
