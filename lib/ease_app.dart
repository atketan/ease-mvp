import 'package:ease_mvp/features/account/presentation/login_page.dart';
import 'package:ease_mvp/features/home/presentation/home_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class EASEApp extends StatefulWidget {
  const EASEApp({super.key});

  @override
  State<EASEApp> createState() => _EASEAppState();
}

class _EASEAppState extends State<EASEApp> {
  FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'EASE',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Lato',
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        fontFamily: 'Lato',
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.lightGreen),
        useMaterial3: true,
      ),
      home: (_auth.currentUser != null) ? EASEHomePage() : LoginPage(),
    );
  }
}
