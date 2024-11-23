import 'package:bloc/bloc.dart';
import 'package:ease/core/database/inventory/inventory_items_dao.dart';
import 'package:ease/core/database/invoice_items/invoice_items_dao.dart';
import 'package:ease/core/database/invoices/invoices_dao.dart';
import 'package:ease/core/database/payments/payments_dao.dart';
import 'package:ease/core/enums/payment_type_enum.dart';
import 'package:ease/core/models/inventory_item.dart';
import 'package:ease/core/models/invoice.dart';
import 'package:ease/core/models/invoice_item.dart';
import 'package:ease/core/models/payment.dart';
import 'package:ease/core/utils/date_time_utils.dart';
import 'package:ease/core/utils/developer_log.dart';

import 'invoice_manager_cubit_state.dart';

class InvoiceManagerCubit extends Cubit<InvoiceManagerCubitState> {
  InvoiceManagerCubit(this._invoiceDAO, this._inventoryItemsDAO,
      this._paymentsDAO, this._invoiceItemsDAO)
      : super(InvoiceManagerInitial());

  final InvoicesDAO _invoiceDAO;
  final InventoryItemsDAO _inventoryItemsDAO;
  final InvoiceItemsDAO _invoiceItemsDAO;
  final PaymentsDAO _paymentsDAO;

  late Invoice _invoice;

  void initialiseInvoiceModelInstance(Invoice? invoice, String invoiceNumber) {
    if (invoice == null) {
      _invoice = Invoice(
        customerId: '',
        name: '',
        invoiceNumber: invoiceNumber,
        date: DateTime.now(),
        totalAmount: 0.0,
        discount: 0.0,
        taxes: 0.0,
        grandTotal: 0.0,
        paymentType: 'cash',
        status: 'unpaid',
        notes: "",
      );
    } else {
      _invoice = invoice;
    }
    emit(InvoiceManagerLoaded(invoice: _invoice));
  }

  void populateInvoiceData() {
    debugLog(_invoice.toJSON().toString(), name: 'InvoiceManagerCubit');
    _getAllInvoiceItems(_invoice.invoiceId);
  }

  void _getAllInvoiceItems(String? invoiceId) async {
    if (invoiceId == null) return;
    _invoice.items =
        await _invoiceItemsDAO.getInvoiceItemsByInvoiceId(invoiceId);

    updateInvoiceAmounts();

    _invoice.items.forEach((item) {
      debugLog('Invoice Item: ${item.toJSON()}', name: 'InvoiceManagerCubit');
    });

    emit(InvoiceManagerLoaded(invoice: _invoice));
  }

  void addInvoiceIteam(InvoiceItem invoiceItem) {
    _invoice.items.add(invoiceItem);
    _updateInvoiceAmounts();
    emit(InvoiceManagerLoaded(invoice: _invoice));
  }

  void removeInvoiceItem(int invoiceItemIndex) {
    _invoice.items.removeAt(invoiceItemIndex);
    _updateInvoiceAmounts();
    emit(InvoiceManagerLoaded(invoice: _invoice));
  }

  Invoice get invoice => _invoice;

  void setCustomerId(String customerId) {
    _invoice.customerId = customerId;
    emit(InvoiceManagerLoaded(invoice: _invoice));
  }

  void setVendorId(String vendorId) {
    _invoice.vendorId = vendorId;
    emit(InvoiceManagerLoaded(invoice: _invoice));
  }

  void setDiscount(double discount) async {
    _invoice.discount = discount;
    await _updateInvoiceAmounts();
    emit(InvoiceManagerLoaded(invoice: _invoice));
  }

  void updateInvoiceAmounts() async {
    await _updateInvoiceAmounts();
    emit(InvoiceManagerLoaded(invoice: _invoice));
  }

  Future<bool> _updateInvoiceAmounts() async {
    _invoice.totalAmount = _invoice.items.fold(
        0.0, (previousValue, element) => previousValue + element.totalPrice);
    _invoice.grandTotal = _invoice.totalAmount - _invoice.discount;
    return Future.value(true);
  }

  void updateStatus(String paymentStatus) {
    _invoice.status = paymentStatus;
    emit(InvoiceManagerLoaded(invoice: _invoice));
  }

  void updatePaymentType(String paymentType) {
    _invoice.paymentType = paymentType;
    emit(InvoiceManagerLoaded(invoice: _invoice));
  }

