import 'package:provider/provider.dart';
import 'package:ease/core/database/customers/customers_dao.dart';
import 'package:ease/core/models/customer.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

enum CustomersFormMode {
  Add,
  Edit,
}

class UpdateCustomersPage extends StatefulWidget {
  final CustomersFormMode mode;
  final String? customerId;

  UpdateCustomersPage({required this.mode, this.customerId = null})
      : assert(mode == CustomersFormMode.Add || customerId != null,
            'customerId cannot be null in Edit mode');

  @override
  _UpdateCustomersPageState createState() => _UpdateCustomersPageState();
}

class _UpdateCustomersPageState extends State<UpdateCustomersPage> {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _addressController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();

  late CustomersDAO _customersDAO;
  late Customer? customer;

  @override
  void initState() {
    super.initState();
    if (widget.mode == CustomersFormMode.Edit) {
      // Fetch customer details using the customer ID
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _fetchCustomerDetails();
      });
    }
  }

  Future<void> _fetchCustomerDetails() async {
    // Fetch customer details using the customer ID
    customer = await _customersDAO.getCustomerById(widget.customerId ?? '');
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

  Future<void> _saveCustomer() async {
    String name = _nameController.text;
    String email = _emailController.text;
    String phone = _phoneController.text;
    String address = _addressController.text;

    try {
      if (widget.mode == CustomersFormMode.Add) {
        Customer newCustomer = Customer(
          name: name,
          email: email,
          phone: phone,
          address: address,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );
        await _customersDAO.insertCustomer(newCustomer);
      } else {
        Customer updatedCustomer = Customer(
          id: widget.customerId,
          name: name,
          email: email,
          phone: phone,
          address: address,
          createdAt: customer!.createdAt,
          updatedAt: DateTime.now(),
        );
        await _customersDAO.updateCustomer(updatedCustomer);
      }
      Navigator.pop(context);
    } on DatabaseException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error adding entity! \n$e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    _customersDAO = Provider.of<CustomersDAO>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.mode == CustomersFormMode.Add
            ? 'Add Customer'
            : 'Edit Customer'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextField(
                controller: _nameController,
                keyboardType: TextInputType.name,
                decoration: InputDecoration(labelText: 'Name'),
              ),
              SizedBox(height: 16.0),
              TextField(
                controller: _phoneController,
                maxLength: 10,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(labelText: 'Phone'),
              ),
              SizedBox(height: 16.0),
              TextField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(labelText: 'Email'),
              ),
              SizedBox(height: 16.0),
              TextField(
                controller: _addressController,
                maxLength: 50,
                keyboardType: TextInputType.multiline,
                decoration: InputDecoration(labelText: 'Address'),
              ),
              SizedBox(height: 24.0),
              Row(
                children: [
                  Expanded(flex: 4, child: Container()),
                  Spacer(flex: 1),
                  Expanded(
                    flex: 4,
                    child: TextButton(
                      onPressed: () => _saveCustomer(),
                      child: Text(
                        'Save',
                        style: TextStyle().copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
