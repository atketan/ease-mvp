import 'package:bloc/bloc.dart';
import 'package:ease_mvp/core/models/invoice.dart';

import 'invoice_manager_cubit_state.dart';

class InvoiceManagerCubit extends Cubit<InvoiceManagerCubitState> {
  InvoiceManagerCubit() : super(InvoiceManagerInitial());

  late Invoice _invoice;

  void initialiseInvoice(Invoice invoice) {
    _invoice = invoice;
  }

  Invoice get invoice => _invoice;

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
