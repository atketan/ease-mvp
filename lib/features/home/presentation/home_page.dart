import 'package:ease/features/account/presentation/login_page.dart';
import 'package:ease/features/invoice_manager/bloc/invoice_manager_cubit.dart';
import 'package:ease/features/invoice_manager/presentation/invoice_manager.dart';
import 'package:ease/features/manage/presentation/manage_landing_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:floating_action_bubble/floating_action_bubble.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_handler/permission_handler.dart';

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

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 260),
    );

    final curvedAnimation =
        CurvedAnimation(curve: Curves.easeInOut, parent: _animationController);
    _animation = Tween<double>(begin: 0, end: 1).animate(curvedAnimation);
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Future<bool> _requestPermissions() async {
    try {
      // Request permissions
      final storageStatus = await Permission.storage.request();
      final manageStatus = await Permission.manageExternalStorage.request();

      // Check final statuses
      if (storageStatus.isGranted || manageStatus.isGranted) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      debugPrint('Error requesting permissions: $e');
      return false;
    }
  }

  static List<Widget> _widgetOptions = <Widget>[
    Center(
      child: Text(
        "Let's get accounting!",
      ),
    ),
    Center(
      child: Text(
        'Business Overview',
      ),
    ),
    ManageLandingPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: _requestPermissions(),
      builder: (context, snapshot) {
        debugPrint('snapshot: $snapshot');
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        } else if (snapshot.hasError || !snapshot.data!) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Permissions not granted. Please grant the required permissions and restart the app.'),
              ),
            );
          });
        }

        return Scaffold(
          body: _widgetOptions.elementAt(_selectedIndex),
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
                    MaterialPageRoute(
                      builder: (BuildContext context) => BlocProvider(
                        create: (context) => InvoiceManagerCubit(),
                        child: InvoiceManager(
                          invoiceType: InvoiceType.Sales,
                          invoiceFormMode: InvoiceFormMode.Add,
                        ),
                      ),
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
                      builder: (BuildContext context) => InvoiceManager(
                        invoiceType: InvoiceType.Purchase,
                        invoiceFormMode: InvoiceFormMode.Add,
                      ),
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
                label: "Manage",
              ),
            ],
            onTap: (value) => _onItemTapped(value),
          ),
        );
      },
    );
  }
}
