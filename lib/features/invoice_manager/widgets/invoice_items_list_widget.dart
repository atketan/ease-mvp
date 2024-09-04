import 'package:ease/core/models/inventory_item.dart';
import 'package:ease/core/models/invoice_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

import '../bloc/invoice_manager_cubit.dart';
import 'package:ease/core/database/inventory_items_dao.dart'; // Add this import

class InvoiceItemsListWidget extends StatefulWidget {
  InvoiceItemsListWidget({
    Key? key,
  }) : super(key: key);

  @override
  InvoiceItemsListWidgetState createState() => InvoiceItemsListWidgetState();
}

class InvoiceItemsListWidgetState extends State<InvoiceItemsListWidget> {
  late List<InvoiceItem> _invoiceItems;
  final TextEditingController _searchController = TextEditingController();
  final InventoryItemsDAO _inventoryItemsDAO = InventoryItemsDAO();

  @override
  void initState() {
    _invoiceItems = context.read<InvoiceManagerCubit>().invoice.items;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Text(
              //   "Items",
              //   style: Theme.of(context).textTheme.titleLarge!.copyWith(
              //         color: Colors.black,
              //         fontWeight: FontWeight.bold,
              //       ),
              // ),
              // IconButton(
              //   onPressed: () {
              //     Navigator.push(
              //       context,
              //       new MaterialPageRoute(
              //         builder: (BuildContext context) =>
              //             InvoiceItemDelegateWidget(),
              //       ),
              //     ).then(
              //       (invoiceItem) {
              //         debugPrint((invoiceItem as InvoiceItem).name);
              //         setState(() {
              //           _invoiceItems.add(invoiceItem);
              //         });
              //         context
              //             .read<InvoiceManagerCubit>()
              //             .updateInvoiceAmounts();
              //       },
              //     );
              //   },
              //   icon: Icon(
              //     Icons.add_circle_outline,
              //     size: 36,
              //   ),
              // ),
            ],
          ),
          SizedBox(height: 12),
          ListView.builder(
            shrinkWrap: true,
            itemCount: _invoiceItems.length + 1,
            physics: NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              if (index == _invoiceItems.length) {
                return _buildNewItemEntry();
              }
              return _buildExistingItemEntry(_invoiceItems[index], index);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildNewItemEntry() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TypeAheadField<InvoiceItem>(
        builder: (context, controller, focusNode) {
          return TextField(
            controller: controller,
            focusNode: focusNode,
            decoration: InputDecoration(
              hintText: 'Start typing to search or add item...',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              labelText: 'Add item',
            ),
          );
        },
        suggestionsCallback: (pattern) async {
          if (pattern.isEmpty) return [];
          final List<InventoryItem> items = await _inventoryItemsDAO
              .getAllInventoryItemsWhereNameLike(pattern);
          if (items.isEmpty) {
            return [
              InvoiceItem(
                itemId: null,
                name: pattern,
                unitPrice: 0,
                quantity: 1,
                totalPrice: 0,
              )
            ];
          }
          return items
              .map((item) => InvoiceItem(
                    name: item.name,
                    unitPrice: item.unitPrice,
                    quantity: 1,
                    totalPrice: item.unitPrice * 1,
                    itemId: item.itemId,
                  ))
              .toList();
        },
        itemBuilder: (context, suggestion) {
          return ListTile(
            title: Text(suggestion.name),
            subtitle: Text('Price: ${suggestion.unitPrice}'),
          );
        },
        onSelected: (suggestion) {
          // this is wrong logic, as unitPrice can be default set to 0 in any case
          // need a different logic to handle this
          if (suggestion.unitPrice == 0) {
            _addNewItem(suggestion.name);
          } else {
            _addExistingItem(suggestion);
          }
        },
      ),
    );
  }

  Widget _buildExistingItemEntry(InvoiceItem item, int index) {
    return Container(
      padding: const EdgeInsets.only(bottom: 6, top: 6),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Theme.of(context).colorScheme.tertiaryContainer,
            width: 1.0,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.name,
                  softWrap: true,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium!
                      .copyWith(fontWeight: FontWeight.bold),
                ),
                Text(
                  'Unit Price: ${item.unitPrice}',
                  style: Theme.of(context).textTheme.labelSmall,
                ),
              ],
            ),
          ),
          SizedBox(width: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Theme.of(context).colorScheme.primary,
                    width: 1.0,
                  ),
                  borderRadius: BorderRadius.circular(4.0),
                ),
                child: Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.remove),
                      onPressed: () {
                        if (item.quantity == 1) {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                shape: ContinuousRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                    8.0,
                                  ),
                                ),
                                title: Text(
                                  'Confirm Deletion',
                                ),
                                content: Text(
                                  'Are you sure you want to delete this item?',
                                ),
                                actions: [
                                  TextButton(
                                    child: Text('Cancel'),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                  TextButton(
                                    child: Text('Delete'),
                                    onPressed: () {
                                      setState(() {
                                        _invoiceItems.removeAt(index);
                                      });
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                ],
                              );
                            },
                          ).then(
                            (value) => context
                                .read<InvoiceManagerCubit>()
                                .updateInvoiceAmounts(),
                          );
                        }
                        if (item.quantity > 1) {
                          setState(() {
                            item.quantity--;
                            item.totalPrice = item.quantity * item.unitPrice;
                            context
                                .read<InvoiceManagerCubit>()
                                .updateInvoiceAmounts();
                          });
                        }
                      },
                    ),
                    Text(
                      '${item.quantity}',
                      style: TextStyle(fontSize: 18),
                    ),
                    IconButton(
                      icon: Icon(Icons.add),
                      onPressed: () {
                        setState(() {
                          item.quantity++;
                          item.totalPrice = item.quantity * item.unitPrice;
                          context
                              .read<InvoiceManagerCubit>()
                              .updateInvoiceAmounts();
                        });
                      },
                    ),
                  ],
                ),
              ),
              Container(
                width: 64,
                alignment: Alignment.centerRight,
                child: Text(
                  "\₹" + item.totalPrice.toString(),
                ),
              ),
              IconButton(
                icon: Icon(Icons.edit),
                onPressed: () => _showPriceUpdateDialog(item),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _addNewItem(String name) async {
    final newItem = InventoryItem(name: name, unitPrice: 0, unit: '');
    var _itemId = await _inventoryItemsDAO.insertInventoryItem(newItem);
    setState(() {
      _invoiceItems.add(
        InvoiceItem(
          name: name,
          unitPrice: 0,
          quantity: 1,
          totalPrice: 0,
          itemId: _itemId,
        ),
      );
      _searchController.clear();
    });
    context.read<InvoiceManagerCubit>().updateInvoiceAmounts();
  }

  void _addExistingItem(InvoiceItem item) {
    setState(() {
      _invoiceItems.add(item);
      _searchController.clear();
    });
    context.read<InvoiceManagerCubit>().updateInvoiceAmounts();
  }

  void _showPriceUpdateDialog(InvoiceItem item) {
    // Implement a dialog to update the item's price
    // Update the state and call updateInvoiceAmounts() after changing the price
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Update unit price for "${item.name}"',
            style: Theme.of(context).textTheme.titleMedium!.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          content: TextField(
            keyboardType:
                TextInputType.numberWithOptions(decimal: true, signed: false),
            decoration: InputDecoration(
              labelText: 'Current: ${item.unitPrice}',
            ),
            onChanged: (value) {
              item.unitPrice = double.parse(value);
            },
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Update'),
            ),
          ],
        );
      },
    ).then(
      (value) =>
          context.read<InvoiceManagerCubit>().updateInvoiceItemUnitPrice(item),
    );
  }
}
