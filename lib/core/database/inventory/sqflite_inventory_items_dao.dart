import '../../models/inventory_item.dart';
import '../database_helper.dart';
import 'inventory_items_data_source.dart';

class SqfliteInventoryItemsDAO implements InventoryItemsDataSource {
  final DatabaseHelper _databaseHelper = DatabaseHelper();

  @override
  Future<String> insertInventoryItem(InventoryItem inventoryItem) async {
    final db = await _databaseHelper.database;
    return await db.insert('InventoryItems', inventoryItem.toJSON()).toString();
  }

  @override
  Future<List<InventoryItem>> getAllInventoryItems() async {
    final db = await _databaseHelper.database;
    final List<Map<String, dynamic>> maps = await db.query('InventoryItems');
    return List.generate(maps.length, (i) => InventoryItem.fromJSON(maps[i]));
  }

  @override
  Future<int> updateInventoryItem(InventoryItem inventoryItem) async {
    final db = await _databaseHelper.database;
    return await db.update('InventoryItems', inventoryItem.toJSON(),
        where: 'item_id = ?', whereArgs: [inventoryItem.itemId]);
  }

  @override
  Future<int> deleteInventoryItem(String id) async {
    final db = await _databaseHelper.database;
    return await db.delete('InventoryItems', where: 'item_id = ?', whereArgs: [id]);
  }

  @override
  Future<InventoryItem?> getInventoryItemByName(String name) async {
    final db = await _databaseHelper.database;
    final List<Map<String, dynamic>> maps =
        await db.query('InventoryItems', where: 'name = ?', whereArgs: [name]);

    if (maps.isNotEmpty) {
      return InventoryItem.fromJSON(maps.first);
    } else {
      return null;
    }
  }

  @override
  Future<InventoryItem?> getInventoryItemById(String itemId) async {
    final db = await _databaseHelper.database;
    final List<Map<String, dynamic>> maps =
        await db.query('InventoryItems', where: 'item_id = ?', whereArgs: [itemId]);

    if (maps.isNotEmpty) {
      return InventoryItem.fromJSON(maps.first);
    } else {
      return null;
    }
  }

  @override
  Future<List<InventoryItem>> getAllInventoryItemsWhereNameLike(String pattern) async {
    final db = await _databaseHelper.database;
    final List<Map<String, dynamic>> maps =
        await db.query('InventoryItems', where: 'name LIKE ?', whereArgs: ['%$pattern%']);
    return List.generate(maps.length, (i) => InventoryItem.fromJSON(maps[i]));
  }
}