  Future<bool> saveInvoice() async {
    int invoiceId = await _invoiceDAO.insertInvoice(_invoice);

    _invoice.items.forEach((element) async {
      element.invoiceId = invoiceId;
      await _invoiceItemsDAO.insertInvoiceItem(element);
    });

    await _paymentsDAO.insertPayment(
      Payment(
        invoiceId: invoiceId
            .toString(), // TODO: temporary fix for int to String issue, fix the code by removing toString() for it to be correct
        amount: _invoice.grandTotal,
        paymentDate: _invoice.date,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        // using below paymentMethod field to simplify the MVP - this will act as a payment status field for time being
        paymentMethod: _invoice.status,
        paymentType: PaymentType
            .credit, // TODO: this cannot be a default setting for each payment, check for conditions and fix it
      ),
    );

    return Future.value(true);
  }

  Future<bool> updateInvoice() async {
    // Update invoice items
    for (var element in _invoice.items) {
      if (element.id != null) {
        // Update existing invoice item
        await _invoiceItemsDAO.updateInvoiceItem(element);
      } else {
        // Insert new invoice item
        element.invoiceId = _invoice.id; // Ensure the invoiceId is set
        await _invoiceItemsDAO.insertInvoiceItem(element);
      }
    }

    // Update payment if grand total or status has changed
    final Payment? existingPayment = await _paymentsDAO.getPaymentByInvoiceId(
        _invoice.id
            .toString()); // TODO: temporary fix for int to String issue, fix the code by removing toString() for it to be correct
    if (existingPayment != null) {
      if (existingPayment.amount != _invoice.grandTotal ||
          existingPayment.paymentMethod != _invoice.status) {
        existingPayment.amount = _invoice.grandTotal;
        existingPayment.paymentMethod = _invoice.status;
        existingPayment.updatedAt = DateTime.now();

        await _paymentsDAO.updatePayment(existingPayment);
      }
    }
    // } else {
    //   // If no existing payment, create a new one
    //   await _paymentsDAO.insertPayment(
    //     Payment(
    //       invoiceId: _invoice.id,
    //       amount: _invoice.grandTotal,
    //       paymentDate: _invoice.date,
    //       createdAt: existingPayment?.createdAt ?? DateTime.now(), // Keep the original createdAt
    //       updatedAt: DateTime.now(),
    //       paymentMethod: _invoice.status,
    //     ),
    //   );
    // }

    debugLog("Update invoice: " + _invoice.toJSON().toString());
    await _invoiceDAO.updateInvoice(_invoice); // Update the invoice itself
    return Future.value(true);
  }

  Future<void> updateInvoiceItemUnitPrice(InvoiceItem item) async {
    // print('Updating invoice item unit price: $item, ${item.itemId}');
    if (item.itemId != null) {
      _invoice.items
          .firstWhere((element) => element.itemId == item.itemId)
          .unitPrice = item.unitPrice;
      _invoice.items
          .firstWhere((element) => element.itemId == item.itemId)
          .totalPrice = item.unitPrice * item.quantity;
      _inventoryItemsDAO.updateInventoryItem(
        InventoryItem(
          itemId: item.itemId,
          name: item.name,
          unitPrice: item.unitPrice,
          uom: item.uom,
        ),
      );
    }
    await _updateInvoiceAmounts();
    emit(InvoiceManagerLoaded(invoice: _invoice));
  }

  void setLoading(bool bool) {
    if (bool) {
      emit(InvoiceManagerLoading());
    } else {
      emit(InvoiceManagerLoaded(invoice: _invoice));
    }
  }

  void updateInvoiceNotes(String notes) {
    _invoice.notes = notes;
    emit(InvoiceManagerLoaded(invoice: _invoice));
  }

  String formatInvoiceDetails() {
    // Start building the formatted string
    StringBuffer buffer = StringBuffer();
    buffer.writeln('Invoice ID: ${_invoice.id}');
    buffer.writeln('Date: ${formatInvoiceDate(_invoice.date)}');
    buffer.writeln('-----------------------------------');
    buffer.writeln('| Item Name | Quantity | Price   | Total   |');
    buffer.writeln('-----------------------------------');

    // Loop through each item in the invoice
    for (var item in invoice.items) {
      buffer.writeln(
          '| ${item.name.padRight(10)} | ${item.quantity.toString().padRight(8)} | ${item.unitPrice.toStringAsFixed(2).padRight(7)} | ${item.totalPrice.toStringAsFixed(2).padRight(7)} |');
    }

    buffer.writeln('-----------------------------------');
    buffer.writeln('Total Amount: ${_invoice.totalAmount.toStringAsFixed(2)}');
    buffer.writeln('Discount: ${_invoice.discount.toStringAsFixed(2)}');
    buffer
        .writeln('Total Payable: ${(_invoice.grandTotal).toStringAsFixed(2)}');

    return buffer.toString();
  }

  void setEntityName(String clientName) {
    invoice.name = clientName;
  }
}
