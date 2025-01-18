import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sqflite/sqflite.dart';
import '../../models/vendor.dart';
import '../database_helper.dart';
import 'vendors_data_source.dart';

class SqfliteVendorsDAO implements VendorsDataSource {
  final DatabaseHelper _databaseHelper = DatabaseHelper();

  @override
  Future<String> insertVendor(Vendor vendor) async {
    final db = await _databaseHelper.database;
    try {
      return await db.insert('Vendors', vendor.toJSON()).toString();
    } on DatabaseException catch (e) {
      if (e.isUniqueConstraintError()) {
        throw Exception('Phone number already exists');
      }
      rethrow;
    }
  }

  @override
  Future<List<Vendor>> getAllVendors() async {
    final db = await _databaseHelper.database;
    final List<Map<String, dynamic>> maps = await db.query('Vendors');
    return List.generate(maps.length, (i) => Vendor.fromJSON(maps[i]));
  }

  @override
  Future<int> updateVendor(Vendor vendor) async {
    final db = await _databaseHelper.database;
    return await db.update('Vendors', vendor.toJSON(),
        where: 'vendor_id = ?', whereArgs: [vendor.id]);
  }

  @override
  Future<int> deleteVendor(String vendorId) async {
    final db = await _databaseHelper.database;
    return await db
        .delete('Vendors', where: 'vendor_id = ?', whereArgs: [vendorId]);
  }

  @override
  Future<Vendor?> getVendorByPhoneNumber(String phoneNumber) async {
    final db = await _databaseHelper.database;
    final List<Map<String, dynamic>> maps = await db
        .query('Vendors', where: 'phone_number = ?', whereArgs: [phoneNumber]);

    if (maps.isNotEmpty) {
      return Vendor.fromJSON(maps.first);
    } else {
      return null;
    }
  }

  @override
  Future<Vendor?> getVendorById(String vendorId) async {
    final db = await _databaseHelper.database;
    final List<Map<String, dynamic>> maps = await db
        .query('Vendors', where: 'vendor_id = ?', whereArgs: [vendorId]);

    if (maps.isNotEmpty) {
      return Vendor.fromJSON(maps.first);
    } else {
      return null;
    }
  }

  @override
  Future<List<Vendor>> searchVendors(String pattern) async {
    final db = await _databaseHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'Vendors',
      where: 'name LIKE ?',
      whereArgs: ['%$pattern%'],
    );
    return List.generate(maps.length, (i) => Vendor.fromJSON(maps[i]));
  }

  @override
  Stream<QuerySnapshot<Map<String, dynamic>>> getAllVendorsStream() {
    // TODO: implement getAllVendorsStream
    throw UnimplementedError();
  }
}
