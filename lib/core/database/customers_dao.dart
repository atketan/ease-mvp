import 'package:sqflite/sqflite.dart';

import '../models/customer.dart';
import 'database_helper.dart';

class CustomersDAO {
  final DatabaseHelper _databaseHelper = DatabaseHelper();

  Future<int> insertCustomer(Customer customer) async {
    final db = await _databaseHelper.database;
    try {
      return await db.insert('Customers', customer.toJSON());
    } on DatabaseException catch (e) {
      if (e.isUniqueConstraintError()) {
        throw Exception('Phone number already exists');
      }
      rethrow;
    }
  }

  Future<List<Customer>> getAllCustomers() async {
    final db = await _databaseHelper.database;
    final List<Map<String, dynamic>> maps = await db.query('Customers');
    List.generate(maps.length, (i) {
      print(Customer.fromJSON(maps[i]).toJSON());
    });
    return List.generate(maps.length, (i) => Customer.fromJSON(maps[i]));
  }

  Future<Customer?> getCustomerByName(String name) async {
    final db = await _databaseHelper.database;
    final List<Map<String, dynamic>> maps =
        await db.query('Customers', where: 'name = ?', whereArgs: [name]);

    if (maps.isNotEmpty) {
      return Customer.fromJSON(maps.first);
    } else {
      return null;
    }
  }

  Future<Customer?> getCustomerById(int customerId) async {
    final db = await _databaseHelper.database;
    final List<Map<String, dynamic>> maps =
        await db.query('Customers', where: 'id = ?', whereArgs: [customerId]);

    if (maps.isNotEmpty) {
      return Customer.fromJSON(maps.first);
    } else {
      return null;
    }
  }

  Future<int> updateCustomer(Customer customer) async {
    final db = await _databaseHelper.database;
    return await db.update('Customers', customer.toJSON(),
        where: 'id = ?', whereArgs: [customer.id]);
  }

  Future<int> deleteCustomer(int id) async {
    final db = await _databaseHelper.database;
    return await db.delete('Customers', where: 'id = ?', whereArgs: [id]);
  }

  Future<List<Customer>> searchCustomers(String pattern) async {
    final db = await _databaseHelper.database;
    final lowercasePattern = pattern.toLowerCase();
    final result = await db.query(
      'customers',
      where: 'LOWER(name) LIKE ? OR phone LIKE ?',
      whereArgs: ['%$lowercasePattern%', '%$pattern%'],
    );
    return result.map((map) => Customer.fromJSON(map)).toList();
  }
}
