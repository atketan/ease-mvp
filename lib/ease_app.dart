import 'package:ease_mvp/features/account/presentation/bloc/login_cubit.dart';
import 'package:ease_mvp/features/account/presentation/login_page.dart';
import 'package:ease_mvp/features/home/presentation/home_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
    return BlocProvider(
      create: (context) => LoginCubit(),
      child: MaterialApp(
        title: 'EASE',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          fontFamily: 'Lato',
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
          useMaterial3: true,
          listTileTheme: ListTileThemeData(
            tileColor: Colors.white,
            contentPadding: EdgeInsets.all(8),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          cardTheme: CardTheme(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            color: Colors.white,
            surfaceTintColor: Colors.white,
          ),
        ),
        darkTheme: ThemeData(
          fontFamily: 'Lato',
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.lightGreen),
          useMaterial3: true,
          listTileTheme: ListTileThemeData(
            tileColor: Colors.black,
            contentPadding: EdgeInsets.all(8),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          cardTheme: CardTheme(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            color: Colors.black,
            surfaceTintColor: Colors.black,
          ),
        ),
        home: (_auth.currentUser != null) ? EASEHomePage() : LoginPage(),
      ),
    );
  }
}
