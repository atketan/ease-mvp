import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../models/vendor.dart';
import 'vendors_data_source.dart';

class FirestoreVendorsDAO implements VendorsDataSource {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String userId;

  FirestoreVendorsDAO({required this.userId});

  @override
  Future<String> insertVendor(Vendor vendor) async {
    debugPrint('Inserting vendor: ${vendor.name}');
    final docRef = await _firestore
        .collection('users')
        .doc(userId)
        .collection('vendors')
        .add(vendor.toJSON());
    return docRef.id;
  }

  @override
  Future<List<Vendor>> getAllVendors() async {
    final snapshot = await _firestore
        .collection('users')
        .doc(userId)
        .collection('vendors')
        .get();
    return snapshot.docs.map((doc) {
      Vendor vendor = Vendor.fromJSON(doc.data());
      vendor.id = doc.id;
      return vendor;
    }).toList();
  }

  @override
  Future<int> updateVendor(Vendor vendor) async {
    await _firestore
        .collection('users')
        .doc(userId)
        .collection('vendors')
        .doc(vendor.id)
        .update(vendor.toJSON());
    return 1; // Firestore does not return an update count
  }

  @override
  Future<int> deleteVendor(String vendorId) async {
    await _firestore
        .collection('users')
        .doc(userId)
        .collection('vendors')
        .doc(vendorId)
        .delete();
    return 1; // Firestore does not return a delete count
  }

  @override
  Future<Vendor?> getVendorByPhoneNumber(String phoneNumber) async {
    final snapshot = await _firestore
        .collection('users')
        .doc(userId)
        .collection('vendors')
        .where('phone_number', isEqualTo: phoneNumber)
        .get();
    if (snapshot.docs.isNotEmpty) {
      return Vendor.fromJSON(snapshot.docs.first.data());
    } else {
      return null;
    }
  }

  @override
  Future<Vendor?> getVendorById(String vendorId) async {
    final doc = await _firestore
        .collection('users')
        .doc(userId)
        .collection('vendors')
        .doc(vendorId.toString())
        .get();
    if (doc.exists) {
      return Vendor.fromJSON(doc.data()!);
    } else {
      return null;
    }
  }

  @override
  Future<List<Vendor>> searchVendors(String pattern) async {
    final snapshot = await _firestore
        .collection('users')
        .doc(userId)
        .collection('vendors')
        .where('name', isGreaterThanOrEqualTo: pattern)
        .get();
    return snapshot.docs.map((doc) {
      final vendor = Vendor.fromJSON(doc.data());
      vendor.id = doc.id;
      return vendor;
    }).toList();
  }
}
