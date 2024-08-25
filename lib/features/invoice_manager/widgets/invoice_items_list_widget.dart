import 'package:ease_mvp/core/models/invoice_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/invoice_manager_cubit.dart';
import 'invoice_item_delegate_widget.dart';

class InvoiceItemsListWidget extends StatefulWidget {
  InvoiceItemsListWidget({
    Key? key,
  }) : super(key: key);

  @override
  InvoiceItemsListWidgetState createState() => InvoiceItemsListWidgetState();
}

class InvoiceItemsListWidgetState extends State<InvoiceItemsListWidget> {
  late List<InvoiceItem> _invoiceItems;

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
              Text(
                "Items",
                style: Theme.of(context).textTheme.titleLarge!.copyWith(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
              ),
              IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    new MaterialPageRoute(
                      builder: (BuildContext context) =>
                          InvoiceItemDelegateWidget(),
                    ),
                  ).then(
                    (invoiceItem) {
                      debugPrint((invoiceItem as InvoiceItem).name);
                      setState(() {
                        _invoiceItems.add(invoiceItem);
                      });
                      context
                          .read<InvoiceManagerCubit>()
                          .updateInvoiceAmounts();
                    },
                  );
                },
                icon: Icon(
                  Icons.add_circle_outline,
                  size: 36,
                ),
              ),
            ],
          ),
          SizedBox(height: 12),
          ListView.builder(
            shrinkWrap: true,
            itemCount: _invoiceItems.length,
            physics: NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              final item = _invoiceItems[index];
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
                            style: Theme.of(context).textTheme.titleSmall,
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
                                      item.totalPrice =
                                          item.quantity * item.unitPrice;
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
                                    item.totalPrice =
                                        item.quantity * item.unitPrice;
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
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
