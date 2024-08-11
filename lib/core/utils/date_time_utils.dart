import 'package:intl/intl.dart';

String formatInvoiceDate(DateTime invoiceDate) {
  final DateFormat formatter = DateFormat('dd MMM yyyy, hh:mma');
  return formatter.format(invoiceDate);
}
