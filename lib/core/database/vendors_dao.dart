import '../models/vendor.dart';
import 'database_helper.dart';

class VendorsDAO {
  final DatabaseHelper _databaseHelper = DatabaseHelper();

  Future<int> insertVendor(Vendor vendor) async {
    final db = await _databaseHelper.database;
    return await db.insert('Vendors', vendor.toJSON());
  }

  Future<List<Vendor>> getAllVendors() async {
    final db = await _databaseHelper.database;
    final List<Map<String, dynamic>> maps = await db.query('Vendors');
    return List.generate(maps.length, (i) => Vendor.fromJSON(maps[i]));
  }

  Future<Vendor?> getVendorByName(String name) async {
    final db = await _databaseHelper.database;
    final List<Map<String, dynamic>> maps =
        await db.query('Vendors', where: 'name = ?', whereArgs: [name]);

    if (maps.isNotEmpty) {
      return Vendor.fromJSON(maps.first);
    } else {
      return null;
    }
  }

  Future<Vendor?> getVendorById(int vendorId) async {
    final db = await _databaseHelper.database;
    final List<Map<String, dynamic>> maps =
        await db.query('Vendors', where: 'id = ?', whereArgs: [vendorId]);

    if (maps.isNotEmpty) {
      return Vendor.fromJSON(maps.first);
    } else {
      return null;
    }
  }

  Future<int> updateVendor(Vendor vendor) async {
    final db = await _databaseHelper.database;
    return await db.update('Vendors', vendor.toJSON(),
        where: 'id = ?', whereArgs: [vendor.id]);
  }

  Future<int> deleteVendor(int id) async {
    final db = await _databaseHelper.database;
    return await db.delete('Vendors', where: 'id = ?', whereArgs: [id]);
  }

  Future<List<Vendor>> searchVendors(String pattern) async {
    final db = await _databaseHelper.database;
    final lowercasePattern = pattern.toLowerCase();
    final result = await db.query(
      'vendors',
      where: 'LOWER(name) LIKE ? OR phone LIKE ?',
      whereArgs: ['%$lowercasePattern%', '%$pattern%'],
    );
    return result.map((map) => Vendor.fromJSON(map)).toList();
  }
}
