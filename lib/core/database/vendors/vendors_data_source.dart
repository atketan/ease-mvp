import 'package:cloud_firestore/cloud_firestore.dart';

import '../../models/vendor.dart';

abstract class VendorsDataSource {
  Future<String> insertVendor(Vendor vendor);
  Future<List<Vendor>> getAllVendors();
  Future<int> updateVendor(Vendor vendor);
  Future<int> deleteVendor(String vendorId);
  Future<Vendor?> getVendorByPhoneNumber(String phoneNumber);
  Future<Vendor?> getVendorById(String vendorId);
  Future<List<Vendor>> searchVendors(String pattern); // Add this line
  Stream<QuerySnapshot<Map<String, dynamic>>> getAllVendorsStream();
}