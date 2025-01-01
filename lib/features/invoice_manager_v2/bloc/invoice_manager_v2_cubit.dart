import 'package:bloc/bloc.dart';
import 'package:ease/core/database/customers/customers_dao.dart';
import 'package:ease/core/database/invoices/invoices_dao.dart';
import 'package:ease/core/database/payments/payments_dao.dart';
import 'package:ease/core/database/vendors/vendors_dao.dart';
import 'package:ease/core/enums/invoice_type_enum.dart';
import 'package:ease/core/enums/payment_method_enum.dart';
import 'package:ease/core/models/customer.dart';
import 'package:ease/core/models/invoice.dart';
import 'package:ease/core/models/payment.dart';
import 'package:ease/core/models/vendor.dart';
import 'package:ease/core/utils/date_time_utils.dart';
import 'package:ease/core/utils/developer_log.dart';

import 'invoice_manager_v2_cubit_state.dart';

// Note: Invoice Manager V2 considers usage of invoice screenshots and
// removes inventory feature for items tracking within each invoice

class InvoiceManagerCubit extends Cubit<InvoiceManagerCubitState> {
  InvoiceManagerCubit(
    this._invoiceDAO,
    this._paymentsDAO,
    this._customersDAO,
    this._vendorsDAO,
    this.invoiceType,
  ) : super(InvoiceManagerInitial());

  final InvoicesDAO _invoiceDAO;
  final PaymentsDAO _paymentsDAO;
  final CustomersDAO _customersDAO;
  final VendorsDAO _vendorsDAO;

  late Invoice _invoice;

  late String
      phoneNumber; // Used to store the phone number of the customer/vendor temporarily for displaying in the entity typeahead field
  final InvoiceType invoiceType;

  void initialiseInvoiceModelInstance(Invoice? invoice, String invoiceNumber) {
    if (invoice == null) {
      _invoice = Invoice(
        customerId: '',
        name: '',
        invoiceNumber: invoiceNumber,
        date: DateTime.now(),
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        totalAmount: 0.0,
        discount: 0.0,
        taxes: 0.0,
        grandTotal: 0.0,
        totalPaid: 0.0,
        totalDue: 0.0,
        paymentType: 'cash',
        status: 'unpaid',
        notes: "",
      );
    } else {
      _invoice = invoice;
    }
    emit(InvoiceManagerLoaded(invoice: _invoice));
  }

  void populateInvoiceData() async {
    debugLog(
        "Populating invoice data, preset invoice data: " +
            _invoice.toJSON().toString(),
        name: 'InvoiceManagerCubit');
    await _getPaymentsByInvoiceId();
  }

  Invoice get invoice => _invoice;

  void setCustomerId(String customerId) {
    _invoice.customerId = customerId;
    // emit(InvoiceManagerLoaded(invoice: _invoice));
  }

  void setVendorId(String vendorId) {
    _invoice.vendorId = vendorId;
    // emit(InvoiceManagerLoaded(invoice: _invoice));
  }

  void setTotalAmount(double totalAmount) async {
    _invoice.totalAmount = totalAmount;
    await _updateInvoiceAmounts();
    emit(InvoiceManagerLoaded(invoice: _invoice));
  }

  void setDiscount(double discount) async {
    _invoice.discount = discount;
    await _updateInvoiceAmounts();
    emit(InvoiceManagerLoaded(invoice: _invoice));
  }

  void setTotalPaidAmount(double totalPaid) async {
    _invoice.totalPaid = totalPaid;
    await _updateInvoiceAmounts();
    emit(InvoiceManagerLoaded(invoice: _invoice));
  }

  void setPaymentMethod(PaymentMethod selectedPaymentMethod) {
    _invoice.paymentType = selectedPaymentMethod.name;
  }

  void updateInvoiceAmounts() async {
    await _updateInvoiceAmounts();
    emit(InvoiceManagerLoaded(invoice: _invoice));
  }

  Future<bool> _updateInvoiceAmounts() async {
    _invoice.grandTotal = _invoice.totalAmount - _invoice.discount;

    // _invoice.totalPaid = _invoice.payments
    //     .fold(0.0, (previousValue, element) => previousValue + element.amount);
    _invoice.totalDue = _invoice.grandTotal - _invoice.totalPaid;

    if (_invoice.totalDue == 0.0)
      _invoice.status = 'paid';
    else
      _invoice.status = 'unpaid';

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
    String invoiceId = await _invoiceDAO.insertInvoice(_invoice);

    _invoice.payments.forEach((element) async {
      element.invoiceId = invoiceId;
      await _paymentsDAO.insertPayment(element);
    });

    return Future.value(true);
  }

  Future<bool> updateInvoice() async {
    _invoice.updatedAt = DateTime.now();

    for (var element in _invoice.payments) {
      if (element.id != null) {
        // Update existing payment
        await _paymentsDAO.updatePayment(element);
      } else {
        // Insert new payment
        element.invoiceId = _invoice.invoiceId; // Ensure the invoiceId is set
        await _paymentsDAO.insertPayment(element);
      }
    }

    debugLog("Update invoice: " + _invoice.toJSON().toString());
    await _invoiceDAO.updateInvoice(_invoice); // Update the invoice itself

    return Future.value(true);
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
    buffer.writeln('Total Amount: ${_invoice.totalAmount.toStringAsFixed(2)}');
    buffer.writeln('Discount: ${_invoice.discount.toStringAsFixed(2)}');
    buffer
        .writeln('Total Payable: ${(_invoice.grandTotal).toStringAsFixed(2)}');

    return buffer.toString();
  }

  void setEntityName(String clientName) {
    invoice.name = clientName;
    emit(InvoiceManagerLoaded(invoice: _invoice));
  }

  Future<void> _getPaymentsByInvoiceId() async {
    invoice.payments =
        await _paymentsDAO.getPaymentsByInvoiceId(invoice.invoiceId ?? "");
  }

  void addPayment(Payment newPayment) {
    invoice.payments.add(newPayment);
    updateInvoiceAmounts();
    // emit(InvoiceManagerLoaded(invoice: _invoice));
  }

  Future<void> insertNewCustomer(
      {String name = '',
      String phone = '',
      required double openingBalance}) async {
    if (name.isEmpty || phone.isEmpty) {
      return;
    } else {
      final newId = await _customersDAO.insertCustomer(
        Customer(
          name: name,
          phone: phone,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
          openingBalance: openingBalance,
        ),
      );
      setCustomerId(newId);
      invoice.name = name;
      phoneNumber = phone;
    }
  }

  Future<void> insertNewVendor(
      {String name = '',
      String phone = '',
      required double openingBalance}) async {
    if (name.isEmpty || phone.isEmpty) {
      return;
    } else {
      final newId = await _vendorsDAO.insertVendor(
        Vendor(
          name: name,
          phone: phone,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
          openingBalance: openingBalance,
        ),
      );
      setVendorId(newId);
      invoice.name = name;
      phoneNumber = phone;
    }
  }

  void setInvoiceDate(DateTime value) {
    _invoice.date = value;
    emit(InvoiceManagerLoaded(invoice: _invoice));
  }

  void updateInvoiceUrl(String downloadUrl) {}
}