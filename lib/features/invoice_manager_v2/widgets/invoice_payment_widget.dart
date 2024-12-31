import 'package:ease/core/enums/invoice_type_enum.dart';
import 'package:ease/core/enums/payment_method_enum.dart';
import 'package:ease/core/utils/developer_log.dart';
// import 'package:ease/core/enums/transaction_type_enum.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/invoice_manager_v2_cubit.dart';
import '../bloc/invoice_manager_v2_cubit_state.dart';

class InvoicePaymentWidget extends StatefulWidget {
  final InvoiceType invoiceType;
  final double totalAmountPayable;
  final double totalPaid;

  const InvoicePaymentWidget({
    super.key,
    required this.invoiceType,
    required this.totalAmountPayable,
    required this.totalPaid,
  });

  @override
  State<StatefulWidget> createState() => InvoicePaymentWidgetState();
}

class InvoicePaymentWidgetState extends State<InvoicePaymentWidget> {
  late PaymentMethod _selectedPaymentMethod;
  TextEditingController _totalPaidTextController = TextEditingController();
  // late TransactionType _transactionType;
  // double _amount = 0.0;

  @override
  void initState() {
    _selectedPaymentMethod = PaymentMethod.cash;
    // _transactionType = (widget.invoiceType == InvoiceType.Sales)
    //     ? TransactionType.credit
    //     : TransactionType.debit;
    super.initState();
  }

  @override
  void dispose() {
    _totalPaidTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: BlocBuilder<InvoiceManagerCubit, InvoiceManagerCubitState>(
          builder: (context, state) {
        debugLog('state: $state', name: 'InvoicePaymentWidget');
        _totalPaidTextController.text =
            context.read<InvoiceManagerCubit>().invoice.totalPaid.toString();
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Expanded(flex: 3, child: Text('Paid Amount:')),
                SizedBox(width: 16.0),
                Expanded(
                  flex: 7,
                  child: TextField(
                    controller: _totalPaidTextController,
                    style: Theme.of(context).textTheme.labelLarge,
                    keyboardType:
                        TextInputType.numberWithOptions(decimal: true),
                    decoration: InputDecoration(prefixText: '₹ '),
                    onSubmitted: (value) {
                      if (value.isEmpty) value = "0";
                      context
                          .read<InvoiceManagerCubit>()
                          .setTotalPaidAmount(double.parse(value));
                    },
                    // onChanged: (value) {
                    //   if (value.isEmpty) value = "0";
                    //   context
                    //       .read<InvoiceManagerCubit>()
                    //       .setTotalPaidAmount(double.parse(value));
                    // },
                  ),
                ),
              ],
            ),
            // TextFormField(
            //   decoration: InputDecoration(labelText: 'Amount'),
            //   keyboardType: TextInputType.number,
            //   validator: (value) {
            //     if (value == null || value.isEmpty) {
            //       return 'Please enter an amount';
            //     }
            //     final amount = double.tryParse(value);
            //     if (amount == null || amount <= 0) {
            //       return 'Please enter a valid amount';
            //     }
            //     if (_transactionType == TransactionType.credit &&
            //         widget.totalPaid + amount > widget.totalAmountPayable) {
            //       debugPrint(
            //           'Total Paid: ${widget.totalPaid}, Amount: $amount, totalPayable: ${widget.totalAmountPayable}');
            //       return 'Amount cannot exceed total payable';
            //     }
            //     if (_transactionType == TransactionType.debit &&
            //         widget.totalAmountPayable - amount < 0.0) {
            //       debugPrint(
            //           'Total Paid: ${widget.totalPaid}, Amount: $amount, totalPayable: ${widget.totalAmountPayable}');
            //       return 'Amount cannot be paid from a negative balance';
            //     }
            //     return null;
            //   },
            //   onSaved: (value) {
            //     _amount = double.parse(value!);
            //   },
            // ),
            SizedBox(height: 8.0),
            Wrap(
              spacing: 4.0,
              alignment: WrapAlignment.start,
              children: PaymentMethod.values.map((method) {
                return ChoiceChip(
                  label: Text(method.displayName),
                  selected: _selectedPaymentMethod == method,
                  onSelected: (selected) {
                    // setState(() {
                    _selectedPaymentMethod =
                        selected ? method : _selectedPaymentMethod;
                    // });
                  },
                  // selectedColor: Colors.blue,
                  avatar: _selectedPaymentMethod == method
                      ? Icon(Icons.check)
                      : null,
                );
              }).toList(),
            ),
            // SizedBox(height: 12.0),
            // DropdownButtonFormField<TransactionType>(
            //   decoration: InputDecoration(labelText: 'Transaction Type'),
            //   value: _transactionType,
            //   items: TransactionType.values.map((type) {
            //     return DropdownMenuItem(
            //       value: type,
            //       child: Text(type.toString().split('.').last.toTitleCase),
            //     );
            //   }).toList(),
            //   onChanged: (value) {
            //     setState(() {
            //       _transactionType = value!;
            //     });
            //   },
            // ),
          ],
        );
      }),
    );
  }
}
