import 'package:bloc/bloc.dart';
import 'package:ease_mvp/core/models/invoice.dart';
import 'package:ease_mvp/core/models/invoice_item.dart';

import 'invoice_manager_cubit_state.dart';

class InvoiceManagerCubit extends Cubit<InvoiceManagerCubitState> {
  InvoiceManagerCubit() : super(InvoiceManagerInitial());

  late Invoice _invoice;

  // late Customer _customer;
  // late Vendor _vendor;

  // late double _totalAmount;
  // late double _taxes;
  // late double _discounts;
  // double _grandTotal = 0.0;

  // final _itemsDAO = InventoryItemsDAO();
  // final _invoiceDAO = InvoicesDAO();
  // final _invoiceItemsDAO = InvoiceItemsDAO();

  void initialiseInvoiceModelInstance(Invoice invoice) {
    print("Initialising invoice model instance");
    _invoice = invoice;
    emit(InvoiceManagerLoaded());
  }

  void addInvoiceIteam(InvoiceItem invoiceItem) {
    _invoice.items.add(invoiceItem);
    emit(InvoiceManagerLoaded());
  }

  void removeInvoiceItem(int invoiceItemIndex) {
    _invoice.items.removeAt(invoiceItemIndex);
    emit(InvoiceManagerLoaded());
  }

  Invoice get invoice => _invoice;

  void setCustomerId(int customerId) {
    _invoice.customerId = customerId;
  }

  void setVendorId(int vendorId) {
    _invoice.vendorId = vendorId;
  }

  // void addInvoice(Invoice invoice) {
  //   _invoices.add(invoice);
  //   emit(InvoiceManagerLoaded(_invoices));
  // }

  // void removeInvoice(Invoice invoice) {
  //   _invoices.remove(invoice);
  //   emit(InvoiceManagerLoaded(_invoices));
  // }

  // void updateInvoice(Invoice invoice) {
  //   final index = _invoices.indexWhere((element) => element.id == invoice.id);
  //   _invoices[index] = invoice;
  //   emit(InvoiceManagerLoaded(_invoices));
  // }
}
