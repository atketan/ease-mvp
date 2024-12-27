import 'package:ease/core/database/app_user_configuration/firestore_app_user_configuration_dao.dart';
import 'package:ease/core/models/app_user_configuration.dart';
import 'package:ease/core/providers/themes_provider.dart';
import 'package:ease/core/service_locator/service_locator.dart';
import 'package:ease/core/utils/developer_log.dart';
import 'package:ease/features/account/presentation/bloc/login_cubit.dart';
import 'package:ease/features/account/presentation/email_login_page.dart';
import 'package:ease/features/expense_categories/providers/expense_category_provider.dart';
import 'package:ease/features/expenses/providers/expense_provider.dart';
import 'package:ease/features/home/presentation/home_page.dart';
import 'package:ease/core/database/customers/customers_dao.dart';
import 'package:ease/core/database/customers/customers_data_source.dart';
import 'package:ease/core/database/customers/firestore_customers_dao.dart';
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

import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EASEApp extends StatefulWidget {
  const EASEApp({super.key});

  @override
  State<EASEApp> createState() => _EASEAppState();
}

class _EASEAppState extends State<EASEApp> {
  @override
  void initState() {
    super.initState();
    registerDAOs();
    registerProviders();
    registerDataSources();
  }

  Future<String?> fetchUserId() async {
    final user = await FirebaseAuth.instance.currentUser;
    await populateAppUserConfiguration();
    return user?.uid;
  }

  Future<AppUserConfiguration?> populateAppUserConfiguration() async {
    final appUserConfiguration = await getIt<FirestoreAppUserConfigurationDAO>()
        .getAppUserConfiguration(FirebaseAuth.instance.currentUser!.uid);
    debugLog(
        'AppUserConfiguration: ${appUserConfiguration?.toJson().toString()}',
        name: 'EASEApp');
    if (appUserConfiguration != null) {
      getIt<AppUserConfiguration>().enterpriseId =
          appUserConfiguration.enterpriseId;
    }
    return appUserConfiguration;
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LoginCubit(),
      child: FutureProvider<String?>(
        create: (_) => fetchUserId(),
        initialData: null,
        child: Consumer<String?>(builder: (context, userId, child) {
          if (userId == null) {
            return MaterialApp(
              title: 'EASE',
              debugShowCheckedModeBanner: false,
              theme: AppTheme.lightTheme,
              darkTheme: AppTheme.darkTheme,
              home: EmailLoginPage(),
            );
          }

          return MultiProvider(
            providers: [
              Provider<CustomersDataSource>(
                create: (_) => FirestoreCustomersDAO(
                  userId: userId,
                ), // or SqfliteCustomersDAO()
              ),
              ProxyProvider<CustomersDataSource, CustomersDAO>(
                update: (_, dataSource, __) => CustomersDAO(dataSource),
              ),
              Provider<VendorsDataSource>(
                create: (_) => FirestoreVendorsDAO(
                  userId: userId,
                ), // or SqfliteVendorsDAO()
              ),
              ProxyProvider<VendorsDataSource, VendorsDAO>(
                update: (_, dataSource, __) => VendorsDAO(dataSource),
              ),
              Provider<InvoiceItemsDataSource>(
                create: (_) => FirestoreInvoiceItemsDAO(
                  userId: userId,
                ), // or SqfliteInvoiceItemsDAO()
              ),
              ProxyProvider<InvoiceItemsDataSource, InvoiceItemsDAO>(
                update: (_, dataSource, __) => InvoiceItemsDAO(dataSource),
              ),
              Provider<InvoicesDataSource>(
                create: (_) => FirestoreInvoicesDAO(
                  userId: userId,
                ), // or SqfliteInvoicesDAO()
              ),
              ProxyProvider<InvoicesDataSource, InvoicesDAO>(
                update: (_, dataSource, __) => InvoicesDAO(dataSource),
              ),
              Provider<PaymentsDataSource>(
                create: (_) => FirestorePaymentsDAO(
                  userId: userId,
                ), // or SqflitePaymentsDAO()
              ),
              ProxyProvider<PaymentsDataSource, PaymentsDAO>(
                update: (_, dataSource, __) => PaymentsDAO(dataSource),
              ),
              Provider<ExpenseCategoriesDataSource>(
                create: (_) => FirestoreExpenseCategoriesDAO(
                  userId: userId,
                ), // or SqfliteExpenseCategoriesDAO()
              ),
              ProxyProvider<ExpenseCategoriesDataSource, ExpenseCategoriesDAO>(
                update: (_, dataSource, __) => ExpenseCategoriesDAO(dataSource),
              ),
              Provider<ExpensesDataSource>(
                create: (_) => FirestoreExpensesDAO(
                  userId: userId,
                ), // or SqfliteExpensesDAO()
              ),
              ProxyProvider<ExpensesDataSource, ExpensesDAO>(
                update: (_, dataSource, __) => ExpensesDAO(dataSource),
              ),
              Provider<InventoryItemsDataSource>(
                create: (_) => FirestoreInventoryItemsDAO(
                  userId: userId,
                ), // or SqfliteInventoryItemsDAO()
              ),
              ProxyProvider<InventoryItemsDataSource, InventoryItemsDAO>(
                update: (_, dataSource, __) => InventoryItemsDAO(dataSource),
              ),
              ChangeNotifierProvider(
                create: (context) => ExpensesProvider(
                  FirestoreExpensesDAO(userId: userId),
                  FirestorePaymentsDAO(userId: userId),
                ),
              ),
              ChangeNotifierProvider(
                create: (context) => ExpenseCategoryProvider(
                  FirestoreExpenseCategoriesDAO(userId: userId),
                ),
              ),
            ],
            child: MaterialApp(
              title: 'EASE',
              debugShowCheckedModeBanner: false,
              theme: AppTheme.lightTheme,
              darkTheme: AppTheme.darkTheme,
              home: EASEHomePage(),
            ),
          );
        }),
      ),
    );
  }
}
