import 'package:ease/core/utils/developer_log.dart';

import '../models/inventory_item.dart';
import 'database_helper.dart';
import 'package:sqflite/sqflite.dart';

class InventoryItemsDAO {
  final DatabaseHelper _databaseHelper = DatabaseHelper();

  Future<int> insertInventoryItem(InventoryItem inventoryItem) async {
    late Database db;
    try {
      db = await _databaseHelper.database;
      debugLog('Database opened successfully', name: 'InventoryItemsDAO');

      debugLog('Attempting to insert: ${inventoryItem.toJSON()}',
          name: 'InventoryItemsDAO');
      final result = await db.insert('InventoryItems', inventoryItem.toJSON());
      debugLog('Insert operation completed. Result: $result',
          name: 'InventoryItemsDAO');

      return result;
    } catch (e, stackTrace) {
      debugLog('Error inserting inventory item',
          error: e, stackTrace: stackTrace, name: 'InventoryItemsDAO');
      // Re-throw the error if you want calling code to handle it
      rethrow;
    } finally {
      // Ensure the database is closed if it was opened
      // if (db.isOpen) {
      //   await db.close();
      //   debugLog('Database closed', name: 'InventoryItemsDAO');
      // }
    }
  }

  Future<List<InventoryItem>> getAllInventoryItems() async {
    final db = await _databaseHelper.database;
    final List<Map<String, dynamic>> maps = await db.query('InventoryItems');
    return List.generate(maps.length, (i) => InventoryItem.fromJSON(maps[i]));
  }

  Future<int> updateInventoryItem(InventoryItem inventoryItem) async {
    final db = await _databaseHelper.database;
    return await db.update('InventoryItems', inventoryItem.toJSON(),
        where: 'item_id = ?', whereArgs: [inventoryItem.itemId]);
  }

  Future<int> deleteInventoryItem(int id) async {
    final db = await _databaseHelper.database;
    return await db
        .delete('InventoryItems', where: 'item_id = ?', whereArgs: [id]);
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
    final List<Map<String, dynamic>> maps = await db
        .query('InventoryItems', where: 'item_id = ?', whereArgs: [itemId]);

    if (maps.isNotEmpty) {
      return InventoryItem.fromJSON(maps.first);
    } else {
      return null;
    }
  }

  Future<List<InventoryItem>> getAllInventoryItemsWhereNameLike(
      String pattern) async {
    final db = await _databaseHelper.database;
    final List<Map<String, dynamic>> maps = await db.query('InventoryItems',
        where: 'name LIKE ?', whereArgs: ['%$pattern%']);
    return List.generate(maps.length, (i) => InventoryItem.fromJSON(maps[i]));
  }
}
