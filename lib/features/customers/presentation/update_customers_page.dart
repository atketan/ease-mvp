import 'package:ease_mvp/core/database/customers_dao.dart';
import 'package:ease_mvp/core/models/customer.dart';
import 'package:flutter/material.dart';

enum FormMode {
  Add,
  Edit,
}

class UpdateCustomersPage extends StatefulWidget {
  final FormMode mode;
  final int? customerId;

  UpdateCustomersPage({required this.mode, this.customerId = null})
      : assert(mode == FormMode.Add || customerId != null,
            'customerId cannot be null in Edit mode');

  @override
  _UpdateCustomersPageState createState() => _UpdateCustomersPageState();
}

class _UpdateCustomersPageState extends State<UpdateCustomersPage> {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _addressController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();

  CustomersDAO _customersDAO = CustomersDAO();
  late Customer? customer;

  @override
  void initState() {
    super.initState();
    if (widget.mode == FormMode.Edit) {
      // Fetch customer details using the customer ID
      _fetchCustomerDetails();
    }
  }

  Future<void> _fetchCustomerDetails() async {
    // Fetch customer details using the customer ID
    customer = await _customersDAO.getCustomerById(widget.customerId ?? 0);
    if (customer != null) {
      setState(() {
        _nameController.text = customer!.name;
        _emailController.text = customer!.email ?? "";
        _addressController.text = customer!.address ?? "";
        _phoneController.text = customer!.phone ?? "";
      });
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _addressController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _saveCustomer() {
    String name = _nameController.text;
    String email = _emailController.text;
    String phone = _phoneController.text;
    String address = _addressController.text;

    if (widget.mode == FormMode.Add) {
      // Create a new customer
      Customer newCustomer = Customer(
        name: name,
        email: email,
        phone: phone,
        address: address,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
      _customersDAO.insertCustomer(newCustomer);
    } else {
      // Update existing customer
      Customer updatedCustomer = Customer(
        id: widget.customerId,
        name: name,
        email: email,
        phone: phone,
        address: address,
        createdAt: customer!.createdAt,
        updatedAt: DateTime.now(),
      );
      _customersDAO.updateCustomer(updatedCustomer);
    }

    // Navigate back to the previous page
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            widget.mode == FormMode.Add ? 'Add Customer' : 'Edit Customer'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              keyboardType: TextInputType.name,
              decoration: InputDecoration(labelText: 'Name'),
            ),
            TextField(
              controller: _phoneController,
              maxLength: 10,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(labelText: 'Phone'),
            ),
            TextField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: _addressController,
              maxLength: 50,
              keyboardType: TextInputType.multiline,
              decoration: InputDecoration(labelText: 'Address'),
            ),
            SizedBox(height: 16.0),
            Center(
              child: ElevatedButton(
                onPressed: _saveCustomer,
                child: Text('Save'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
