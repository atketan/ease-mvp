import 'package:ease_mvp/core/database/customers_dao.dart';
import 'package:ease_mvp/core/database/vendors_dao.dart';
import 'package:ease_mvp/core/models/customer.dart';
import 'package:ease_mvp/core/models/invoice.dart';
import 'package:ease_mvp/core/models/invoice_item.dart';
import 'package:ease_mvp/core/models/vendor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'invoice_bloc.dart';

class InvoiceForm extends StatelessWidget {
  final bool isSale;

  // If it's a Sale Invoice, then that would be for a customer transaction    - credit entry on ledger
  // If it's a Purchase Invoice, then that would be for a vendor transaction  - debit entry on ledger

  // final CustomersDAO _customersDAO = CustomersDAO();
  // final VendorsDAO _vendorsDAO = VendorsDAO();

  InvoiceForm({Key? key, required this.isSale}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => InvoiceBloc(),
      child: Scaffold(
        appBar: AppBar(
            title: Text(isSale ? 'New Sale Invoice' : 'New Purchase Invoice')),
        body: InvoiceFormBody(isSale: isSale),
      ),
    );
  }
}

class InvoiceFormBody extends StatelessWidget {
  final bool isSale;
  final TextEditingController _controller = TextEditingController();

  InvoiceFormBody({Key? key, required this.isSale}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<InvoiceBloc, Invoice>(
      builder: (context, invoice) {
        return SingleChildScrollView(
          padding: EdgeInsets.all(16.0),
          child: Column(
            children: [
              _buildEntityField(
                  context, isSale ? 'Customer' : 'Vendor', isSale),
              _buildTextField(context, 'Invoice Number', (value) {
                context.read<InvoiceBloc>().setInvoiceNumber(value);
              }),
              _buildDateField(context, 'Invoice Date', invoice.date, (date) {
                context.read<InvoiceBloc>().setDate(date);
              }),
              _buildDropdownField(context, 'Payment Type', ['cash', 'credit'],
                  invoice.paymentType, (value) {
                context.read<InvoiceBloc>().setPaymentType(value);
              }),
              _buildInvoiceItems(context),
              ElevatedButton(
                onPressed: () {
                  context.read<InvoiceBloc>().saveInvoice();
                },
                child: Text('Save Invoice'),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildEntityField(BuildContext context, String label, bool isSale) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label),
        BlocBuilder<InvoiceBloc, Invoice>(
          builder: (context, invoice) {
            return TextField(
              controller: _controller,
              readOnly: true,
              onTap: () async {
                var result = await showSearch(
                  context: context,
                  delegate:
                      EntitySearchDelegate(isSale ? 'customer' : 'vendor'),
                );
                if (result != null) {
                  _controller.text = result.name;
                  if (isSale) {
                    context.read<InvoiceBloc>().setCustomer(result.id);
                  } else {
                    context.read<InvoiceBloc>().setVendor(result.id);
                  }
                }
              },
              decoration: InputDecoration(
                hintText: 'Select $label',
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildTextField(
      BuildContext context, String label, Function(String) onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label),
        TextField(
          onChanged: onChanged,
          decoration: InputDecoration(
            hintText: label,
          ),
        ),
      ],
    );
  }

  Widget _buildDateField(BuildContext context, String label,
      DateTime initialValue, Function(DateTime) onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label),
        InkWell(
          onTap: () async {
            DateTime? pickedDate = await showDatePicker(
              context: context,
              initialDate: initialValue,
              firstDate: DateTime(2000),
              lastDate: DateTime(2101),
            );
            if (pickedDate != null) {
              onChanged(pickedDate);
            }
          },
          child: InputDecorator(
            decoration: InputDecoration(
              hintText: label,
            ),
            child: Text('${initialValue.toLocal()}'.split(' ')[0]),
          ),
        ),
      ],
    );
  }

  Widget _buildDropdownField(BuildContext context, String label,
      List<String> items, String initialValue, Function(String) onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label),
        DropdownButton<String>(
          value: initialValue,
          isExpanded: true,
          items: items.map((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
          onChanged: (String? newValue) {
            if (newValue != null) {
              onChanged(newValue);
            }
          },
        ),
      ],
    );
  }

  Widget _buildInvoiceItems(BuildContext context) {
    return BlocBuilder<InvoiceBloc, Invoice>(
      builder: (context, invoice) {
        return Column(
          children: [
            ListView.builder(
              shrinkWrap: true,
              itemCount: invoice.items.length,
              itemBuilder: (context, index) {
                var item = invoice.items[index];
                return ListTile(
                  title: Text(item.name),
                  subtitle: Text('${item.quantity} x ${item.unitPrice}'),
                  trailing: IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () {
                      context.read<InvoiceBloc>().removeInvoiceItem(item);
                    },
                  ),
                );
              },
            ),
            ElevatedButton(
              onPressed: () async {
                var result = await showDialog(
                  context: context,
                  builder: (BuildContext context) =>
                      AddInvoiceItemDialog(invoiceId: invoice.id),
                );
                if (result != null) {
                  context.read<InvoiceBloc>().addInvoiceItem(result);
                }
              },
              child: Text('Add Item'),
            ),
          ],
        );
      },
    );
  }
}

class EntitySearchDelegate extends SearchDelegate {
  final String entityType;

  EntitySearchDelegate(this.entityType);

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [IconButton(icon: Icon(Icons.clear), onPressed: () => query = '')];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () => close(context, null),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return FutureBuilder(
      future: entityType == 'customer'
          ? CustomersDAO().getAllCustomers()
          : VendorsDAO().getAllVendors(),
      builder: (context, snapshot) {
        print(snapshot.connectionState.name);
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          print(snapshot.error.toString());
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        if (!snapshot.hasData || (snapshot.data as List).isEmpty) {
          return _buildNoResultsView(context);
        }
        var entities = snapshot.data as List;
        var filteredEntities =
            entities.where((entity) => entity.name.contains(query)).toList();
        if (filteredEntities.isEmpty) {
          return _buildNoResultsView(context);
        }
        return ListView.builder(
          itemCount: filteredEntities.length,
          itemBuilder: (context, index) {
            var entity = filteredEntities[index];
            return ListTile(
              title: Text(entity.name),
              onTap: () => close(context, entity),
            );
          },
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return buildResults(context);
  }

  Widget _buildNoResultsView(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('No Results Found'),
          ElevatedButton(
            onPressed: () async {
              var result = await showDialog(
                context: context,
                builder: (BuildContext context) =>
                    AddEntityDialog(entityType: entityType),
              );
              if (result != null) {
                close(context, result);
              }
            },
            child: Text(
                'Add New ${entityType == 'customer' ? 'Customer' : 'Vendor'}'),
          ),
        ],
      ),
    );
  }
}

class AddEntityDialog extends StatefulWidget {
  final String entityType;
  AddEntityDialog({required this.entityType});

