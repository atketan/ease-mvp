import 'package:ease/core/models/expense_category.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/expense_category_provider.dart';
import 'icon_selector.dart';

class ExpenseCategoryForm extends StatefulWidget {
  final ExpenseCategory? expenseCategory;

  ExpenseCategoryForm({this.expenseCategory});

  @override
  _ExpenseCategoryFormState createState() => _ExpenseCategoryFormState();
}

class _ExpenseCategoryFormState extends State<ExpenseCategoryForm> {
  final _formKey = GlobalKey<FormState>();
  late String _name;
  String? _description;
  String? _iconName;

  @override
  void initState() {
    super.initState();
    if (widget.expenseCategory != null) {
      _name = widget.expenseCategory!.name;
      _description = widget.expenseCategory!.description;
      _iconName = widget.expenseCategory!.iconName;
    } else {
      _name = '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.expenseCategory == null
            ? 'Add Expense Category'
            : 'Edit Expense Category'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              const SizedBox(height: 8),
              Text('Select Icon'),
              const SizedBox(height: 8),
              IconSelector(
                onIconSelected: (iconName) {
                  setState(() {
                    _iconName = iconName;
                  });
                },
              ),
              SizedBox(height: 20),
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
                initialValue: _description,
                decoration: InputDecoration(labelText: 'Description'),
                onSaved: (value) {
                  _description = value;
                },
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(flex: 4, child: Container()),
                  Spacer(flex: 1),
                  Expanded(
                    flex: 4,
                    child: TextButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          _formKey.currentState!.save();
                          final provider = Provider.of<ExpenseCategoryProvider>(
                              context,
                              listen: false);
                          if (widget.expenseCategory == null) {
                            provider.insertExpenseCategory(ExpenseCategory(
                              name: _name,
                              description: _description,
                              iconName: _iconName,
                              createdAt: DateTime.now(),
                              updatedAt: DateTime.now(),
                            ));
                          } else {
                            provider.updateExpenseCategory(ExpenseCategory(
                              id: widget.expenseCategory!.id,
                              categoryId: widget.expenseCategory!.categoryId,
                              name: _name,
                              description: _description,
                              iconName: _iconName,
                              createdAt: widget.expenseCategory!.createdAt,
                              updatedAt: DateTime.now(),
                            ));
                          }
                          Navigator.pop(context);
                        }
                      },
                      child: Text(
                        widget.expenseCategory == null ? 'Add' : 'Update',
                        style: TextStyle().copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
