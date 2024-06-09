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

  Future<int> updateVendor(Vendor vendor) async {
    final db = await _databaseHelper.database;
    return await db.update('Vendors', vendor.toJSON(),
        where: 'id = ?', whereArgs: [vendor.id]);
  }

  Future<int> deleteVendor(int id) async {
    final db = await _databaseHelper.database;
    return await db.delete('Vendors', where: 'id = ?', whereArgs: [id]);
  }
}
