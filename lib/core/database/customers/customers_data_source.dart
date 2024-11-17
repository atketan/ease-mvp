import '../../models/customer.dart';

abstract class CustomersDataSource {
  Future<String> insertCustomer(Customer customer);
  Future<List<Customer>> getAllCustomers();
  Future<Customer?> getCustomerByName(String name);
  Future<Customer?> getCustomerById(String customerId);
  Future<int> updateCustomer(Customer customer);
  Future<int> deleteCustomer(int id);
  Future<List<Customer>> searchCustomers(String pattern);
}
