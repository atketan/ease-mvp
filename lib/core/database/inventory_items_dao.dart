import '../models/inventory_item.dart';
import 'database_helper.dart';

class InventoryItemsDAO {
  final DatabaseHelper _databaseHelper = DatabaseHelper();

  Future<int> insertInventoryItem(InventoryItem inventoryItem) async {
    final db = await _databaseHelper.database;
    return await db.insert('InventoryItems', inventoryItem.toJSON());
  }

  Future<List<InventoryItem>> getAllInventoryItems() async {
    final db = await _databaseHelper.database;
    final List<Map<String, dynamic>> maps = await db.query('InventoryItems');
    return List.generate(maps.length, (i) => InventoryItem.fromJSON(maps[i]));
  }

  Future<int> updateInventoryItem(InventoryItem inventoryItem) async {
    final db = await _databaseHelper.database;
    return await db.update('InventoryItems', inventoryItem.toJSON(),
        where: 'id = ?', whereArgs: [inventoryItem.itemId]);
  }

  Future<int> deleteInventoryItem(int id) async {
    final db = await _databaseHelper.database;
    return await db.delete('InventoryItems', where: 'id = ?', whereArgs: [id]);
  }

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

  Future<InventoryItem?> getInventoryItemById(int itemId) async {
    final db = await _databaseHelper.database;
    final List<Map<String, dynamic>> maps =
        await db.query('InventoryItems', where: 'id = ?', whereArgs: [itemId]);

    if (maps.isNotEmpty) {
      return InventoryItem.fromJSON(maps.first);
    } else {
      return null;
    }
  }
}