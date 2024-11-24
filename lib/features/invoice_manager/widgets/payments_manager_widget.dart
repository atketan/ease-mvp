import 'package:ease/core/enums/payment_method_enum.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:ease/core/models/payment.dart';
import 'package:ease/core/enums/transaction_type_enum.dart';

import '../bloc/invoice_manager_cubit.dart';
import '../bloc/invoice_manager_cubit_state.dart';

class PaymentsManagerWidget extends StatefulWidget {
  @override
  State<PaymentsManagerWidget> createState() => _PaymentsManagerWidgetState();
}

class _PaymentsManagerWidgetState extends State<PaymentsManagerWidget> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<InvoiceManagerCubit>().getPaymentsByInvoiceId();
    });
  }

  @override
  Widget build(BuildContext context) {
    final invoiceManagerCubit = context.read<InvoiceManagerCubit>();

    return BlocBuilder<InvoiceManagerCubit, InvoiceManagerCubitState>(
      bloc: invoiceManagerCubit,
      builder: (context, state) {
        if (state is InvoiceManagerPaymentsLoading) {
          return Center(child: CircularProgressIndicator());
        } else if (state is InvoiceManagerPaymentsLoaded) {
          final payments = state.payments.toList();
          final totalPaid =
              payments.fold(0.0, (sum, payment) => sum + payment.amount);

          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: payments.length,
                  itemBuilder: (context, index) {
                    final payment = payments[index];
                    return ListTile(
                      title:
                          Text('${payment.amount}, ${payment.paymentMethod}'),
                      subtitle: Text(payment.paymentDate.toString()),
                      trailing: Text(
                          payment.transactionType.toString().split('.').last),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => AddPaymentForm(
                        invoiceId: context
                            .read<InvoiceManagerCubit>()
                            .invoice
                            .invoiceId!,
                        totalAmountPayable: context
                            .read<InvoiceManagerCubit>()
                            .invoice
                            .grandTotal,
                        totalPaid: totalPaid,
                      ),
                    );
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

class AddPaymentForm extends StatefulWidget {
  final String invoiceId;
  final double totalAmountPayable;
  final double totalPaid;

  AddPaymentForm(
      {required this.invoiceId,
      required this.totalAmountPayable,
      required this.totalPaid});

  @override
  _AddPaymentFormState createState() => _AddPaymentFormState();
}

class _AddPaymentFormState extends State<AddPaymentForm> {
  final _formKey = GlobalKey<FormState>();
  double _amount = 0.0;

  PaymentMethod _selectedPaymentMethod = PaymentMethod.cash;
  TransactionType _transactionType = TransactionType.credit;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Add Payment'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              decoration: InputDecoration(labelText: 'Amount'),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter an amount';
                }
                final amount = double.tryParse(value);
                if (amount == null || amount <= 0) {
                  return 'Please enter a valid amount';
                }
                if (widget.totalPaid + amount > widget.totalAmountPayable) {
                  return 'Total paid amount cannot exceed total payable amount';
                }
                return null;
              },
              onSaved: (value) {
                _amount = double.parse(value!);
              },
            ),
            Wrap(
              spacing: 8.0,
              children: PaymentMethod.values.map((method) {
                return ChoiceChip(
                  label: Text(method.name),
                  selected: _selectedPaymentMethod == method,
                  onSelected: (selected) {
                    setState(() {
                      _selectedPaymentMethod =
                          selected ? method : _selectedPaymentMethod;
                    });
                  },
                  selectedColor: Colors.blue,
                  avatar: _selectedPaymentMethod == method
                      ? Icon(Icons.check, color: Colors.white)
                      : null,
                );
              }).toList(),
            ),
            DropdownButtonFormField<TransactionType>(
              decoration: InputDecoration(labelText: 'Transaction Type'),
              value: _transactionType,
              items: TransactionType.values.map((type) {
                return DropdownMenuItem(
                  value: type,
                  child: Text(type.toString().split('.').last),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _transactionType = value!;
                });
              },
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              _formKey.currentState!.save();
              final newPayment = Payment(
                invoiceId: widget.invoiceId,
                amount: _amount,
                paymentDate: DateTime.now(),
                paymentMethod: _selectedPaymentMethod,
                transactionType: _transactionType,
                createdAt: DateTime.now(),
                updatedAt: DateTime.now(),
              );
              context.read<InvoiceManagerCubit>().addPayment(newPayment);
              Navigator.of(context).pop();
            }
          },
          child: Text('Save'),
        ),
      ],
    );
  }
}
