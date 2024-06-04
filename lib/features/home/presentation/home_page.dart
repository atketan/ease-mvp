import 'package:ease_mvp/features/account/presentation/login_page.dart';
import 'package:ease_mvp/features/invoices/data_models/invoice_operation.dart';
import 'package:ease_mvp/features/invoices/data_models/invoice_type_enum.dart';
import 'package:ease_mvp/features/invoices/presentation/manage_invoice.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:floating_action_bubble/floating_action_bubble.dart';
import 'package:flutter/material.dart';

class EASEHomePage extends StatefulWidget {
  const EASEHomePage({super.key});

  @override
  State<EASEHomePage> createState() => _EASEHomePageState();
}

class _EASEHomePageState extends State<EASEHomePage>
    with SingleTickerProviderStateMixin {
  int _selectedIndex = 0;
  late Animation<double> _animation;
  late AnimationController _animationController;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 260),
    );

    final curvedAnimation =
        CurvedAnimation(curve: Curves.easeInOut, parent: _animationController);
    _animation = Tween<double>(begin: 0, end: 1).animate(curvedAnimation);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const Center(
        child: Text(
          "Let's get accounting!",
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              child: const Text("EASE"),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            ListTile(
              title: const Text("Settings"),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text("Logout"),
              onTap: () {
                FirebaseAuth.instance.signOut();
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => LoginPage()),
                  (route) => false,
                );
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionBubble(
        items: <Bubble>[
          // Floating action menu item
          Bubble(
            title: "Sale",
            iconColor: Theme.of(context).colorScheme.primary,
            bubbleColor: Theme.of(context).colorScheme.background,
            icon: Icons.settings,
            titleStyle: TextStyle(
                fontSize: 16, color: Theme.of(context).colorScheme.primary),
            onPress: () {
              _animationController.reverse();
              Navigator.push(
                context,
                new MaterialPageRoute(
                  builder: (BuildContext context) => ManageInvoice(
                    invoiceType: InvoiceType.cashSale,
                    invoiceOperation: InvoiceOperation.newInvoice,
                  ),
                  fullscreenDialog: true,
                ),
              );
            },
          ),
          // Floating action menu item
          Bubble(
            title: "Purchase",
            iconColor: Theme.of(context).colorScheme.primary,
            bubbleColor: Theme.of(context).colorScheme.background,
            icon: Icons.people,
            titleStyle: TextStyle(
                fontSize: 16, color: Theme.of(context).colorScheme.primary),
            onPress: () {
              _animationController.reverse();
              Navigator.push(
                context,
                new MaterialPageRoute(
                  builder: (BuildContext context) => ManageInvoice(
                    invoiceType: InvoiceType.cashPurchase,
                    invoiceOperation: InvoiceOperation.newInvoice,
                  ),
                  fullscreenDialog: true,
                ),
              );
            },
          ),
          //Floating action menu item
          Bubble(
            title: "Expense",
            iconColor: Theme.of(context).colorScheme.primary,
            bubbleColor: Theme.of(context).colorScheme.background,
            icon: Icons.home,
            titleStyle: TextStyle(
                fontSize: 16, color: Theme.of(context).colorScheme.primary),
            onPress: () {
              // Navigator.push(context, new MaterialPageRoute(builder: (BuildContext context) => Homepage()));
              _animationController.reverse();
            },
          ),
          Bubble(
            title: "Payment",
            iconColor: Theme.of(context).colorScheme.primary,
            bubbleColor: Theme.of(context).colorScheme.background,
            icon: Icons.home,
            titleStyle: TextStyle(
                fontSize: 16, color: Theme.of(context).colorScheme.primary),
            onPress: () {
              // Navigator.push(context, new MaterialPageRoute(builder: (BuildContext context) => Homepage()));
              _animationController.reverse();
            },
          ),
        ],
        animation: _animation,
        onPress: () => _animationController.isCompleted
            ? _animationController.reverse()
            : _animationController.forward(),
        iconColor: Theme.of(context).colorScheme.primary,
        iconData: Icons.add,
        backGroundColor: Theme.of(context).colorScheme.background,
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Theme.of(context).colorScheme.primary,
        unselectedItemColor: Theme.of(context).colorScheme.secondary,
        enableFeedback: true,
        currentIndex: _selectedIndex,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard_sharp),
            label: "Dashboard",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.inventory_sharp),
            label: "Invoices",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.view_list_sharp),
            label: "Reports",
          ),
        ],
        onTap: (value) => _onItemTapped(value),
      ),
    );
  }
}
