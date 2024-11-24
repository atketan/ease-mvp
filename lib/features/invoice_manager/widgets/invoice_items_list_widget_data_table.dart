import 'package:ease/core/database/inventory/inventory_items_dao.dart';
import 'package:ease/core/models/inventory_item.dart';
import 'package:ease/core/models/invoice_item.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

import '../bloc/invoice_manager_cubit.dart';

class InvoiceItemsListWidgetDataTable extends StatefulWidget {
  @override
  _InvoiceItemsListWidgetDataTableState createState() =>
      _InvoiceItemsListWidgetDataTableState();
}

class _InvoiceItemsListWidgetDataTableState
    extends State<InvoiceItemsListWidgetDataTable> {
  late List<InvoiceItem> _invoiceItems;
  late InventoryItemsDAO _inventoryItemsDAO;

  @override
  void initState() {
    _invoiceItems = context.read<InvoiceManagerCubit>().invoice.items;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _inventoryItemsDAO = Provider.of<InventoryItemsDAO>(context);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text('ITEMS', style: Theme.of(context).textTheme.labelLarge),
          ),
          Card(
            child: ListView(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              children: [
                _buildTableHeader(),
                ListView.builder(
                  itemCount: _invoiceItems.length + 1,
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    if (index == _invoiceItems.length) {
                      return _buildNewItemRow();
                    }
                    return _buildExistingItemRow(_invoiceItems[index], index);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTableHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          SizedBox(width: 40), // For delete icon
          Expanded(
              flex: 3,
              child:
                  Text('Name', style: TextStyle(fontWeight: FontWeight.bold))),
          Expanded(
              child:
                  Text('Rate', style: TextStyle(fontWeight: FontWeight.bold))),
          Expanded(
              child:
                  Text('Qty', style: TextStyle(fontWeight: FontWeight.bold))),
          Expanded(
              child:
                  Text('Total', style: TextStyle(fontWeight: FontWeight.bold))),
        ],
      ),
    );
  }

  Widget _buildNewItemRow() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          SizedBox(width: 50, child: Icon(Icons.add_circle)),
          Expanded(
            flex: 3,
            child: TypeAheadField<InvoiceItem>(
              builder: (context, controller, focusNode) {
                return TextField(
                  controller: controller,
                  focusNode: focusNode,
                  decoration: InputDecoration(
                    hintText: 'Search item...',
                    border: OutlineInputBorder(),
                  ),
                );
              },
              suggestionsCallback: _getSuggestions,
              itemBuilder: (context, suggestion) => ListTile(
                title: Text(suggestion.name),
                subtitle: Text('Price: ${suggestion.unitPrice}'),
              ),
              onSelected: _onItemSelected,
            ),
          ),
          Expanded(child: SizedBox()), // Empty for new row
          Expanded(child: SizedBox()),
          Expanded(child: SizedBox()),
        ],
      ),
    );
  }

  Widget _buildExistingItemRow(InvoiceItem item, int index) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          IconButton(
            icon: Icon(Icons.delete, color: Colors.red),
            onPressed: () => _deleteItem(index),
          ),
          Expanded(flex: 3, child: Text(item.name)),
          Expanded(
            child: TextFormField(
              initialValue: item.unitPrice.toString(),
              onChanged: (value) => _updateRate(index, value),
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 8, vertical: 0),
              ),
            ),
          ),
          SizedBox(width: 8),
          Expanded(
            child: TextFormField(
              initialValue: item.quantity.toString(),
              onChanged: (value) => _updateQuantity(index, value),
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 8, vertical: 0),
              ),
            ),
          ),
          SizedBox(width: 8),
          Expanded(child: Text(item.totalPrice.toStringAsFixed(2))),
        ],
      ),
    );
  }

  Future<List<InvoiceItem>> _getSuggestions(String pattern) async {
    if (pattern.isEmpty) return [];
    final List<InventoryItem> items =
        await _inventoryItemsDAO.getAllInventoryItemsWhereNameLike(pattern);
    if (items.isEmpty) {
      return [
        InvoiceItem(
          itemId:
              '', // this value will be empty only in case of local SQFLite DB
          name: pattern,
          unitPrice: 0,
          quantity: 1,
          totalPrice: 0,
          uom: '',
        )
      ];
    }
    return items
        .map((item) => InvoiceItem(
              name: item.name,
              unitPrice: item.unitPrice,
              quantity: 1,
              totalPrice: item.unitPrice * 1,
              itemId: item.itemId ??
                  '', // this value will be empty only in case of local SQFLite DB,
              uom: item.uom,
            ))
        .toList();
  }

  void _onItemSelected(InvoiceItem suggestion) async {
    if (suggestion.itemId.isEmpty && suggestion.unitPrice == 0) {
      await _addNewItem(suggestion.name);
    } else {
      _addExistingItem(suggestion);
    }
  }

  Future<void> _addNewItem(String name) async {
    final newItem = InventoryItem(name: name, unitPrice: 0, uom: '');
    var _itemId = await _inventoryItemsDAO.insertInventoryItem(newItem);
    setState(() {
      _invoiceItems.add(
        InvoiceItem(
          name: name,
          unitPrice: 0,
          quantity: 1,
          totalPrice: 0,
          itemId: _itemId,
          uom: '',
        ),
      );
    });
    _updateInvoice();
  }

  void _addExistingItem(InvoiceItem item) {
    setState(() {
      _invoiceItems.add(item);
    });
    _updateInvoice();
  }

  void _deleteItem(int index) {
    setState(() {
      _invoiceItems.removeAt(index);
    });
    _updateInvoice();
  }

  void _updateRate(int index, String value) {
    setState(() {
      _invoiceItems[index].unitPrice = double.tryParse(value) ?? 0;
      _invoiceItems[index].totalPrice =
          _invoiceItems[index].unitPrice * _invoiceItems[index].quantity;
    });
    _updateInvoice();
  }

  void _updateQuantity(int index, String value) {
    setState(() {
      _invoiceItems[index].quantity = int.tryParse(value) ?? 0;
      _invoiceItems[index].totalPrice =
          _invoiceItems[index].unitPrice * _invoiceItems[index].quantity;
    });
    _updateInvoice();
  }

  void _updateInvoice() {
    context.read<InvoiceManagerCubit>().updateInvoiceAmounts();
  }
}
