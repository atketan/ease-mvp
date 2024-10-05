import 'package:flutter/material.dart';

class DashboardHomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return DashboardHomePageState();
  }
}

class DashboardHomePageState extends State<DashboardHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {},
          icon: Icon(Icons.person_4_outlined),
        ),
        title: Text('Dashboard'),
      ),
    );
  }
}
