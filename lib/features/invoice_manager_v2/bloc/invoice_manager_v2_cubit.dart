import 'package:bloc/bloc.dart';
import 'package:ease/core/database/customers/customers_dao.dart';
import 'package:ease/core/database/ledger/ledger_entry_dao.dart';
import 'package:ease/core/database/vendors/vendors_dao.dart';
import 'package:ease/core/enums/ledger_enum_type.dart';
import 'package:ease/core/enums/payment_method_enum.dart';
import 'package:ease/core/enums/transaction_category_enum.dart';
import 'package:ease/core/enums/transaction_type_enum.dart';
// import 'package:ease/core/enums/transaction_type_enum.dart';
import 'package:ease/core/models/customer.dart';
import 'package:ease/core/models/ledger_entry.dart';
import 'package:ease/core/models/vendor.dart';
import 'package:ease/core/utils/date_time_utils.dart';
import 'package:ease/core/utils/developer_log.dart';

import 'invoice_manager_v2_cubit_state.dart';

// Note: Invoice Manager V2 considers usage of invoice screenshots and
// removes inventory feature for items tracking within each invoice

class InvoiceManagerCubit extends Cubit<InvoiceManagerCubitState> {
  InvoiceManagerCubit(
    this._customersDAO,
    this._vendorsDAO,
    this._ledgerEntryDAO,
    this.transactionCategory,
  ) : super(InvoiceManagerInitial());

  final CustomersDAO _customersDAO;
  final VendorsDAO _vendorsDAO;
  final LedgerEntryDAO _ledgerEntryDAO;

  // late Invoice _invoice;
  late LedgerEntry _ledgerEntry;

  String phoneNumber =
      ''; // Used to store the phone number of the customer/vendor temporarily for displaying in the entity typeahead field
  final TransactionCategory transactionCategory;

