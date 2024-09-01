import 'package:ease/core/database/database_helper.dart';
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

    final dbHelper = DatabaseHelper();
    await dbHelper.database;
    

    runApp(const EASEApp());
    
  } catch (e, stackTrace) {
    debugPrint('Error during initialization: $e');
    debugPrint('Stack trace: $stackTrace');
    
    runApp(MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Error'),
        ),
        body: Center(
          child: Text('Error during initialization: $e\n\nStack trace: $stackTrace'),
        ),
      ),
    ));
  }
}
