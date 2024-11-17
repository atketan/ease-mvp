import '../../models/inventory_item.dart';
import 'inventory_items_data_source.dart';

class InventoryItemsDAO {
  final InventoryItemsDataSource _dataSource;

  InventoryItemsDAO(this._dataSource);

  Future<String> insertInventoryItem(InventoryItem inventoryItem) {
    return _dataSource.insertInventoryItem(inventoryItem);
  }

  Future<List<InventoryItem>> getAllInventoryItems() {
    return _dataSource.getAllInventoryItems();
  }

  Future<int> updateInventoryItem(InventoryItem inventoryItem) {
    return _dataSource.updateInventoryItem(inventoryItem);
  }

  Future<int> deleteInventoryItem(String id) {
    return _dataSource.deleteInventoryItem(id);
  }

  Future<InventoryItem?> getInventoryItemByName(String name) {
    return _dataSource.getInventoryItemByName(name);
  }

  Future<InventoryItem?> getInventoryItemById(String itemId) {
    return _dataSource.getInventoryItemById(itemId);
  }

  Future<List<InventoryItem>> getAllInventoryItemsWhereNameLike(String pattern) {
    return _dataSource.getAllInventoryItemsWhereNameLike(pattern);
  }
}
