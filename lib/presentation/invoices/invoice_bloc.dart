import 'package:bloc/bloc.dart';
import 'package:ease/core/database/invoice_items_dao.dart';
import 'package:ease/core/database/invoices_dao.dart';
import 'package:ease/core/models/invoice.dart';
import 'package:ease/core/models/invoice_item.dart';

class InvoiceBloc extends Cubit<Invoice> {
  final InvoicesDAO _invoicesDAO = InvoicesDAO();
  final InvoiceItemsDAO _invoiceItemsDAO = InvoiceItemsDAO();

  InvoiceBloc()
      : super(
          Invoice(
            invoiceNumber: '',
            date: DateTime.now(),
            totalAmount: 0.0,
            discount: 0.0,
            taxes: 0.0,
            grandTotal: 0.0,
            paymentType: 'cash',
            status: 'unpaid',
          ),
        );

  void setCustomer(int customerId) {
    state.customerId = customerId;
    emit(state);
  }

  void setVendor(int vendorId) {
    state.vendorId = vendorId;
    emit(state);
  }

  void setInvoiceNumber(String invoiceNumber) {
    state.invoiceNumber = invoiceNumber;
    emit(state);
  }

  void setDate(DateTime date) {
    state.date = date;
    emit(state);
  }

  void setPaymentType(String paymentType) {
    state.paymentType = paymentType;
    emit(state);
  }

  void setStatus(String status) {
    state.status = status;
    emit(state);
  }

  void addInvoiceItem(InvoiceItem item) {
    print(item.description);
    state.items.add(item);
    state.totalAmount += item.totalPrice;
    emit(state);
  }

  void removeInvoiceItem(InvoiceItem item) {
    state.items.remove(item);
    state.totalAmount -= item.totalPrice;
    emit(state);
  }

  Future<void> saveInvoice() async {
    if (state.id == null) {
      int invoiceId = await _invoicesDAO.insertInvoice(state);
      for (var item in state.items) {
        item.invoiceId = invoiceId;
        await _invoiceItemsDAO.insertInvoiceItem(item);
      }
    } else {
      await _invoicesDAO.updateInvoice(state);
      for (var item in state.items) {
        if (item.id == null) {
          await _invoiceItemsDAO.insertInvoiceItem(item);
        } else {
          await _invoiceItemsDAO.updateInvoiceItem(item);
        }
      }
    }
  }
}
