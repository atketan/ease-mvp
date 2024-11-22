
import 'package:ease/core/database/customers/customers_dao.dart';
import 'package:ease/core/database/customers/firestore_customers_dao.dart';
import 'package:ease/core/database/database_helper.dart';
import 'package:ease/core/database/inventory/firestore_inventory_items_dao.dart';
import 'package:ease/core/database/inventory/inventory_items_dao.dart';
import 'package:ease/core/database/vendors/firestore_vendors_dao.dart';
import 'package:ease/core/database/vendors/vendors_dao.dart';
import 'package:ease/core/utils/developer_log.dart';
import 'package:ease/ease_app.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  try {
    WidgetsFlutterBinding.ensureInitialized();

    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    final dbHelper = DatabaseHelper();
    await dbHelper.database;

    runApp(
      MultiProvider(
        providers: [
          Provider<CustomersDAO>(
            create: (_) => CustomersDAO(FirestoreCustomersDAO()),
          ),
          Provider<VendorsDAO>(
            create: (_) => VendorsDAO(FirestoreVendorsDAO()),
          ),
          Provider<InventoryItemsDAO>(
            create: (_) => InventoryItemsDAO(FirestoreInventoryItemsDAO()),
          ),
        ],
        child: const EASEApp(),
      ),
    );
  } catch (e, stackTrace) {
    debugLog('Error during initialization: $e', name: 'Main');
    debugLog('Stack trace: $stackTrace', name: 'Main');

    runApp(MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Error'),
        ),
        body: Center(
          child: Text(
              'Error during initialization: $e\n\nStack trace: $stackTrace'),
        ),
      ),
    ));
  }
}
