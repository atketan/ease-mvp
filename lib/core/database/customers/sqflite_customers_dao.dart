import 'package:sqflite/sqflite.dart';

import '../../models/customer.dart';
import '../database_helper.dart';
import 'customers_data_source.dart';

class SqfliteCustomersDAO implements CustomersDataSource {
  final DatabaseHelper _databaseHelper = DatabaseHelper();

  @override
  Future<String> insertCustomer(Customer customer) async {
    final db = await _databaseHelper.database;
    try {
      return await db.insert('Customers', customer.toJSON()).toString();
    } on DatabaseException catch (e) {
      if (e.isUniqueConstraintError()) {
        throw Exception('Phone number already exists');
      }
      rethrow;
    }
  }

  @override
  Future<List<Customer>> getAllCustomers() async {
    final db = await _databaseHelper.database;
    final List<Map<String, dynamic>> maps = await db.query('Customers');
    return List.generate(maps.length, (i) => Customer.fromJSON(maps[i]));
  }

  @override
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

  @override
  Future<Customer?> getCustomerById(String customerId) async {
    final db = await _databaseHelper.database;
    final List<Map<String, dynamic>> maps =
        await db.query('Customers', where: 'id = ?', whereArgs: [customerId]);

    if (maps.isNotEmpty) {
      return Customer.fromJSON(maps.first);
    } else {
      return null;
    }
  }

  @override
  Future<int> updateCustomer(Customer customer) async {
    final db = await _databaseHelper.database;
    return await db.update('Customers', customer.toJSON(),
        where: 'id = ?', whereArgs: [customer.id]);
  }

  @override
  Future<int> deleteCustomer(int id) async {
    final db = await _databaseHelper.database;
    return await db.delete('Customers', where: 'id = ?', whereArgs: [id]);
  }

  @override
  Future<List<Customer>> searchCustomers(String pattern) async {
    final db = await _databaseHelper.database;
    final lowercasePattern = pattern.toLowerCase();
    final result = await db.query(
      'Customers',
      where: 'LOWER(name) LIKE ? OR phone LIKE ?',
      whereArgs: ['%$lowercasePattern%', '%$lowercasePattern%'],
    );
    return result.map((map) => Customer.fromJSON(map)).toList();
  }

  @override
  getAllCustomersStream() {
    // TODO: implement getAllCustomersStream
    throw UnimplementedError();
  }
}
