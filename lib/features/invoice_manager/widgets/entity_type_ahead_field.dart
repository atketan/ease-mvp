import 'package:ease/core/database/customers_dao.dart';
import 'package:ease/core/database/vendors_dao.dart';
import 'package:ease/features/invoice_manager/bloc/invoice_manager_cubit.dart';
import 'package:ease/features/invoice_manager/bloc/invoice_manager_cubit_state.dart';
import 'package:ease/features/invoices/data_models/invoice_type_enum.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

import 'entity_add_new_bottomsheet.dart';

class Entity {
  final int? id;
  final String name;

  Entity({required this.id, required this.name});
}

class EntityTypeAheadField extends StatefulWidget {
  final InvoiceType invoiceType;

  EntityTypeAheadField({required this.invoiceType});

  @override
  _EntityTypeAheadFieldState createState() => _EntityTypeAheadFieldState();
}

class _EntityTypeAheadFieldState extends State<EntityTypeAheadField> {
  final TextEditingController _controller = TextEditingController();
  bool _isEditing = true;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.invoiceType == InvoiceType.Sales ? 'Customer' : 'Vendor',
            style: Theme.of(context).textTheme.titleSmall,
          ),
          SizedBox(height: 8),
          BlocBuilder<InvoiceManagerCubit, InvoiceManagerCubitState>(
            builder: (context, state) {
              debugPrint(
                  "State: $state, isEditing: $_isEditing, controller name: ${_controller.text}");
              if (state is InvoiceManagerLoaded) {
                return _isEditing
                    ? _buildTypeAheadField()
                    : _buildSelectedEntityField();
              } else {
                return Center(child: CircularProgressIndicator());
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildTypeAheadField() {
    return TypeAheadField<Entity>(
      builder: (context, controller, focusNode) {
        return TextField(
          controller: controller,
          focusNode: focusNode,
          onTapOutside: (event) => focusNode.unfocus(),
          decoration: InputDecoration(
            labelText: widget.invoiceType == InvoiceType.Sales
                ? 'Select customer'
                : 'Select vendor',
            hintText:
                'Start typing to search or add ${widget.invoiceType == InvoiceType.Sales ? 'Customer' : 'Vendor'}',
          ),
          style: Theme.of(context).textTheme.titleMedium,
        );
      },
      suggestionsCallback: (pattern) async {
        if (pattern.isEmpty) return <Entity>[];
        if (widget.invoiceType == InvoiceType.Sales) {
          final customers = await CustomersDAO().getAllCustomers();
          final matchedCustomers = customers
              .where((customer) =>
                  customer.name.toLowerCase().contains(pattern.toLowerCase()))
              .map((c) => Entity(id: c.id, name: c.name))
              .toList();
          if (matchedCustomers.isEmpty) {
            return [Entity(id: -1, name: "Add: $pattern")];
          }
          return matchedCustomers;
        } else {
          final vendors = await VendorsDAO().getAllVendors();
          final matchedVendors = vendors
              .where((vendor) =>
                  vendor.name.toLowerCase().contains(pattern.toLowerCase()))
              .map((v) => Entity(id: v.id, name: v.name))
              .toList();
          if (matchedVendors.isEmpty) {
            return [Entity(id: -1, name: "Add: $pattern")];
          }
          return matchedVendors;
        }
      },
      itemBuilder: (context, suggestion) {
        return ListTile(
          title: Text(suggestion.name),
        );
      },
      onSelected: (suggestion) async {
        setState(() {
          _controller.text = suggestion.name.split(' ').last;
          _isEditing = false;
        });
        if (suggestion.id != -1 && suggestion.id != null) {
          if (widget.invoiceType == InvoiceType.Sales) {
            context.read<InvoiceManagerCubit>().setCustomerId(suggestion.id!);
          } else {
            context.read<InvoiceManagerCubit>().setVendorId(suggestion.id!);
          }
        } else {
          if (suggestion.id == -1) {
            await _showAddEntityBottomSheet(
              context,
              suggestion.name.split(':').last.trim(),
              context.read<InvoiceManagerCubit>(),
            );
          }
        }
      },
    );
  }

  Widget _buildSelectedEntityField() {
    return Row(
      children: [
        Expanded(
          child: Text(
            _controller.text,
            style: Theme.of(context).textTheme.titleMedium!.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
        ),
        IconButton(
          icon: Icon(Icons.edit),
          onPressed: () {
            setState(() {
              _isEditing = true;
            });
          },
        ),
      ],
    );
  }

  Future<void> _showAddEntityBottomSheet(BuildContext context,
      String initialName, InvoiceManagerCubit cubit) async {
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return BlocProvider.value(
          value: cubit,
          child: AddEntityBottomSheet(
            initialName: initialName,
            invoiceType: widget.invoiceType,
            onEntityAdded: (String name) {
              _controller.text = name;
              _isEditing = false;
            },
          ),
        );
      },
    );
    setState(() {});
  }
}
