import 'package:flutter/material.dart';

class EASEHomePage extends StatefulWidget {
  const EASEHomePage({super.key});

  @override
  State<EASEHomePage> createState() => _EASEHomePageState();
}

class _EASEHomePageState extends State<EASEHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("EASE Home Page"),
      ),
      body: const Center(
        child: Text(
          'Welcome to EASE',
        ),
      ),
    );
  }
}
