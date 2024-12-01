import 'package:ease/core/database/customers/customers_dao.dart';
import 'package:ease/core/database/inventory/inventory_items_dao.dart';
import 'package:ease/core/database/invoice_items/invoice_items_dao.dart';
import 'package:ease/core/database/invoices/invoices_dao.dart';
import 'package:ease/core/database/payments/payments_dao.dart';
import 'package:ease/core/database/vendors/vendors_dao.dart';
import 'package:ease/core/enums/invoice_type_enum.dart';
import 'package:ease/core/utils/developer_log.dart';
import 'package:ease/ease_app.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ease/features/invoice_manager/bloc/invoice_manager_cubit.dart';
import 'package:ease/features/invoice_manager/presentation/invoice_manager.dart';
import 'package:ease/features/home_invoices/data/invoices_provider.dart';
import 'package:ease/features/home_invoices/presentation/invoices_home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:floating_action_bubble/floating_action_bubble.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_handler/permission_handler.dart';

class EASEHomePage extends StatefulWidget {
  const EASEHomePage({super.key});

  @override
  State<EASEHomePage> createState() => _EASEHomePageState();
}

class _EASEHomePageState extends State<EASEHomePage>
    with SingleTickerProviderStateMixin {
  late Animation<double> _animation;
  late AnimationController _animationController;
  late InvoicesDAO _invoicesDAO;
  late InventoryItemsDAO _inventoryItemsDAO;
  late PaymentsDAO _paymentsDAO;
  late InvoiceItemsDAO _invoiceItemsDAO;
  late CustomersDAO _customersDAO;
  late VendorsDAO _vendorsDAO;

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
      debugLog('Error requesting permissions: $e');
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    _invoicesDAO = Provider.of<InvoicesDAO>(context);
    _inventoryItemsDAO = Provider.of<InventoryItemsDAO>(context);
    _paymentsDAO = Provider.of<PaymentsDAO>(context);
    _invoiceItemsDAO = Provider.of<InvoiceItemsDAO>(context);
    _customersDAO = Provider.of<CustomersDAO>(context);
    _vendorsDAO = Provider.of<VendorsDAO>(context);

    return FutureBuilder<bool>(
      future: _requestPermissions(),
      builder: (context, snapshot) {
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
                content: Text(
                    'Permissions not granted. Please grant the required permissions and restart the app.'),
              ),
            );
          });
        }

        return MultiProvider(
          providers: [
            ChangeNotifierProvider(
                create: (context) => InvoicesProvider(_invoicesDAO)),
            // ChangeNotifierProvider(
            //     create: (context) => DashboardDataProvider()),
          ],
          child: Scaffold(
            body: InvoicesHomePage(),
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
                      Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(builder: (context) => EASEApp()),
                        (Route<dynamic> route) => false,
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
                  bubbleColor:
                      Theme.of(context).colorScheme.surface, // Updated line
                  icon: Icons.settings,
                  titleStyle: TextStyle(
                      fontSize: 16,
                      color: Theme.of(context).colorScheme.primary),
                  onPress: () {
                    _animationController.reverse();
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (BuildContext context) => BlocProvider(
                          create: (context) => InvoiceManagerCubit(
                            _invoicesDAO,
                            _inventoryItemsDAO,
                            _paymentsDAO,
                            _invoiceItemsDAO,
                            _customersDAO,
                            _vendorsDAO,
                            InvoiceType.Sales,
                          ),
                          child: InvoiceManager(
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
                  bubbleColor: Theme.of(context).colorScheme.surface,
                  icon: Icons.people,
                  titleStyle: TextStyle(
                      fontSize: 16,
                      color: Theme.of(context).colorScheme.primary),
                  onPress: () {
                    _animationController.reverse();
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (BuildContext context) => BlocProvider(
                          create: (context) => InvoiceManagerCubit(
                            _invoicesDAO,
                            _inventoryItemsDAO,
                            _paymentsDAO,
                            _invoiceItemsDAO,
                            _customersDAO,
                            _vendorsDAO,
                            InvoiceType.Purchase,
                          ),
                          child: InvoiceManager(
                            invoiceFormMode: InvoiceFormMode.Add,
                          ),
                        ),
                      ),
                    );
                  },
                ),
                //Floating action menu item
                Bubble(
                  title: "Expense",
                  iconColor: Theme.of(context).colorScheme.primary,
                  bubbleColor: Theme.of(context).colorScheme.surface,
                  icon: Icons.home,
                  titleStyle: TextStyle(
                      fontSize: 16,
                      color: Theme.of(context).colorScheme.primary),
                  onPress: () {
                    _animationController.reverse();
                  },
                ),
                Bubble(
                  title: "Payment",
                  iconColor: Theme.of(context).colorScheme.primary,
                  bubbleColor: Theme.of(context).colorScheme.surface,
                  icon: Icons.home,
                  titleStyle: TextStyle(
                      fontSize: 16,
                      color: Theme.of(context).colorScheme.primary),
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
              backGroundColor: Theme.of(context).colorScheme.surface,
            ),
          ),
        );
      },
    );
  }
}
