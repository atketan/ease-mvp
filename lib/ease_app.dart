import 'package:ease/core/providers/themes_provider.dart';
import 'package:ease/features/account/presentation/bloc/login_cubit.dart';
import 'package:ease/features/account/presentation/login_page.dart';
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
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,        
        home: (_auth.currentUser != null) ? EASEHomePage() : LoginPage(),
      ),
    );
  }
}
