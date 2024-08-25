import 'package:ease_mvp/core/database/vendors_dao.dart';
import 'package:ease_mvp/core/models/vendor.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

enum VendorsFormMode {
  Add,
  Edit,
}

class UpdateVendorsPage extends StatefulWidget {
  final VendorsFormMode mode;
  final int? vendorId;

  const UpdateVendorsPage({super.key, required this.mode, this.vendorId})
      : assert(mode == VendorsFormMode.Add || vendorId != null,
            'vendorId cannot be null in Edit mode');

  @override
  _UpdateVendorsPageState createState() => _UpdateVendorsPageState();
}

class _UpdateVendorsPageState extends State<UpdateVendorsPage> {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _addressController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();

  VendorsDAO _vendorsDAO = VendorsDAO();
  late Vendor? vendor;

  @override
  void initState() {
    super.initState();
    if (widget.mode == VendorsFormMode.Edit) {
      // Fetch vendor details using the vendor ID
      _fetchVendorDetails();
    }
  }

  Future<void> _fetchVendorDetails() async {
    // Fetch vendor details using the vendor ID
    vendor = await _vendorsDAO.getVendorById(widget.vendorId ?? 0);
    if (vendor != null) {
      setState(() {
        _nameController.text = vendor!.name;
        _emailController.text = vendor!.email ?? "";
        _addressController.text = vendor!.address ?? "";
        _phoneController.text = vendor!.phone ?? "";
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

  void _saveVendor() {
    String name = _nameController.text;
    String email = _emailController.text;
    String phone = _phoneController.text;
    String address = _addressController.text;

    if (widget.mode == VendorsFormMode.Add) {
      // Create a new vendor
      Vendor newVendor = Vendor(
        name: name,
        email: email,
        phone: phone,
        address: address,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
      _vendorsDAO.insertVendor(newVendor);
    } else {
      // Update existing vendor
      Vendor updatedVendor = Vendor(
        id: widget.vendorId,
        name: name,
        email: email,
        phone: phone,
        address: address,
        createdAt: vendor!.createdAt,
        updatedAt: DateTime.now(),
      );
      _vendorsDAO.updateVendor(updatedVendor);
    }

    // Navigate back to the previous page
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            widget.mode == VendorsFormMode.Add ? 'Add Vendor' : 'Edit Vendor'),
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
                    onPressed: () => _saveVendor,
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
    );
  }
}
