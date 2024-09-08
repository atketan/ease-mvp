import 'package:ease/features/account/presentation/bloc/login_cubit.dart';
// import 'package:ease/features/account/presentation/login_page.dart';
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
            seedColor: Color(0xFF00695C), // Dark teal
            primary: Color(0xFF00695C),
            secondary: Color(0xFF00897B),
            surface: Colors.white,
            surfaceContainer: Color(0xFFF5F5F5),
          ),
          useMaterial3: true,
          appBarTheme: AppBarTheme(
            backgroundColor: Color(0xFF00695C),
            foregroundColor: Colors.white,
            elevation: 2,
            toolbarHeight: 50.0,
            titleTextStyle: TextStyle(
              fontFamily: 'Lato',
              fontSize: 18,
              // fontWeight: FontWeight.bold,
            ),
            iconTheme: IconThemeData(color: Colors.white),
          ),
          tabBarTheme: TabBarTheme(
            labelColor: Colors.white,
            unselectedLabelColor: Colors.grey[400],
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
            elevation: 2,
          ),
          textButtonTheme: TextButtonThemeData(
            style: ButtonStyle(
              backgroundColor: WidgetStateProperty.all(Color(0xFF00897B)),
              foregroundColor: WidgetStateProperty.all(Colors.white),
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
                color: Color(0xFF00897B),
                width: 1.0,
              ),
            ),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                color: Color(0xFF00897B),
                width: 1.0,
              ),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                color: Color(0xFF00695C),
                width: 2.0,
              ),
            ),
          ),
        ),
        darkTheme: ThemeData(
          fontFamily: 'Lato',
          colorScheme: ColorScheme.fromSeed(
            seedColor: Color(0xFF00695C),
            primary: Color(0xFF00897B),
            secondary: Color(0xFF26A69A),
            surface: Color(0xFF121212),
            surfaceContainer: Color(0xFF121212),
          ),
          useMaterial3: true,
          appBarTheme: AppBarTheme(
            backgroundColor: Color(0xFF00695C),
            foregroundColor: Colors.white,
            elevation: 2,
            titleTextStyle: TextStyle(
              fontFamily: 'Lato',
              fontWeight: FontWeight.bold,
            ),
            iconTheme: IconThemeData(color: Colors.white),
          ),
          tabBarTheme: TabBarTheme(
            labelColor: Colors.white,
            unselectedLabelColor: Colors.grey[400],
          ),
          listTileTheme: ListTileThemeData(
            visualDensity: VisualDensity.compact,
            tileColor: Color(0xFF1E1E1E),
            contentPadding: EdgeInsets.all(8),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          cardTheme: CardTheme(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            color: Color(0xFF1E1E1E),
            surfaceTintColor: Color(0xFF1E1E1E),
            elevation: 2,
          ),
          textButtonTheme: TextButtonThemeData(
            style: ButtonStyle(
              backgroundColor: WidgetStateProperty.all(Color(0xFF00897B)),
              foregroundColor: WidgetStateProperty.all(Colors.white),
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
                color: Color(0xFF26A69A),
                width: 1.0,
              ),
            ),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                color: Color(0xFF26A69A),
                width: 1.0,
              ),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                color: Color(0xFF00897B),
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
