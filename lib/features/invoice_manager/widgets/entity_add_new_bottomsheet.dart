import 'package:ease/core/enums/invoice_type_enum.dart';
import 'package:ease/features/invoice_manager/bloc/invoice_manager_cubit.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';

import '../bloc/invoice_manager_cubit_state.dart';

class AddEntityBottomSheet extends StatefulWidget {
  final String initialName;
  final InvoiceType invoiceType;

  AddEntityBottomSheet({
    required this.initialName,
    required this.invoiceType,
  });

  @override
  _AddEntityBottomSheetState createState() => _AddEntityBottomSheetState();
}

class _AddEntityBottomSheetState extends State<AddEntityBottomSheet> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _mobileController;
  late TextEditingController _openingBalanceController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.initialName);
    _mobileController = TextEditingController();
    _openingBalanceController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _mobileController.dispose();
    _openingBalanceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 16,
        right: 16,
        top: 16,
      ),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _nameController,
              keyboardType: TextInputType.name,
              decoration: InputDecoration(labelText: 'Name'),
              validator: (value) =>
                  value?.isEmpty ?? true ? 'Name is required' : null,
            ),
            SizedBox(height: 16),
            TextFormField(
              controller: _mobileController,
              keyboardType: TextInputType.phone,
              maxLength: 10,
              decoration: InputDecoration(labelText: 'Mobile Number'),
              validator: (value) {
                if (value?.isEmpty ?? true) return 'Mobile number is required';
                if (value!.length != 10)
                  return 'Mobile number must be 10 digits';
                return null;
              },
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: _openingBalanceController,
              maxLength: 50,
              keyboardType: TextInputType.numberWithOptions(
                decimal: true,
                signed: true,
              ),
              decoration: InputDecoration(
                labelText: 'Opening Balance',
                prefixText: '₹ ',
              ),
            ),
            SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('Cancel'),
                ),
                SizedBox(width: 16),
                BlocBuilder<InvoiceManagerCubit, InvoiceManagerCubitState>(
                  bloc: context.read<InvoiceManagerCubit>(),
                  builder: (context, state) {
                    return TextButton(
                      onPressed:
                          (state is InvoiceManagerLoading) ? null : _submitForm,
                      child: (state is InvoiceManagerLoading)
                          ? SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Theme.of(context).colorScheme.onPrimary,
                                ),
                              ),
                            )
                          : Text('Add'),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _submitForm() async {
    if (_formKey.currentState?.validate() ?? false) {
      final cubit = context.read<InvoiceManagerCubit>();
      cubit.setLoading(true);

      try {
        widget.invoiceType == InvoiceType.Sales
            ? await cubit.insertNewCustomer(
                name: _nameController.text,
                phone: _mobileController.text,
                openingBalance:
                    double.tryParse(_openingBalanceController.text.trim()) ??
                        0.0,
              )
            : await cubit.insertNewVendor(
                name: _nameController.text,
                phone: _mobileController.text,
                openingBalance:
                    double.tryParse(_openingBalanceController.text.trim()) ??
                        0.0,
              );

        if (!mounted) return;

        Navigator.pop(context);
      } on DatabaseException catch (e) {
        if (!mounted) return;
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString())),
        );
      } catch (e) {
        if (!mounted) return;
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error adding entity! \n$e')),
        );
      } finally {
        if (mounted) cubit.setLoading(false);
      }
    }
  }
}
