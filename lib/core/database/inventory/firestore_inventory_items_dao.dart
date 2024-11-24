import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ease/core/utils/string_casing_extension.dart';
import '../../models/inventory_item.dart';
import 'inventory_items_data_source.dart';

class FirestoreInventoryItemsDAO implements InventoryItemsDataSource {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String userId;

  FirestoreInventoryItemsDAO({required this.userId});

  @override
  Future<String> insertInventoryItem(InventoryItem inventoryItem) async {
    final docRef = await _firestore
        .collection('users')
        .doc(userId)
        .collection('inventory')
        .add(inventoryItem.toJSON());
    return docRef.id; // Firestore does not return an integer ID
  }

  @override
  Future<List<InventoryItem>> getAllInventoryItems() async {
    final snapshot = await _firestore
        .collection('users')
        .doc(userId)
        .collection('inventory')
        .get();
    return snapshot.docs.map((doc) {
      InventoryItem item = InventoryItem.fromJSON(doc.data());
      item.itemId = doc.id;
      return item;
    }).toList();
  }

  @override
  Future<int> updateInventoryItem(InventoryItem inventoryItem) async {
    await _firestore
        .collection('users')
        .doc(userId)
        .collection('inventory')
        .doc(inventoryItem.itemId)
        .update(inventoryItem.toJSON());
    return 1; // Firestore does not return an update count
  }

  @override
  Future<int> deleteInventoryItem(String id) async {
    await _firestore
        .collection('users')
        .doc(userId)
        .collection('inventory')
        .doc(id)
        .delete();
    return 1; // Firestore does not return a delete count
  }

  @override
  Future<InventoryItem?> getInventoryItemByName(String name) async {
    final snapshot = await _firestore
        .collection('users')
        .doc(userId)
        .collection('inventory')
        .where('name', isGreaterThanOrEqualTo: name.toTitleCase)
        .where("name", isLessThanOrEqualTo: "${name.toTitleCase}\uf7ff")
        .get();
    if (snapshot.docs.isNotEmpty) {
      return InventoryItem.fromJSON(snapshot.docs.first.data());
    } else {
      return null;
    }
  }

  @override
  Future<InventoryItem?> getInventoryItemById(String itemId) async {
    final doc = await _firestore
        .collection('users')
        .doc(userId)
        .collection('inventory')
        .doc(itemId)
        .get();
    if (doc.exists) {
      return InventoryItem.fromJSON(doc.data()!);
    } else {
      return null;
    }
  }

  @override
  Future<List<InventoryItem>> getAllInventoryItemsWhereNameLike(
      String pattern) async {
    final snapshot = await _firestore
        .collection('users')
        .doc(userId)
        .collection('inventory')
        .where('name', isGreaterThanOrEqualTo: pattern.toTitleCase)
        .where('name', isLessThanOrEqualTo: "${pattern.toTitleCase}\uf7ff")
        .get();
    return snapshot.docs.map((doc) {
      final item = InventoryItem.fromJSON(doc.data());
      item.itemId = doc.id;
      return item;
    }).toList();
  }
}
