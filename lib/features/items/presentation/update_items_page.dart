import 'package:ease_mvp/core/database/inventory_items_dao.dart';
import 'package:ease_mvp/core/models/inventory_item.dart';
import 'package:flutter/material.dart';

enum FormMode {
  Add,
  Edit,
}

class UpdateItemsPage extends StatefulWidget {
  final FormMode mode;
  final int? itemId;

  const UpdateItemsPage({Key? key, required this.mode, this.itemId})
      : assert(mode == FormMode.Add || itemId != null,
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
    if (widget.mode == FormMode.Edit) {
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
        _unitController.text = item!.unit;
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

  void _saveItem() {
    final name = _nameController.text;
    final unit = _unitController.text;
    final description = _descriptionController.text;
    final unitPrice = double.parse(_unitPriceController.text);

    if (widget.mode == FormMode.Add) {
      // Create a new inventory item
      final item = InventoryItem(
        name: name,
        description: description,
        unit: unit,
        unitPrice: unitPrice,
      );
      _itemsDAO.insertInventoryItem(item);
    } else {
      // Update the existing inventory item
      final updatedItem = InventoryItem(
        itemId: widget.itemId,
        name: name,
        description: description,
        unit: unit,
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
        title: Text(widget.mode == FormMode.Add ? 'Add Item' : 'Edit Item'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Name'),
            ),
            TextField(
              controller: _unitController,
              decoration: InputDecoration(labelText: 'Unit'),
            ),
            TextField(
              controller: _unitPriceController,
              decoration: InputDecoration(labelText: 'Unit Price'),
              keyboardType: TextInputType.numberWithOptions(decimal: true),
            ),
            TextField(
              controller: _descriptionController,
              decoration: InputDecoration(labelText: 'Description'),
            ),
            SizedBox(height: 16),
            Center(
              child: ElevatedButton(
                onPressed: _saveItem,
                child: Text('Save'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}