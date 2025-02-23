import 'package:ease/core/enums/transaction_category_enum.dart';
import 'package:provider/provider.dart';
import 'package:ease/core/database/customers/customers_dao.dart';
import 'package:ease/core/database/vendors/vendors_dao.dart';
// import 'package:ease/core/models/customer.dart';
// import 'package:ease/core/models/vendor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

import '../bloc/invoice_manager_v2_cubit.dart';
import '../bloc/invoice_manager_v2_cubit_state.dart';
import 'entity_add_new_bottomsheet.dart';

class Entity {
  final String? id;
  final String name;
  final String phone;

  Entity({required this.id, required this.name, required this.phone});
}

class EntityTypeAheadField extends StatefulWidget {
  final TransactionCategory transactionCategory;
  // final Function(String clientName) onClientSelected;

  EntityTypeAheadField({
    required this.transactionCategory,
    // required this.onClientSelected,
  });

  @override
  _EntityTypeAheadFieldState createState() => _EntityTypeAheadFieldState();
}

class _EntityTypeAheadFieldState extends State<EntityTypeAheadField> {
  late CustomersDAO _customersDAO;
  late VendorsDAO _vendorsDAO;
  final TextEditingController _controller = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  bool _isEditing = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _getEntityDetails();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _customersDAO = Provider.of<CustomersDAO>(context);
    _vendorsDAO = Provider.of<VendorsDAO>(context);
    return BlocBuilder<InvoiceManagerCubit, InvoiceManagerCubitState>(
      builder: (context, state) {
        if (state is InvoiceManagerLoaded) {
          // widget.onClientSelected(_controller.text);
          return _isEditing
              ? _buildTypeAheadField()
              : _buildSelectedEntityField();
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
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
            labelText: widget.transactionCategory == TransactionCategory.sales
                ? 'Enter customer name' // or phone number
                : 'Enter vendor name', // or phone number
            labelStyle: Theme.of(context).textTheme.labelLarge,
            hintText:
                'Start typing to search or add ${widget.transactionCategory == TransactionCategory.sales ? 'Customer' : 'Supplier'}',
          ),
          style: Theme.of(context).textTheme.labelLarge,
        );
      },
      suggestionsCallback: (pattern) async {
        if (pattern.isEmpty) return <Entity>[];
        if (widget.transactionCategory == TransactionCategory.sales) {
          final customers = await _customersDAO.searchCustomers(pattern);
          final matchedCustomers = customers
              .map((c) => Entity(id: c.id, name: c.name, phone: c.phone ?? ''))
              .toList();
          if (matchedCustomers.isEmpty) {
            return [Entity(id: '', name: "Add: $pattern", phone: '')];
          }
          return matchedCustomers;
        } else {
          final vendors = await _vendorsDAO.searchVendors(pattern);
          final matchedVendors = vendors
              .map((v) => Entity(id: v.id, name: v.name, phone: v.phone ?? ''))
              .toList();
          if (matchedVendors.isEmpty) {
            return [Entity(id: '', name: "Add: $pattern", phone: '')];
          }
          return matchedVendors;
        }
      },
      itemBuilder: (context, suggestion) {
        return ListTile(
          title: Text(suggestion.name),
          subtitle: Text(suggestion.phone),
        );
      },
      onSelected: (suggestion) async {
        setState(() {
          _controller.text = suggestion.name;
          _phoneController.text = suggestion.phone;
          _isEditing = false;
          // widget.onClientSelected(suggestion.name);
        });
        if (suggestion.id!.isNotEmpty) {
          if (widget.transactionCategory == TransactionCategory.sales) {
            context.read<InvoiceManagerCubit>().setCustomerId(suggestion.id!);
            context.read<InvoiceManagerCubit>().ledgerEntry.name =
                suggestion.name;
            context.read<InvoiceManagerCubit>().phoneNumber = suggestion.phone;
          } else {
            context.read<InvoiceManagerCubit>().setVendorId(suggestion.id!);
            context.read<InvoiceManagerCubit>().ledgerEntry.name =
                suggestion.name;
            context.read<InvoiceManagerCubit>().phoneNumber = suggestion.phone;
          }
          context.read<InvoiceManagerCubit>().setLoading(false);
        } else {
          if (suggestion.id!.isEmpty) {
            _isEditing = true;
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
    // widget.onClientSelected(_controller.text);
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _controller.text,
                style: Theme.of(context).textTheme.titleMedium!.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              Text(
                (_phoneController.text.isEmpty) ? '--' : _phoneController.text,
                style: Theme.of(context).textTheme.labelMedium,
              ),
            ],
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
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return BlocProvider.value(
          value: cubit,
          child: AddEntityBottomSheet(
            initialName: initialName,
            transactionCategory: widget.transactionCategory,
          ),
        );
      },
    );
    setState(() {
      _controller.text = cubit.ledgerEntry.name!;
      _phoneController.text = cubit.phoneNumber;
      _isEditing = false;
    });
  }

  void _getEntityDetails() async {
    // String? customerId;
    // String? vendorId;

    if (context.read<InvoiceManagerCubit>().ledgerEntry.transactionType ==
        TransactionCategory.sales) {
      // customerId = context.read<InvoiceManagerCubit>().ledgerEntry.associatedId;
      _controller.text = context.read<InvoiceManagerCubit>().ledgerEntry.name!;
      _phoneController.text = context.read<InvoiceManagerCubit>().phoneNumber;
      _isEditing = false;
      // if (customerId != null && customerId.isNotEmpty) {
      //   Customer? customer = await _customersDAO.getCustomerById(customerId);
      //   if (customer != null) {
      //     _controller.text = customer.name;
      //     _phoneController.text = customer.phone ?? "";
      //     _isEditing = false;
      //   }
      // }
    } else {
      // vendorId = context.read<InvoiceManagerCubit>().ledgerEntry.associatedId;
      _controller.text = context.read<InvoiceManagerCubit>().ledgerEntry.name!;
      _phoneController.text = context.read<InvoiceManagerCubit>().phoneNumber;
      _isEditing = false;
      // if (vendorId != null && vendorId.isNotEmpty) {
      //   Vendor? vendor = await _vendorsDAO.getVendorById(vendorId);
      //   if (vendor != null) {
      //     _controller.text = vendor.name;
      //     _phoneController.text = vendor.phone ?? "";
      //     _isEditing = false;
      //   }
      // }
    }

    context.read<InvoiceManagerCubit>().setEntityName(_controller.text);
  }
}
