import 'package:intl/intl.dart';

String formatInvoiceDate(DateTime invoiceDate) {
  final DateFormat formatter = DateFormat('dd MMM yyyy, hh:mma');
  return formatter.format(invoiceDate);
}

String formatInvoiceDateWithoutTime(DateTime invoiceDate) {
  final DateFormat formatter = DateFormat('dd MMM yyyy');
  return formatter.format(invoiceDate);
}
