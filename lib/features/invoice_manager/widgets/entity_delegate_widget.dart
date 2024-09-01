import 'package:ease/core/database/customers_dao.dart';
import 'package:ease/core/database/vendors_dao.dart';
import 'package:ease/features/customers/presentation/update_customers_page.dart';
import 'package:ease/features/invoice_manager/bloc/invoice_manager_cubit.dart';
import 'package:ease/features/vendors/presentation/update_vendors_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../presentation/invoice_manager.dart';

class EntityDelegateWidget extends StatefulWidget {
  final InvoiceType invoiceType;

  EntityDelegateWidget({
    required this.invoiceType,
  });
  @override
  State<StatefulWidget> createState() {
    return EntityDelegateWidgetState();
  }
}

class EntityDelegateWidgetState extends State<EntityDelegateWidget> {
  TextEditingController _entityController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Text(
          //   (widget.invoiceType == InvoiceType.Sales ? 'Customer' : 'Vendor'),
          //   style: Theme.of(context).textTheme.titleMedium,
          // ),
          TextField(
            controller: _entityController,
            readOnly: true,
            onTap: () async {
              var result = await showSearch(
                context: context,
                delegate: EntitySearchDelegate(
                    (widget.invoiceType == InvoiceType.Sales)
                        ? 'customer'
                        : 'vendor'),
              );
              if (result != null) {
                _entityController.text = result.name;
                if (widget.invoiceType == InvoiceType.Sales) {
                  context.read<InvoiceManagerCubit>().setCustomerId(result.id);
                } else {
                  context.read<InvoiceManagerCubit>().setVendorId(result.id);
                }
              }
            },
            decoration: InputDecoration(
              hintText: 'Select ' +
                  (widget.invoiceType == InvoiceType.Sales
                      ? 'Customer'
                      : 'Vendor'),
              labelText: (widget.invoiceType == InvoiceType.Sales
                  ? 'Customer'
                  : 'Vendor'),
            ),
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ],
      ),
    );
  }
}

class EntitySearchDelegate extends SearchDelegate {
  final String entityType;

  EntitySearchDelegate(this.entityType);

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [IconButton(icon: Icon(Icons.clear), onPressed: () => query = '')];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () => close(context, null),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return FutureBuilder(
      future: entityType == 'customer'
          ? CustomersDAO().getAllCustomers()
          : VendorsDAO().getAllVendors(),
      builder: (context, snapshot) {
        print(snapshot.connectionState.name);
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          print(snapshot.error.toString());
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        if (!snapshot.hasData || (snapshot.data as List).isEmpty) {
          return _buildNoResultsView(context);
        }
        var entities = snapshot.data as List;
        var filteredEntities =
            entities.where((entity) => entity.name.contains(query)).toList();
        if (filteredEntities.isEmpty) {
          return _buildNoResultsView(context);
        }
        return ListView.builder(
          itemCount: filteredEntities.length,
          itemBuilder: (context, index) {
            var entity = filteredEntities[index];
            return ListTile(
              title: Text(entity.name),
              onTap: () => close(context, entity),
            );
          },
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return buildResults(context);
  }

  Widget _buildNoResultsView(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('No Results Found'),
          ElevatedButton(
            onPressed: () async {
              var result;
              if (entityType == 'customer') {
                result=await Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => UpdateCustomersPage(
                      mode: CustomersFormMode.Add,
                    ),
                  ),
                );
              } else {
                result=await Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => UpdateVendorsPage(
                      mode: VendorsFormMode.Add,
                    ),
                  ),
                );
              }
              if (result != null) {
                close(context, result);
              }
            },
            child: Text(
                'Add New ${entityType == 'customer' ? 'Customer' : 'Vendor'}'),
          ),
        ],
      ),
    );
  }
}
