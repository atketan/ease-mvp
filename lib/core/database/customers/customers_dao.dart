import '../../models/customer.dart';
import 'customers_data_source.dart';

class CustomersDAO {
  final CustomersDataSource _dataSource;

  CustomersDAO(this._dataSource);

  Future<String> insertCustomer(Customer customer) {
    return _dataSource.insertCustomer(customer);
  }

  Future<List<Customer>> getAllCustomers() {
    return _dataSource.getAllCustomers();
  }

  Future<Customer?> getCustomerByName(String name) {
    return _dataSource.getCustomerByName(name);
  }

  Future<Customer?> getCustomerById(String customerId) {
    return _dataSource.getCustomerById(customerId);
  }

  Future<int> updateCustomer(Customer customer) {
    return _dataSource.updateCustomer(customer);
  }

  Future<int> deleteCustomer(int id) {
    return _dataSource.deleteCustomer(id);
  }

  Future<List<Customer>> searchCustomers(String pattern) {
    return _dataSource.searchCustomers(pattern);
  }
}
