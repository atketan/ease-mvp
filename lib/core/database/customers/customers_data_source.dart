import 'package:cloud_firestore/cloud_firestore.dart';

import '../../models/customer.dart';

abstract class CustomersDataSource {
  Future<String> insertCustomer(Customer customer);
  Future<List<Customer>> getAllCustomers();
  Future<Customer?> getCustomerByName(String name);
  Future<Customer?> getCustomerById(String customerId);
  Future<int> updateCustomer(Customer customer);
  Future<int> deleteCustomer(int id);
  Future<List<Customer>> searchCustomers(String pattern);
  Stream<QuerySnapshot<Map<String, dynamic>>> getAllCustomersStream();
}