  void initialiseInvoiceModelInstance(
      LedgerEntry? ledgerEntry, String invoiceNumber) {
    if (ledgerEntry == null) {
      // _invoice = Invoice(
      //   customerId: '',
      //   name: '',
      //   invoiceNumber: invoiceNumber,
      //   date: DateTime.now(),
      //   createdAt: DateTime.now(),
      //   updatedAt: DateTime.now(),
      //   totalAmount: 0.0,
      //   discount: 0.0,
      //   taxes: 0.0,
      //   grandTotal: 0.0,
      //   totalPaid: 0.0,
      //   totalDue: 0.0,
      //   paymentType: 'cash',
      //   status: 'unpaid',
      //   notes: "",
      // );
      _ledgerEntry = LedgerEntry(
        type: LedgerEntryType.invoice,
        amount: 0.0,
        discount: 0.0,
        grandTotal: 0.0,
        initialPaid: 0.0,
        remainingDue: 0.0,
        transactionDate: DateTime.now(),
        transactionCategory: transactionCategory,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
    } else {
      // _invoice = invoice;
      _ledgerEntry = ledgerEntry;
    }
    emit(InvoiceManagerLoaded(ledgerEntry: _ledgerEntry));
  }

  void populateInvoiceData() async {
    debugLog(
        "Populating invoice data, preset invoice data: " +
            _ledgerEntry.toJSON().toString(),
        name: 'InvoiceManagerCubit');
    await _getPaymentsByInvoiceId();
  }

  // Invoice get invoice => _invoice;
  LedgerEntry get ledgerEntry => _ledgerEntry;

  void setCustomerId(String customerId) {
    // _invoice.customerId = customerId;
    _ledgerEntry.associatedId = customerId;
    // emit(InvoiceManagerLoaded(ledgerEntry: _ledgerEntry));
  }

  void setVendorId(String vendorId) {
    // _invoice.vendorId = vendorId;
    _ledgerEntry.associatedId = vendorId;
    // emit(InvoiceManagerLoaded(ledgerEntry: _ledgerEntry));
  }

  void setTotalAmount(double totalAmount) async {
    // _invoice.totalAmount = totalAmount;
    _ledgerEntry.amount = totalAmount;
    await _updateInvoiceAmounts();
    emit(InvoiceManagerLoaded(ledgerEntry: _ledgerEntry));
  }

  void setDiscount(double discount) async {
    // _invoice.discount = discount;
    _ledgerEntry.discount = discount;
    await _updateInvoiceAmounts();
    emit(InvoiceManagerLoaded(ledgerEntry: _ledgerEntry));
  }

  void setTotalPaidAmount(double totalPaid) async {
    // _invoice.totalPaid = totalPaid;
    _ledgerEntry.initialPaid = totalPaid;
    await _updateInvoiceAmounts();
    emit(InvoiceManagerLoaded(ledgerEntry: _ledgerEntry));
  }

  void setPaymentMethod(PaymentMethod selectedPaymentMethod) {
    // _invoice.paymentType = selectedPaymentMethod.name;
    _ledgerEntry.paymentMethod = selectedPaymentMethod;
  }

  void setReference(String referredBy) {
    _ledgerEntry.referredBy = referredBy;
  }

  void updateInvoiceAmounts() async {
    await _updateInvoiceAmounts();
    emit(InvoiceManagerLoaded(ledgerEntry: _ledgerEntry));
  }

  Future<bool> _updateInvoiceAmounts() async {
    _ledgerEntry.grandTotal =
        _ledgerEntry.amount - (_ledgerEntry.discount ?? 0);

    _ledgerEntry.remainingDue =
        ((_ledgerEntry.grandTotal ?? 0.0) - (_ledgerEntry.initialPaid ?? 0.0));

    if (_ledgerEntry.remainingDue == 0.0)
      _ledgerEntry.status = 'paid';
    else if (_ledgerEntry.initialPaid == 0.0 ||
        _ledgerEntry.initialPaid == null)
      _ledgerEntry.status = 'unpaid';
    else
      _ledgerEntry.status = 'partially_paid';

    debugLog('Payment status: ${_ledgerEntry.status}',
        name: 'InvoiceManagerCubit');

    return Future.value(true);
  }

  Future<bool> saveInvoice() async {
    // String invoiceId = await _invoiceDAO.insertInvoice(_invoice);

    // _invoice.payments.forEach((element) async {
    //   element.invoiceId = invoiceId;
    //   await _paymentsDAO.insertPayment(element);
    // });

    if (_ledgerEntry.transactionCategory == TransactionCategory.sales) {
      _ledgerEntry.transactionType = TransactionType.credit;
    } else if (_ledgerEntry.transactionCategory ==
        TransactionCategory.purchase) {
      _ledgerEntry.transactionType = TransactionType.debit;
    }

    _ledgerEntryDAO.createLedgerEntry(_ledgerEntry);
    return Future.value(true);
  }

  Future<bool> updateInvoice() async {
    // _invoice.updatedAt = DateTime.now();
    _ledgerEntry.updatedAt = DateTime.now();

    // for (var element in _invoice.payments) {
    //   if (element.id != null) {
    //     // Update existing payment
    //     await _paymentsDAO.updatePayment(element);
    //   } else {
    //     // Insert new payment
    //     element.invoiceId = _invoice.invoiceId; // Ensure the invoiceId is set
    //     await _paymentsDAO.insertPayment(element);
    //   }
    // }

    // debugLog("Update invoice: " + _invoice.toJSON().toString());
    // await _invoiceDAO.updateInvoice(_invoice); // Update the invoice itself
    _ledgerEntryDAO.updateLedgerEntry(
        _ledgerEntry.docId ?? "", _ledgerEntry.toJSON());

    return Future.value(true);
  }

  void setLoading(bool bool) {
    if (bool) {
      emit(InvoiceManagerLoading());
    } else {
      emit(InvoiceManagerLoaded(ledgerEntry: _ledgerEntry));
    }
  }

  void updateInvoiceNotes(String notes) {
    // _invoice.notes = notes;
    _ledgerEntry.notes = notes;
    emit(InvoiceManagerLoaded(ledgerEntry: _ledgerEntry));
  }

  String formatInvoiceDetails() {
    // Start building the formatted string
    StringBuffer buffer = StringBuffer();
    buffer.writeln('Invoice Number: ${_ledgerEntry.invNumber}');
    buffer.writeln('Date: ${formatInvoiceDate(_ledgerEntry.transactionDate)}');

    buffer.writeln('-----------------------------------');
    buffer.writeln('Total Amount: ${_ledgerEntry.amount.toStringAsFixed(2)}');
    buffer.writeln('Discount: ${_ledgerEntry.discount?.toStringAsFixed(2)}');
    buffer.writeln(
        'Total Payable: ${_ledgerEntry.grandTotal?.toStringAsFixed(2)}');

    return buffer.toString();
  }

  void setEntityName(String clientName) {
    // invoice.name = clientName;
    _ledgerEntry.name = clientName;
    emit(InvoiceManagerLoaded(ledgerEntry: _ledgerEntry));
  }

  Future<void> _getPaymentsByInvoiceId() async {
    // invoice.payments =
    //     await _paymentsDAO.getPaymentsByInvoiceId(invoice.invoiceId ?? "");
  }

  Future<void> insertNewCustomer(
      {String name = '',
      String phone = '',
      required double openingBalance}) async {
    if (name.isEmpty) {
      // || phone.isEmpty - remove phone number check - allow phone number to be skipped while entity creation
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

      await _ledgerEntryDAO.createLedgerEntry(
        LedgerEntry(
          associatedId: newId,
          name: name,
          type: LedgerEntryType.openingBalance,
          amount: openingBalance,
          remainingDue: openingBalance,
          discount: 0.0,
          grandTotal: 0.0,
          initialPaid: 0.0,
          // transactionType:
          //     TransactionType.credit, // To be received from the customer
          notes: "Opening balance from previous system",
          transactionDate: DateTime.now(),
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
      );

      // invoice.name = name;
      _ledgerEntry.name = name;
      phoneNumber = phone;
    }
  }

  Future<void> insertNewVendor(
      {String name = '',
      String phone = '',
      required double openingBalance}) async {
    if (name.isEmpty) {
      // || phone.isEmpty - remove phone number check - allow phone number to be skipped while entity creation
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

      await _ledgerEntryDAO.createLedgerEntry(
        LedgerEntry(
          associatedId: newId,
          name: name,
          type: LedgerEntryType.openingBalance,
          amount: openingBalance,
          remainingDue: openingBalance,
          discount: 0.0,
          grandTotal: 0.0,
          initialPaid: 0.0,
          // transactionType: TransactionType.debit, // To be paid to the vendor
          notes: "Opening balance from previous system",
          transactionDate: DateTime.now(),
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
      );

      // invoice.name = name;
      _ledgerEntry.name = name;
      phoneNumber = phone;
    }
  }

  void setInvoiceDate(DateTime value) {
    // _invoice.date = value;
    _ledgerEntry.transactionDate = value;
    emit(InvoiceManagerLoaded(ledgerEntry: _ledgerEntry));
  }

  void updateInvoiceUrl(String downloadUrl) {}
}
