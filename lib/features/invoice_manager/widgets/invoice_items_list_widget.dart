import 'package:flutter/material.dart';

import 'invoice_items_list_widget_data_table.dart';
import 'invoice_items_list_widget_search_box.dart'; // Add this import

class InvoiceItemsListWidget extends StatelessWidget {
  final LayoutType layoutType;

  const InvoiceItemsListWidget({Key? key, required this.layoutType})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    switch (layoutType) {
      case LayoutType.searchBox:
        return InvoiceItemsListWidgetSearchBox();
      case LayoutType.dataTable:
        return InvoiceItemsListWidgetDataTable();
    }
  }

  static Widget searchBoxLayout() {
    return InvoiceItemsListWidget(layoutType: LayoutType.searchBox);
  }

  static Widget dataTableLayout() {
    return InvoiceItemsListWidget(layoutType: LayoutType.dataTable);
  }
}

enum LayoutType { searchBox, dataTable }
