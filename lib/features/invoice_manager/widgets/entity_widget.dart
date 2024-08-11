import 'package:ease_mvp/core/database/customers_dao.dart';
import 'package:ease_mvp/core/database/vendors_dao.dart';
import 'package:ease_mvp/core/models/invoice.dart';
import 'package:flutter/material.dart';

import '../presentation/invoice_manager.dart';

class EntityWidget extends StatefulWidget {
  final Invoice invoice;
  final InvoiceType invoiceType;

  EntityWidget({
    required this.invoice,
    required this.invoiceType,
  });
  @override
  State<StatefulWidget> createState() {
    return EntityWidgetState();
  }
}

class EntityWidgetState extends State<EntityWidget> {
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
                  widget.invoice.customerId = result.id;
                } else {
                  widget.invoice.vendorId = result.id;
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
              // var result = await showDialog(
              //   context: context,
              //   builder: (BuildContext context) =>
              //       AddEntityDialog(entityType: entityType),
              // );
              // if (result != null) {
              //   close(context, result);
              // }
            },
            child: Text(
                'Add New ${entityType == 'customer' ? 'Customer' : 'Vendor'}'),
          ),
        ],
      ),
    );
  }
}
