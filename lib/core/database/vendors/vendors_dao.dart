import 'package:cloud_firestore/cloud_firestore.dart';

import '../../models/vendor.dart';
import 'vendors_data_source.dart';

class VendorsDAO {
  final VendorsDataSource _dataSource;

  VendorsDAO(this._dataSource);

  Future<String> insertVendor(Vendor vendor) {
    return _dataSource.insertVendor(vendor);
  }

  Future<List<Vendor>> getAllVendors() {
    return _dataSource.getAllVendors();
  }

  Future<int> updateVendor(Vendor vendor) {
    return _dataSource.updateVendor(vendor);
  }

  Future<int> deleteVendor(String vendorId) {
    return _dataSource.deleteVendor(vendorId);
  }

  Future<Vendor?> getVendorByPhoneNumber(String phoneNumber) {
    return _dataSource.getVendorByPhoneNumber(phoneNumber);
  }

  Future<Vendor?> getVendorById(String vendorId) {
    return _dataSource.getVendorById(vendorId);
  }

  Future<List<Vendor>> searchVendors(String pattern) {
    return _dataSource.searchVendors(pattern);
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getAllVendorsStream() {
    return _dataSource.getAllVendorsStream();
  }
}
