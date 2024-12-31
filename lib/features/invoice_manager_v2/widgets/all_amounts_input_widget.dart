import 'package:ease/core/enums/payment_method_enum.dart';
import 'package:ease/core/utils/developer_log.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/invoice_manager_v2_cubit.dart';
import '../bloc/invoice_manager_v2_cubit_state.dart';

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
  TextEditingController _totalPaidTextController = TextEditingController();

  PaymentMethod _selectedPaymentMethod = PaymentMethod.cash;

  @override
  void dispose() {
    _totalAmountTextController.dispose();
    _discountTextController.dispose();
    _grandTotalTextController.dispose();
    _totalPaidTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: BlocBuilder<InvoiceManagerCubit, InvoiceManagerCubitState>(
        builder: (context, state) {
          if (state is InvoiceManagerLoaded) {
            debugLog(
                'State: $state, Invoice: ${state.invoice.toJSON().toString()}',
                name: 'AllAmountsInputWidget');
          }
          _grandTotalTextController.text =
              context.read<InvoiceManagerCubit>().invoice.grandTotal.toString();

          return Column(
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
                        prefixText: '₹ ',
                      ),
                      onChanged: (value) {
                        if (value.isEmpty) value = "0";
                        context
                            .read<InvoiceManagerCubit>()
                            .setTotalAmount(double.parse(value));
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
                        prefixText: '₹ ',
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
                        prefixText: '₹ ',
                        border: InputBorder.none, // Remove border
                        filled: true,
                        fillColor:
                            Colors.transparent, // Remove background color
                      ),
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
                      'Total Paid:',
                      style: Theme.of(context).textTheme.labelLarge,
                    ),
                  ),
                  SizedBox(width: 16.0),
                  Expanded(
                    flex: 7,
                    child: TextField(
                      controller: _totalPaidTextController,
                      style: Theme.of(context).textTheme.labelLarge,
                      keyboardType:
                          TextInputType.numberWithOptions(decimal: true),
                      decoration: InputDecoration(
                        prefixText: '₹ ',
                      ),
                      onChanged: (value) {
                        if (value.isEmpty) value = "0";
                        context
                            .read<InvoiceManagerCubit>()
                            .setTotalPaidAmount(double.parse(value));
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8.0),
              Wrap(
                spacing: 4.0,
                alignment: WrapAlignment.start,
                children: PaymentMethod.values.map((method) {
                  return ChoiceChip(
                    label: Text(method.displayName),
                    selected: _selectedPaymentMethod == method,
                    onSelected: (selected) {
                      setState(() {
                        _selectedPaymentMethod =
                            selected ? method : _selectedPaymentMethod;
                      });
                    },
                    // selectedColor: Colors.blue,
                    avatar: _selectedPaymentMethod == method
                        ? Icon(Icons.check)
                        : null,
                  );
                }).toList(),
              ),
            ],
          );
        },
      ),
    );
  }
}
