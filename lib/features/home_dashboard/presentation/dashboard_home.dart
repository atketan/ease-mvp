import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:ease/features/home_dashboard/data/dashboard_data_provider.dart';

class DashboardHomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return DashboardHomePageState();
  }
}

class DashboardHomePageState extends State<DashboardHomePage> {
  @override
  Widget build(BuildContext context) {
    return Consumer<DashboardDataProvider>(
      builder: (context, dashboardDataProvider, child) {
        return Scaffold(
          appBar: AppBar(
            leading: IconButton(
              onPressed: () {},
              icon: Icon(Icons.menu_outlined),
            ),
            title: Text('Dashboard'),
          ),
          body: Column(
            children: [
              
            ],
          ),
        );
      },
    );
  }
}
