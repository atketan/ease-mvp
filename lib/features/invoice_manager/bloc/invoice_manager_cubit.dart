import 'package:bloc/bloc.dart';
import 'package:ease_mvp/core/database/invoice_items_dao.dart';
import 'package:ease_mvp/core/database/invoices_dao.dart';
import 'package:ease_mvp/core/database/payments_dao.dart';
import 'package:ease_mvp/core/models/invoice.dart';
import 'package:ease_mvp/core/models/invoice_item.dart';
import 'package:ease_mvp/core/models/payment.dart';

import 'invoice_manager_cubit_state.dart';

class InvoiceManagerCubit extends Cubit<InvoiceManagerCubitState> {
  InvoiceManagerCubit() : super(InvoiceManagerInitial());

  InvoicesDAO _invoiceDAO = InvoicesDAO();
  InvoiceItemsDAO _invoiceItemsDAO = InvoiceItemsDAO();
  PaymentsDAO _paymentsDAO = PaymentsDAO();

  late Invoice _invoice;

  void initialiseInvoiceModelInstance(Invoice invoice) {
    _invoice = invoice;
    emit(InvoiceManagerLoaded());
  }

  void addInvoiceIteam(InvoiceItem invoiceItem) {
    _invoice.items.add(invoiceItem);
    _updateInvoiceAmounts();
    emit(InvoiceManagerLoaded());
  }

  void removeInvoiceItem(int invoiceItemIndex) {
    _invoice.items.removeAt(invoiceItemIndex);
    _updateInvoiceAmounts();
    emit(InvoiceManagerLoaded());
  }

  Invoice get invoice => _invoice;

  void setCustomerId(int customerId) {
    _invoice.customerId = customerId;
  }

  void setVendorId(int vendorId) {
    _invoice.vendorId = vendorId;
  }

  void setDiscount(double discount) async {
    _invoice.discount = discount;
    await _updateInvoiceAmounts();
    emit(InvoiceManagerLoaded());
  }

  void updateInvoiceAmounts() async {
    await _updateInvoiceAmounts();
    emit(InvoiceManagerLoaded());
  }

  Future<bool> _updateInvoiceAmounts() {
    _invoice.totalAmount = _invoice.items.fold(
        0.0, (previousValue, element) => previousValue + element.totalPrice);
    _invoice.grandTotal = _invoice.totalAmount - _invoice.discount;
    return Future.value(true);
  }

  void updateStatus(String paymentStatus) {
    _invoice.status = paymentStatus;
    emit(InvoiceManagerLoaded());
  }

  void updatePaymentType(String paymentType) {
    _invoice.paymentType = paymentType;
    emit(InvoiceManagerLoaded());
  }

  Future<bool> saveInvoice() async {
    int invoiceId = await _invoiceDAO.insertInvoice(_invoice);

    _invoice.items.forEach((element) async {
      element.invoiceId = invoiceId;
      await _invoiceItemsDAO.insertInvoiceItem(element);
    });

    await _paymentsDAO.insertPayment(
      Payment(
        invoiceId: invoiceId,
        amount: _invoice.grandTotal,
        paymentDate: _invoice.date,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        // using below paymentMethod field to simplify the MVP - this will act as a payment status field for time being
        paymentMethod: _invoice.status,
      ),
    );

    return Future.value(true);
  }
}
