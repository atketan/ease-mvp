import 'package:ease/core/enums/invoice_type_enum.dart';
import 'package:ease/core/enums/payment_against_enum.dart';
import 'package:ease/core/enums/payment_method_enum.dart';
import 'package:ease/core/enums/transaction_type_enum.dart';
import 'package:ease/core/models/payment.dart';
import 'package:ease/core/utils/string_casing_extension.dart';
import 'package:flutter/material.dart';

class AddPaymentForm extends StatefulWidget {
  final String invoiceId;
  final double totalAmountPayable;
  final double totalPaid;
  final InvoiceType invoiceType;

  AddPaymentForm({
    required this.invoiceId,
    required this.totalAmountPayable,
    required this.totalPaid,
    this.invoiceType = InvoiceType.Sales,
  });

  @override
  _AddPaymentFormState createState() => _AddPaymentFormState();
}

class _AddPaymentFormState extends State<AddPaymentForm> {
  final _formKey = GlobalKey<FormState>();
  double _amount = 0.0;

  PaymentMethod _selectedPaymentMethod = PaymentMethod.cash;
  late TransactionType _transactionType;

  @override
  void initState() {
    _transactionType = (widget.invoiceType == InvoiceType.Sales)
        ? TransactionType.credit
        : TransactionType.debit;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Add Payment'),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
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
                  if (_transactionType == TransactionType.credit &&
                      widget.totalPaid + amount > widget.totalAmountPayable) {
                    debugPrint(
                        'Total Paid: ${widget.totalPaid}, Amount: $amount, totalPayable: ${widget.totalAmountPayable}');
                    return 'Amount cannot exceed total payable';
                  }
                  if (_transactionType == TransactionType.debit &&
                      widget.totalPaid - amount < 0.0) {
                    return 'Amount cannot be paid from a negative balance';
                  }
                  return null;
                },
                onSaved: (value) {
                  _amount = double.parse(value!);
                },
              ),
              SizedBox(height: 8.0),
              Wrap(
                spacing: 4.0,
                alignment: WrapAlignment.start,
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
                    // selectedColor: Colors.blue,
                    avatar: _selectedPaymentMethod == method
                        ? Icon(Icons.check)
                        : null,
                  );
                }).toList(),
              ),
              SizedBox(height: 12.0),
              DropdownButtonFormField<TransactionType>(
                decoration: InputDecoration(labelText: 'Transaction Type'),
                value: _transactionType,
                items: TransactionType.values.map((type) {
                  return DropdownMenuItem(
                    value: type,
                    child: Text(type.toString().split('.').last.toTitleCase),
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
      ),
      actions: [
        TextButton(
          style: TextButton.styleFrom(
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              _formKey.currentState!.save();
              final newPayment = Payment(
                invoiceId: widget.invoiceId,
                amount: _amount,
                paymentDate: DateTime.now(),
                paymentMethod: _selectedPaymentMethod,
                transactionType: _transactionType,
                paymentAgainst: (widget.invoiceType == InvoiceType.Sales)
                    ? PaymentAgainst.salesInvoice
                    : PaymentAgainst.purchaseInvoice,
                createdAt: DateTime.now(),
                updatedAt: DateTime.now(),
              );
              // context.read<InvoiceManagerCubit>().addPayment(newPayment);
              Navigator.of(context).pop(newPayment);
            }
          },
          child: Text('Save'),
        ),
      ],
    );
  }
}
