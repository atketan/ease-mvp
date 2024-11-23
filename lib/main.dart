import 'package:ease/core/database/customers/customers_dao.dart';
import 'package:ease/core/database/customers/customers_data_source.dart';
import 'package:ease/core/database/customers/firestore_customers_dao.dart';
import 'package:ease/core/database/database_helper.dart';
import 'package:ease/core/database/expense_categories/expense_categories_dao.dart';
import 'package:ease/core/database/expense_categories/expense_categories_data_source.dart';
import 'package:ease/core/database/expense_categories/firestore_expense_categories_dao.dart';
import 'package:ease/core/database/expenses/expenses_dao.dart';
import 'package:ease/core/database/expenses/expenses_data_source.dart';
import 'package:ease/core/database/expenses/firestore_expenses_dao.dart';
import 'package:ease/core/database/inventory/firestore_inventory_items_dao.dart';
import 'package:ease/core/database/inventory/inventory_items_dao.dart';
import 'package:ease/core/database/inventory/inventory_items_data_source.dart';
import 'package:ease/core/database/invoice_items/firestore_invoice_items_dao.dart';
import 'package:ease/core/database/invoice_items/invoice_items_dao.dart';
import 'package:ease/core/database/invoice_items/invoice_items_data_source.dart';
import 'package:ease/core/database/invoices/firestore_invoices_dao.dart';
import 'package:ease/core/database/invoices/invoices_dao.dart';
import 'package:ease/core/database/invoices/invoices_data_source.dart';
import 'package:ease/core/database/payments/firestore_payments_dao.dart';
import 'package:ease/core/database/payments/payments_dao.dart';
import 'package:ease/core/database/payments/payments_data_source.dart';
import 'package:ease/core/database/vendors/firestore_vendors_dao.dart';
import 'package:ease/core/database/vendors/vendors_dao.dart';
import 'package:ease/core/database/vendors/vendors_data_source.dart';
import 'package:ease/core/utils/developer_log.dart';
import 'package:ease/ease_app.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  try {
    WidgetsFlutterBinding.ensureInitialized();

    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    final dbHelper = DatabaseHelper();
    await dbHelper.database;

    runApp(
      MultiProvider(
        providers: [
          Provider<CustomersDataSource>(
            create: (_) => FirestoreCustomersDAO(), // or SqfliteCustomersDAO()
          ),
          ProxyProvider<CustomersDataSource, CustomersDAO>(
            update: (_, dataSource, __) => CustomersDAO(dataSource),
          ),
          Provider<VendorsDataSource>(
            create: (_) => FirestoreVendorsDAO(), // or SqfliteVendorsDAO()
          ),
          ProxyProvider<VendorsDataSource, VendorsDAO>(
            update: (_, dataSource, __) => VendorsDAO(dataSource),
          ),
          Provider<InventoryItemsDataSource>(
            create: (_) =>
                FirestoreInventoryItemsDAO(), // or SqfliteInventoryItemsDAO()
          ),
          ProxyProvider<InventoryItemsDataSource, InventoryItemsDAO>(
            update: (_, dataSource, __) => InventoryItemsDAO(dataSource),
          ),
          Provider<PaymentsDataSource>(
            create: (_) => FirestorePaymentsDAO(), // or SqflitePaymentsDAO()
          ),
          ProxyProvider<PaymentsDataSource, PaymentsDAO>(
            update: (_, dataSource, __) => PaymentsDAO(dataSource),
          ),
          Provider<InvoiceItemsDataSource>(
            create: (_) =>
                FirestoreInvoiceItemsDAO(), // or SqfliteInvoiceItemsDAO()
          ),
          ProxyProvider<InvoiceItemsDataSource, InvoiceItemsDAO>(
            update: (_, dataSource, __) => InvoiceItemsDAO(dataSource),
          ),
          Provider<InvoicesDataSource>(
            create: (_) => FirestoreInvoicesDAO(), // or SqfliteInvoicesDAO()
          ),
          ProxyProvider<InvoicesDataSource, InvoicesDAO>(
            update: (_, dataSource, __) => InvoicesDAO(dataSource),
          ),
          Provider<ExpensesDataSource>(
            create: (_) => FirestoreExpensesDAO(), // or SqfliteExpensesDAO()
          ),
          ProxyProvider<ExpensesDataSource, ExpensesDAO>(
            update: (_, dataSource, __) => ExpensesDAO(dataSource),
          ),
          Provider<ExpenseCategoriesDataSource>(
            create: (_) =>
                FirestoreExpenseCategoriesDAO(), // or SqfliteExpenseCategoriesDAO()
          ),
          ProxyProvider<ExpenseCategoriesDataSource, ExpenseCategoriesDAO>(
            update: (_, dataSource, __) => ExpenseCategoriesDAO(dataSource),
          ),
        ],
        child: const EASEApp(),
      ),
    );
  } catch (e, stackTrace) {
    debugLog('Error during initialization: $e', name: 'Main');
    debugLog('Stack trace: $stackTrace', name: 'Main');

    runApp(MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Error'),
        ),
        body: Center(
          child: Text(
              'Error during initialization: $e\n\nStack trace: $stackTrace'),
        ),
      ),
    ));
  }
}
