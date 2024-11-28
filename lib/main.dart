import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ease/core/database/database_helper.dart';
import 'package:ease/core/utils/developer_log.dart';
import 'package:ease/ease_app.dart';
import 'package:flutter/material.dart';

import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  try {
    WidgetsFlutterBinding.ensureInitialized();

    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    // Enable Firestore offline support
    FirebaseFirestore.instance.settings = const Settings(
      persistenceEnabled: true,
    );

    final dbHelper = DatabaseHelper();
    await dbHelper.database;

    runApp(const EASEApp());
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
