import 'package:ease/core/enums/invoice_type_enum.dart';
import 'package:ease/core/enums/payment_method_enum.dart';
import 'package:ease/core/enums/transaction_type_enum.dart';
import 'package:ease/core/models/expense.dart';
import 'package:ease/core/models/payment.dart';
import 'package:ease/core/providers/short_uuid_generator.dart';
import 'package:ease/core/utils/date_time_utils.dart';
import 'package:ease/features/expense_categories/presentation/widgets/expense_category_form.dart';
import 'package:ease/features/expense_categories/providers/expense_category_provider.dart';
import 'package:ease/features/expenses/providers/expense_provider.dart';
import 'package:ease/features/invoice_manager/widgets/payments_add_payment_form.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ExpenseForm extends StatefulWidget {
  final Expense? expense;

  ExpenseForm({this.expense});

  @override
  _ExpenseFormState createState() => _ExpenseFormState();
}

class _ExpenseFormState extends State<ExpenseForm> {
  final _formKey = GlobalKey<FormState>();
  late String _name;
  String? _notes;
  String? _categoryId;
  double? _amount;
  double totalPaid = 0.0;

  final String expenseNumber = generateShort12CharUniqueKey().toUpperCase();

  @override
  void initState() {
    super.initState();
    if (widget.expense != null) {
      _name = widget.expense!.name ?? '';
      _notes = widget.expense!.notes;
      _categoryId = widget.expense!.categoryId;
      _amount = widget.expense!.amount;
    } else {
      _name = '';
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _populatePaymentsForExpense();
    });
  }

  void _populatePaymentsForExpense() async {
    if (widget.expense != null) {
      final provider = Provider.of<ExpensesProvider>(context, listen: false);
      await provider.getPaymentsForExpense(widget.expense!.expenseId ?? '');
      // setState(() {
      //   totalPaid = payments.fold(0.0, (sum, payment) => sum + payment.amount);
      // });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'EXPENSE: #$expenseNumber',
              style: Theme.of(context)
                  .textTheme
                  .labelLarge!
                  .copyWith(color: Theme.of(context).colorScheme.surface),
            ),
            Text(
              widget.expense == null ? 'Add Expense' : 'Edit Expense',
              style: Theme.of(context)
                  .textTheme
                  .labelMedium!
                  .copyWith(color: Theme.of(context).colorScheme.surface),
            ),
          ],
        ),
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  // const SizedBox(height: 16),
                  // TextFormField(
                  //   initialValue: _name,
                  //   decoration: InputDecoration(labelText: 'Name'),
                  //   validator: (value) {
                  //     if (value == null || value.isEmpty) {
                  //       return 'Please enter a name';
                  //     }
                  //     return null;
                  //   },
                  //   onSaved: (value) {
                  //     _name = value!;
                  //   },
                  // ),
                  // const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: Consumer<ExpenseCategoryProvider>(
                          builder: (context, provider, child) {
                            return DropdownButtonFormField<String>(
                              value: _categoryId,
                              decoration:
                                  InputDecoration(labelText: 'Category*'),
                              items: provider.expenseCategories.map((category) {
                                return DropdownMenuItem<String>(
                                  value: category.categoryId,
                                  child: Text(category.name),
                                );
                              }).toList(),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please select a category';
                                }
                                return null;
                              },
                              onChanged: (value) {
                                setState(() {
                                  _categoryId = value;
                                  _name = provider.expenseCategories
                                      .firstWhere((element) =>
                                          element.categoryId == _categoryId)
                                      .name;
                                });
                              },
                            );
                          },
                        ),
                      ),
                      const SizedBox(width: 8),
                      OutlinedButton(
                        child: Text('+ Add'),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ExpenseCategoryForm(),
                            ),
                          ).then((_) {
                            setState(() {
                              _categoryId = null;
                              _name = '';
                            });
                          });
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    initialValue: _amount?.toString(),
                    decoration:
                        InputDecoration(labelText: 'Amount*', prefixText: '₹ '),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter an amount';
                      }
                      return null;
                    },
                    onChanged: (value) {
                      debugPrint('Amount: $value');
                      _amount = double.parse(value);
                    },
                    onSaved: (value) {
                      setState(() {
                        _amount = double.parse(value!);
                      });
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    initialValue: _notes,
                    decoration: InputDecoration(labelText: 'Notes'),
                    // validator: (value) {
                    //   if (value == null || value.isEmpty) {
                    //     return 'Please add notes to explain the expense';
                    //   }
                    //   return null;
                    // },
                    onSaved: (value) {
                      _notes = value;
                    },
                  ),
                  SizedBox(height: 16),
                  Card(
                    child: Column(
                      children: [
                        ListTile(
                          title: Text('Payments'),
                        ),
                        Consumer<ExpensesProvider>(
                          builder: (context, provider, child) {
                            return FutureBuilder(
                              future: Future.value(provider.payments),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return CircularProgressIndicator();
                                } else if (snapshot.hasError) {
                                  return Text('Error: ${snapshot.error}');
                                } else if (!snapshot.hasData ||
                                    (snapshot.data as List).isEmpty) {
                                  return Text('No payments found');
                                } else {
                                  final List<Payment> payments =
                                      snapshot.data as List<Payment>;
                                  return Column(
                                    children: payments.map((payment) {
                                      totalPaid = totalPaid +
                                          (payment.transactionType ==
                                                  TransactionType.credit
                                              ? payment.amount
                                              : -payment.amount);
                                      return ListTile(
                                        title: Text(
                                          payment.paymentMethod.displayName,
                                          style: Theme.of(context)
                                              .textTheme
                                              .labelLarge,
                                        ),
                                        subtitle: Text(
                                          formatInvoiceDate(
                                              payment.paymentDate),
                                          style: Theme.of(context)
                                              .textTheme
                                              .labelSmall,
                                        ),
                                        trailing: Text(
                                          (payment.transactionType ==
                                                  TransactionType.credit)
                                              ? '+' + '₹${payment.amount}'
                                              : '-' + '₹${payment.amount}',
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleSmall,
                                        ),
                                      );
                                    }).toList(),
                                  );
                                }
                              },
                            );
                          },
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Consumer<ExpensesProvider>(
                              builder: (context, provider, child) {
                            return ElevatedButton(
                              onPressed: () {
                                debugPrint(
                                    'Add Payment, Expense ID: $expenseNumber, Total Paid: $totalPaid, Amount: $_amount');
                                showDialog(
                                  context: context,
                                  builder: (context) => AddPaymentForm(
                                    invoiceId: expenseNumber,
                                    totalAmountPayable: _amount ?? 0.0,
                                    totalPaid: totalPaid,
                                    invoiceType: InvoiceType.Expense,
                                  ),
                                ).then((newPayment) {
                                  if (newPayment != null) {
                                    newPayment.invoiceId = expenseNumber;
                                    provider.addPaymentToArray(newPayment);
                                  }
                                });
                              },
                              child: Text('Add Payment'),
                            );
                          }),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),
                ],
              ),
            ),
            Spacer(),
            Align(
              alignment: Alignment.bottomCenter,
              child: Row(
                children: [
                  Expanded(
                    flex: 5,
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.zero,
                        ),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text('Cancel'),
                    ),
                  ),
                  Expanded(
                    flex: 5,
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.zero,
                        ),
                      ),
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          _formKey.currentState!.save();
                          final provider = Provider.of<ExpensesProvider>(
                              context,
                              listen: false);
                          if (widget.expense == null) {
                            provider.insertExpense(
                              Expense(
                                expenseNumber: expenseNumber,
                                name: _name,
                                notes: _notes,
                                categoryId: _categoryId,
                                amount: _amount!,
                                totalPaid: totalPaid,
                                status: (_amount == totalPaid)
                                    ? 'paid'
                                    : (_amount! > totalPaid)
                                        ? 'partially paid'
                                        : 'unpaid',
                                createdAt: DateTime.now(),
                                updatedAt: DateTime.now(),
                              ),
                            );
                          } else {
                            provider.updateExpense(
                              Expense(
                                id: widget.expense!.id,
                                expenseId: widget.expense!.expenseId,
                                expenseNumber: widget.expense!.expenseNumber,
                                name: _name,
                                notes: _notes,
                                categoryId: _categoryId,
                                amount: _amount!,
                                totalPaid: totalPaid,
                                status: (_amount == totalPaid)
                                    ? 'paid'
                                    : (_amount! > totalPaid)
                                        ? 'partially paid'
                                        : 'unpaid',
                                createdAt: widget.expense!.createdAt,
                                updatedAt: DateTime.now(),
                              ),
                            );
                          }
                          Navigator.pop(context);
                        }
                      },
                      child: Text(widget.expense == null ? 'Save' : 'Update'),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