  @override
  _AddEntityDialogState createState() => _AddEntityDialogState();
}

class _AddEntityDialogState extends State<AddEntityDialog> {
  final _nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
          'Add New ${widget.entityType == 'customer' ? 'Customer' : 'Vendor'}'),
      content: TextField(
        controller: _nameController,
        decoration: InputDecoration(hintText: 'Name'),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () async {
            var name = _nameController.text;
            var entity;
            if (widget.entityType == 'customer') {
              var customer = Customer(
                name: name,
                createdAt: DateTime.now(),
                updatedAt: DateTime.now(),
              );
              int customerID = await CustomersDAO().insertCustomer(customer);
              entity = customer;
              (entity as Customer).id = customerID;
            } else {
              var vendor = Vendor(
                name: name,
                createdAt: DateTime.now(),
                updatedAt: DateTime.now(),
              );
              int vendorID = await VendorsDAO().insertVendor(vendor);
              entity = vendor;
              (entity as Vendor).id = vendorID;
            }
            Navigator.of(context).pop(entity);
          },
          child: Text('Add'),
        ),
      ],
    );
  }
}

class AddInvoiceItemDialog extends StatefulWidget {
  final int? invoiceId;
  AddInvoiceItemDialog({required this.invoiceId});

  @override
  _AddInvoiceItemDialogState createState() => _AddInvoiceItemDialogState();
}

class _AddInvoiceItemDialogState extends State<AddInvoiceItemDialog> {
  final _descriptionController = TextEditingController();
  final _quantityController = TextEditingController();
  final _unitPriceController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Add Invoice Item'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _descriptionController,
            decoration: InputDecoration(hintText: 'Description'),
          ),
          TextField(
            controller: _quantityController,
            decoration: InputDecoration(hintText: 'Quantity'),
            keyboardType: TextInputType.number,
          ),
          TextField(
            controller: _unitPriceController,
            decoration: InputDecoration(hintText: 'Unit Price'),
            keyboardType: TextInputType.number,
          ),
        ],
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
            var description = _descriptionController.text;
            var quantity = int.parse(_quantityController.text);
            var unitPrice = double.parse(_unitPriceController.text);
            var totalPrice = quantity * unitPrice;

            var item = InvoiceItem(
              invoiceId: widget.invoiceId,
              itemId: null,
              name: description,
              description: null,
              quantity: quantity,
              unitPrice: unitPrice,
              totalPrice: totalPrice,
            );

            Navigator.of(context).pop(item);
          },
          child: Text('Add'),
        ),
      ],
    );
  }
}
