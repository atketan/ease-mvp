import 'package:ease/core/database/customers_dao.dart';
import 'package:ease/core/database/vendors_dao.dart';
import 'package:ease/core/models/customer.dart';
import 'package:ease/core/models/vendor.dart';
import 'package:ease/features/invoice_manager/bloc/invoice_manager_cubit.dart';
import 'package:ease/features/invoices/data_models/invoice_type_enum.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/invoice_manager_cubit_state.dart';

class AddEntityBottomSheet extends StatefulWidget {
  final String initialName;
  final InvoiceType invoiceType;
  final Function(String) onEntityAdded;

  AddEntityBottomSheet({
    required this.initialName,
    required this.invoiceType,
    required this.onEntityAdded,
  });

  @override
  _AddEntityBottomSheetState createState() => _AddEntityBottomSheetState();
}

class _AddEntityBottomSheetState extends State<AddEntityBottomSheet> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _mobileController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.initialName);
    _mobileController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _mobileController.dispose();
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
              validator: (value) =>
                  value?.isEmpty ?? true ? 'Mobile number is required' : null,
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
                  builder: (context, state) {
                    return TextButton(
                      onPressed: (state is InvoiceManagerLoading) ? null : _submitForm,
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
        final int newId = widget.invoiceType == InvoiceType.Sales
            ? await CustomersDAO().insertCustomer(Customer(
                name: _nameController.text,
                phone: _mobileController.text,
                createdAt: DateTime.now(),
                updatedAt: DateTime.now()))
            : await VendorsDAO().insertVendor(Vendor(
                name: _nameController.text,
                phone: _mobileController.text,
                createdAt: DateTime.now(),
                updatedAt: DateTime.now()));

        if (!mounted) return;  // Check if the widget is still in the tree

        if (widget.invoiceType == InvoiceType.Sales) {
          cubit.setCustomerId(newId);
        } else {
          cubit.setVendorId(newId);
        }

        widget.onEntityAdded(_nameController.text);
        Navigator.pop(context);
      } catch (e) {
        print("Error adding entity: $e");
        if (!mounted) return;  // Check if the widget is still in the tree
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error adding entity: $e')),
        );
      } finally {
        if (mounted) cubit.setLoading(false);  // Only set loading to false if still mounted
      }
    }
  }
}