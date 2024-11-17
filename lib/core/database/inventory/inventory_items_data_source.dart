import '../../models/inventory_item.dart';

abstract class InventoryItemsDataSource {
  Future<String> insertInventoryItem(InventoryItem inventoryItem);
  Future<List<InventoryItem>> getAllInventoryItems();
  Future<int> updateInventoryItem(InventoryItem inventoryItem);
  Future<int> deleteInventoryItem(String itemId);
  Future<InventoryItem?> getInventoryItemByName(String name);
  Future<InventoryItem?> getInventoryItemById(String itemId);
  Future<List<InventoryItem>> getAllInventoryItemsWhereNameLike(String pattern);
}