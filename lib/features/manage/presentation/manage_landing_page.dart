import 'package:flutter/material.dart';

class ReportsLandingPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => ReportsLandingPageState();
}

class ReportsLandingPageState extends State<ReportsLandingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: ListView(
          children: [
            ListTile(
              title: Text("Customers"),
              subtitle: Text("Manage customer details | Sales"),
              trailing: Icon(Icons.arrow_forward_sharp),
            ),
            Divider(),
            ListTile(
              title: Text("Vendors"),
              subtitle: Text("Manage vendor details | Purchases"),
              trailing: Icon(Icons.arrow_forward_sharp),
            ),
            Divider(),
            ListTile(
              title: Text("Items"),
              subtitle: Text("Manage item details | Inventory"),
              trailing: Icon(Icons.arrow_forward_sharp),
            ),
            Divider(),
          ],
        ),
      ),
    );
  }
}
