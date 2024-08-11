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
          appBarTheme: AppBarTheme(
            backgroundColor: Colors.teal,
            foregroundColor: Colors.white,
          ),
          listTileTheme: ListTileThemeData(
            visualDensity: VisualDensity.compact,
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
          textButtonTheme: TextButtonThemeData(
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(Colors.teal),
              foregroundColor: MaterialStateProperty.all(Colors.white),
              shape: MaterialStateProperty.all(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              padding: MaterialStateProperty.all(
                EdgeInsets.symmetric(vertical: 12.0, horizontal: 24.0),
              ),
            ),
          ),
          inputDecorationTheme: InputDecorationTheme(
            border: OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.teal,
                width: 1.0,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.teal,
                width: 1.0,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.teal,
                width: 2.0,
              ),
            ),
          ),
        ),
        darkTheme: ThemeData(
          fontFamily: 'Lato',
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.lightGreen),
          useMaterial3: true,
          appBarTheme: AppBarTheme(
            backgroundColor: Colors.lightGreen,
            foregroundColor: Colors.black,
          ),
          listTileTheme: ListTileThemeData(
            visualDensity: VisualDensity.compact,
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
          textButtonTheme: TextButtonThemeData(
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(Colors.lightGreen),
              foregroundColor: MaterialStateProperty.all(Colors.black),
              shape: MaterialStateProperty.all(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              padding: MaterialStateProperty.all(
                EdgeInsets.symmetric(vertical: 12.0, horizontal: 24.0),
              ),
            ),
          ),
          inputDecorationTheme: InputDecorationTheme(
            border: OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.lightGreen,
                width: 1.0,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.lightGreen,
                width: 1.0,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.lightGreen,
                width: 2.0,
              ),
            ),
          ),
        ),
        home: (_auth.currentUser != null) ? EASEHomePage() : EASEHomePage(),
      ),
    );
  }
}
