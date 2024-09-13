import 'package:ease/core/database/inventory_items_dao.dart';
import 'package:ease/core/models/inventory_item.dart';
import 'package:flutter/material.dart';

enum InventoryItemsFormMode {
  Add,
  Edit,
}

class UpdateItemsPage extends StatefulWidget {
  final InventoryItemsFormMode mode;
  final int? itemId;

  const UpdateItemsPage({Key? key, required this.mode, this.itemId})
      : assert(mode == InventoryItemsFormMode.Add || itemId != null,
            'itemId cannot be null in Edit mode');
  @override
  UpdateItemsPageState createState() => UpdateItemsPageState();
}

class UpdateItemsPageState extends State<UpdateItemsPage> {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _unitController = TextEditingController();
  TextEditingController _unitPriceController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();

  InventoryItemsDAO _itemsDAO = InventoryItemsDAO();
  late InventoryItem? item;

  @override
  void initState() {
    super.initState();
    if (widget.mode == InventoryItemsFormMode.Edit) {
      // Fetch item details using the item ID
      _fetchItemDetails();
    }
  }

  Future<void> _fetchItemDetails() async {
    // Fetch item details using the item ID
    item = await _itemsDAO.getInventoryItemById(widget.itemId ?? 0);
    if (item != null) {
      setState(() {
        _nameController.text = item!.name;
        _unitController.text = item!.uom;
        _descriptionController.text = item!.description ?? "";
        _unitPriceController.text = item!.unitPrice.toString();
      });
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _unitController.dispose();
    _unitPriceController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _saveItem() async {
    print('Saving item');
    final name = _nameController.text;
    final uom = _unitController.text;
    final description = _descriptionController.text;
    final unitPrice = double.parse(_unitPriceController.text);

    if (widget.mode == InventoryItemsFormMode.Add) {
      // Create a new inventory item
      final item = InventoryItem(
        name: name,
        description: description,
        uom: uom,
        unitPrice: unitPrice,
      );
      // _itemsDAO.insertInventoryItem(item);
      try {
        final result = await _itemsDAO.insertInventoryItem(item);
        print('Item inserted successfully with id: $result');
      } catch (e) {
        print('Error inserting item: $e');
        // Handle the error (e.g., show an error message to the user)
      }
    } else {
      // Update the existing inventory item
      final updatedItem = InventoryItem(
        itemId: widget.itemId,
        name: name,
        description: description,
        uom: uom,
        unitPrice: unitPrice,
      );
      _itemsDAO.updateInventoryItem(updatedItem);
    }

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.mode == InventoryItemsFormMode.Add
            ? 'Add Item'
            : 'Edit Item'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Name'),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: _unitController,
              decoration: InputDecoration(labelText: 'Unit'),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: _unitPriceController,
              decoration: InputDecoration(labelText: 'Unit Price'),
              keyboardType: TextInputType.numberWithOptions(decimal: true),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: _descriptionController,
              decoration: InputDecoration(labelText: 'Description'),
            ),
            SizedBox(height: 24),
            Row(
              children: [
                Expanded(flex: 4, child: Container()),
                Spacer(flex: 1),
                Expanded(
                  flex: 4,
                  child: TextButton(
                    onPressed: () => _saveItem(),
                    child: Text(
                      'Save',
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
    );
  }
}
