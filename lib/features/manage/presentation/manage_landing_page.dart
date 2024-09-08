import 'package:ease/features/customers/presentation/customers_page.dart';
import 'package:ease/features/items/presentation/items_page.dart';
import 'package:ease/features/vendors/presentation/vendors_page.dart';
import 'package:flutter/material.dart';

class ManageLandingPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => ManageLandingPageState();
}

class ManageLandingPageState extends State<ManageLandingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Manage"),
        leading: IconButton(
          onPressed: () {},
          icon: Icon(Icons.person_4_outlined),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: ListView(
          children: [
            ListTile(
              title: Text("Customers"),
              subtitle: Text("Manage customer details | Sales"),
              trailing: Icon(Icons.arrow_forward_sharp),
              onTap: () async {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => CustomersPage(),
                  ),
                );
              },
            ),
            Divider(),
            ListTile(
              title: Text("Vendors"),
              subtitle: Text("Manage vendor details | Purchases"),
              trailing: Icon(Icons.arrow_forward_sharp),
              onTap: () async {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => VendorsPage(),
                  ),
                );
              },
            ),
            Divider(),
            ListTile(
              title: Text("Items"),
              subtitle: Text("Manage item details | Inventory"),
              trailing: Icon(Icons.arrow_forward_sharp),
              onTap: () async {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => ItemsPage(),
                  ),
                );
              },
            ),
            Divider(),
          ],
        ),
      ),
    );
  }
}
