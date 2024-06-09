import '../models/customer.dart';
import 'database_helper.dart';

class CustomersDAO {
  final DatabaseHelper _databaseHelper = DatabaseHelper();

  Future<int> insertCustomer(Customer customer) async {
    final db = await _databaseHelper.database;
    return await db.insert('Customers', customer.toJSON());
  }

  Future<List<Customer>> getAllCustomers() async {
    print("getAllCustomers");
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

  Future<int> updateCustomer(Customer customer) async {
    final db = await _databaseHelper.database;
    return await db.update('Customers', customer.toJSON(),
        where: 'id = ?', whereArgs: [customer.id]);
  }

  Future<int> deleteCustomer(int id) async {
    final db = await _databaseHelper.database;
    return await db.delete('Customers', where: 'id = ?', whereArgs: [id]);
  }
}
