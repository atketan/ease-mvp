import 'package:ease/features/account/presentation/bloc/login_cubit.dart';
import 'package:ease/features/home/presentation/home_page.dart';
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
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.black,
            primary: Colors.black,
            secondary: Color(0xFF448AFF), // Ink blue
            surface: Colors.white,
            onSurface: Colors.black87,
          ),
          useMaterial3: true,
          appBarTheme: AppBarTheme(
            backgroundColor: Colors.black,
            foregroundColor: Colors.white,
            elevation: 2,
            toolbarHeight: 50.0,
            titleTextStyle: TextStyle(
              fontFamily: 'Lato',
              fontSize: 18,
              color: Colors.white,
            ),
            iconTheme: IconThemeData(color: Color(0xFF448AFF)),
          ),
          tabBarTheme: TabBarTheme(
            labelColor: Colors.white,
            unselectedLabelColor: Colors.grey[600],
          ),
          listTileTheme: ListTileThemeData(
            visualDensity: VisualDensity.compact,
            // tileColor: Colors.white,
            contentPadding: EdgeInsets.all(8),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            iconColor: Color(0xFF448AFF),
            // textColor: Colors.black87,
          ),
          cardTheme: CardTheme(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            // color: Colors.white,
            // surfaceTintColor: Colors.white,
            elevation: 2,
          ),
          textButtonTheme: TextButtonThemeData(
            style: ButtonStyle(
              backgroundColor: WidgetStateProperty.all(Colors.black),
              foregroundColor: WidgetStateProperty.all(Color(0xFF448AFF)),
              shape: WidgetStateProperty.all(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              padding: WidgetStateProperty.all(
                EdgeInsets.symmetric(vertical: 12.0, horizontal: 24.0),
              ),
            ),
          ),
          inputDecorationTheme: InputDecorationTheme(
            border: UnderlineInputBorder(
              borderSide: BorderSide(
                color: Colors.black54,
                width: 1.0,
              ),
            ),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                color: Colors.black54,
                width: 1.0,
              ),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                color: Color(0xFF448AFF),
                width: 2.0,
              ),
            ),
            labelStyle: TextStyle(color: Colors.black87),
            hintStyle: TextStyle(color: Colors.black54),
          ),
          textTheme: TextTheme(
            bodyLarge: TextStyle(color: Colors.black87),
            bodyMedium: TextStyle(color: Colors.black87),
            titleLarge: TextStyle(color: Colors.black),
            titleMedium: TextStyle(color: Colors.black),
            titleSmall: TextStyle(color: Colors.black87),
          ),
          iconTheme: IconThemeData(color: Color(0xFF448AFF)),
        ),
        darkTheme: ThemeData(
          fontFamily: 'Lato',
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.black,
            primary: Colors.white,
            secondary: Color(0xFF82B1FF), // Lighter ink blue for dark theme
            surface: Color(0xFF121212),
            // Remove background: Color(0xFF121212),
            onSurface: Colors.white70,
          ),
          useMaterial3: true,
          appBarTheme: AppBarTheme(
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
            elevation: 2,
            toolbarHeight: 50.0,
            titleTextStyle: TextStyle(
              fontFamily: 'Lato',
              fontSize: 18,
              color: Colors.white,
            ),
            iconTheme: IconThemeData(color: Color(0xFF82B1FF)),
          ),
          tabBarTheme: TabBarTheme(
            labelColor: Colors.black,
            unselectedLabelColor: Colors.grey[400],
          ),
          listTileTheme: ListTileThemeData(
            visualDensity: VisualDensity.compact,
            // tileColor: Color(0xFF1E1E1E),
            contentPadding: EdgeInsets.all(8),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            iconColor: Color(0xFF82B1FF),
            // textColor: Colors.white70,
          ),
          cardTheme: CardTheme(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            // color: Color(0xFF1E1E1E),
            // surfaceTintColor: Color(0xFF1E1E1E),
            elevation: 2,
          ),
          textButtonTheme: TextButtonThemeData(
            style: ButtonStyle(
              backgroundColor: WidgetStateProperty.all(Colors.white),
              foregroundColor: WidgetStateProperty.all(Color(0xFF82B1FF)),
              shape: WidgetStateProperty.all(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              padding: WidgetStateProperty.all(
                EdgeInsets.symmetric(vertical: 12.0, horizontal: 24.0),
              ),
            ),
          ),
          inputDecorationTheme: InputDecorationTheme(
            border: UnderlineInputBorder(
              borderSide: BorderSide(
                color: Colors.white54,
                width: 1.0,
              ),
            ),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                color: Colors.white54,
                width: 1.0,
              ),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                color: Color(0xFF82B1FF),
                width: 2.0,
              ),
            ),
            labelStyle: TextStyle(color: Colors.white70),
            hintStyle: TextStyle(color: Colors.white54),
          ),
          textTheme: TextTheme(
            bodyLarge: TextStyle(color: Colors.white70),
            bodyMedium: TextStyle(color: Colors.white70),
            titleLarge: TextStyle(color: Colors.white),
            titleMedium: TextStyle(color: Colors.white),
            titleSmall: TextStyle(color: Colors.white70),
          ),
          iconTheme: IconThemeData(color: Color(0xFF82B1FF)),
        ),
        home: (_auth.currentUser != null) ? EASEHomePage() : EASEHomePage(),
      ),
    );
  }
}
