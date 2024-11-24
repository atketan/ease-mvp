import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ease/core/utils/string_casing_extension.dart';

import '../../models/customer.dart';
import 'customers_data_source.dart';

class FirestoreCustomersDAO implements CustomersDataSource {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String userId;

  FirestoreCustomersDAO({required this.userId});

  @override
  Future<String> insertCustomer(Customer customer) async {
    final snapshot = await _firestore
        .collection('users')
        .doc(userId)
        .collection('customers')
        .add(customer.toJSON());
    return snapshot.id; // Firestore does not return an ID like sqflite
  }

  @override
  Future<List<Customer>> getAllCustomers() async {
    final snapshot = await _firestore
        .collection('users')
        .doc(userId)
        .collection('customers')
        .get();
    return snapshot.docs.map((doc) {
      Customer customer = Customer.fromJSON(doc.data());
      customer.id = doc.id;
      return customer;
    }).toList();
  }

  @override
  Future<Customer?> getCustomerByName(String name) async {
    final snapshot = await _firestore
        .collection('users')
        .doc(userId)
        .collection('customers')
        .where('name', isEqualTo: name)
        .get();

    if (snapshot.docs.isNotEmpty) {
      return Customer.fromJSON(snapshot.docs.first.data());
    } else {
      return null;
    }
  }

  @override
  Future<Customer?> getCustomerById(String customerId) async {
    final snapshot = await _firestore
        .collection('users')
        .doc(userId)
        .collection('customers')
        .doc(customerId)
        .get();

    if (snapshot.exists) {
      return Customer.fromJSON(snapshot.data() ?? {});
    } else {
      return null;
    }
  }

  @override
  Future<int> updateCustomer(Customer customer) async {
    await _firestore
        .collection('users')
        .doc(userId)
        .collection('customers')
        .doc(customer.id.toString()) // Assuming ID is a string in Firestore
        .update(customer.toJSON());
    return 1; // Firestore does not return an update count
  }

  @override
  Future<int> deleteCustomer(int id) async {
    await _firestore
        .collection('users')
        .doc(userId)
        .collection('customers')
        .doc(id.toString())
        .delete();
    return 1; // Firestore does not return a delete count
  }

  @override
  Future<List<Customer>> searchCustomers(String pattern) async {
    final snapshot = await _firestore
        .collection('users')
        .doc(userId)
        .collection('customers')
        .where('name', isGreaterThanOrEqualTo: pattern.toTitleCase)
        .where("name", isLessThanOrEqualTo: "${pattern.toTitleCase}\uf7ff")
        .get();

    return snapshot.docs.map((doc) => Customer.fromJSON(doc.data())).toList();
  }
}
