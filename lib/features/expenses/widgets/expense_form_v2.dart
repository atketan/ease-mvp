import 'package:ease/core/enums/ledger_enum_type.dart';
import 'package:ease/core/models/ledger_entry.dart';
import 'package:ease/core/providers/short_uuid_generator.dart';
import 'package:ease/features/expenses/bloc/expense_cubit_manager_state.dart';
import 'package:ease/features/expenses/bloc/expense_manager_cubit.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ExpenseFormV2 extends StatefulWidget {
  final LedgerEntry? ledgerEntry;

  ExpenseFormV2({this.ledgerEntry});

  @override
  _ExpenseFormV2State createState() => _ExpenseFormV2State();
}

class _ExpenseFormV2State extends State<ExpenseFormV2> {
  final _formKey = GlobalKey<FormState>();
  late String _name;
  String? _notes;
  double? _amount;

  final String expenseNumber = generateShort12CharUniqueKey().toUpperCase();

  late ExpenseManagerCubit _expenseManagerCubit;

  @override
  void initState() {
    super.initState();
    _expenseManagerCubit = context.read<ExpenseManagerCubit>();

    if (widget.ledgerEntry != null) {
      _name = widget.ledgerEntry!.name ?? '';
      _notes = widget.ledgerEntry!.notes;
      _amount = widget.ledgerEntry!.amount;
      _expenseManagerCubit.ledgerEntry = widget.ledgerEntry!;
    } else {
      _name = '';
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {});
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
              widget.ledgerEntry == null ? 'Add Expense' : 'Edit Expense',
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
        child: BlocListener<ExpenseManagerCubit, ExpenseManagerCubitState>(
          listener: (BuildContext context, state) {
            if (state is ExpenseManagerEntryInserted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Expense added successfully'),
                  duration: const Duration(seconds: 2),
                ),
              );
              Navigator.pop(context);
            } else if (state is ExpenseManagerEntryUpdated) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Expense updated successfully'),
                  duration: const Duration(seconds: 2),
                ),
              );
              Navigator.pop(context);
            } else if (state is ExpenseManagerError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  duration: const Duration(seconds: 2),
                ),
              );
              Navigator.pop(context);
            }
          },
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    const SizedBox(height: 16),
                    TextFormField(
                      initialValue: _name,
                      decoration: InputDecoration(labelText: 'Name'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a name';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _name = value!;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      initialValue: _amount?.toString(),
                      decoration: InputDecoration(
                          labelText: 'Amount*', prefixText: '₹ '),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter an amount';
                        }
                        return null;
                      },
                      onChanged: (value) {
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
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            _formKey.currentState!.save();
                            if (widget.ledgerEntry == null) {
                              await _expenseManagerCubit.insertLedgerEntry(
                                LedgerEntry(
                                  type: LedgerEntryType.expense,
                                  invNumber: expenseNumber,
                                  name: _name,
                                  amount: _amount!,
                                  grandTotal: _amount!,
                                  notes: _notes,
                                  transactionDate: DateTime.now(),
                                  createdAt: DateTime.now(),
                                  updatedAt: DateTime.now(),
                                ),
                              );
                            } else {
                              await _expenseManagerCubit.updateLedgerEntry(
                                LedgerEntry(
                                  docId: widget.ledgerEntry!.docId,
                                  type: widget.ledgerEntry!.type,
                                  invNumber: widget.ledgerEntry!.invNumber,
                                  name: _name,
                                  amount: _amount!,
                                  grandTotal: _amount!,
                                  notes: _notes,
                                  transactionDate:
                                      widget.ledgerEntry!.transactionDate,
                                  createdAt: widget.ledgerEntry!.createdAt,
                                  updatedAt: DateTime.now(),
                                ),
                              );
                            }
                          }
                        },
                        child: Text(
                            widget.ledgerEntry == null ? 'Save' : 'Update'),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
