import 'package:ease_mvp/core/models/invoice_item.dart';
import 'package:ease_mvp/core/providers/animated_routes_provider.dart';
import 'package:ease_mvp/features/invoices/data_models/invoice_operation.dart';
import 'package:ease_mvp/features/invoices/data_models/invoice_type_enum.dart';
import 'package:ease_mvp/features/invoices/widgets/manage_customer_widget.dart';
import 'package:ease_mvp/features/invoices/widgets/manage_references_widget.dart';
import 'package:ease_mvp/features/invoices/widgets/manage_voucher_widget.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ManageInvoice extends StatefulWidget {
  final InvoiceType invoiceType;
  final InvoiceOperation invoiceOperation;
  const ManageInvoice(
      {Key? key, required this.invoiceType, required this.invoiceOperation})
      : super(key: key);
  @override
  _ManageInvoiceState createState() => _ManageInvoiceState();
}

class _ManageInvoiceState extends State<ManageInvoice> {
  late InvoiceType _invoiceType;
  late InvoiceOperation _invoiceOperation;

  final _formKey = GlobalKey<FormState>();

  late double formWidth;
  late String dueDate;
  late List<InvoiceItem> itemsList;

  @override
  void initState() {
    _invoiceType = widget.invoiceType;
    _invoiceOperation = widget.invoiceOperation;
    dueDate = DateFormat('dd-MMM-yyyy').format(DateTime.now());
    itemsList = [];
    itemsList.add(InvoiceItem(
        particulars: "Asian Paints 1ltr",
        uom: "ltr",
        rate: 100,
        quantity: 1,
        amount: 100));
    itemsList.add(InvoiceItem(
        particulars: "Asian Paints 1ltr",
        uom: "ltr",
        rate: 100,
        quantity: 1,
        amount: 100));
    itemsList.add(InvoiceItem(
        particulars: "Asian Paints 1ltr",
        uom: "ltr",
        rate: 100,
        quantity: 1,
        amount: 100));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    formWidth = MediaQuery.of(context).size.width.toDouble();
    return Scaffold(
      appBar: AppBar(
        title: Text(_invoiceOperation.prefix + " " + _invoiceType.title),
        actions: [
          TextButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                // If the form is valid, display a Snackbar
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Processing Data'),
                  ),
                );
              }
            },
            child: Text("Save"),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(0.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: Colors.grey[200]!,
                      width: 1,
                    ),
                  ),
                ),
                margin: EdgeInsets.only(bottom: 8),
                child: ListTile(
                  title: Text("Voucher #" + "INV-2022-0001"),
                  subtitle: Text("Due: " + dueDate),
                  trailing: Icon(Icons.arrow_right_sharp),
                  onTap: () => PushSlideInAnimatedRoute(
                    context,
                    page: ManageVoucherWidget(),
                  ),
                ),
              ),
              // We will not need the toggle, if we assume that all
              // transactions are by default cash and have a payments widget
              // which takes care of historical updates on the receivables.
              // Container(
              //   // padding: EdgeInsets.all(8),
              //   child: Flex(
              //     direction: Axis.horizontal,
              //     children: [
              //       ToggleTab(
              //         callback: (int i) {},
              //         tabTexts: const [
              //           'Cash',
              //           'Credit',
              //         ],
              //         height: 40,
              //         width: formWidth,
              //         boxDecoration: BoxDecoration(
              //             // color: Color(0xFFc3d2db),
              //             ),
              //         animatedBoxDecoration: BoxDecoration(
              //           boxShadow: [
              //             BoxShadow(
              //               color: const Color(0xFFc3d2db).withOpacity(0.1),
              //               spreadRadius: 1,
              //               blurRadius: 5,
              //               offset: const Offset(2, 2),
              //             ),
              //           ],
              //           // color: kDarkBlueColor,
              //           borderRadius: const BorderRadius.all(
              //             Radius.circular(5),
              //           ),
              //           border: Border.all(
              //             color: Colors.grey,
              //             width: 1,
              //           ),
              //         ),
              //         duration: const Duration(milliseconds: 50),
              //         activeStyle: const TextStyle(
              //           color: Colors.blue,
              //         ),
              //         inactiveStyle: const TextStyle(
              //           color: Colors.black,
              //         ),
              //       ),
              //     ],
              //   ),
              // ),
              Container(
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: Colors.grey[200]!,
                      width: 1,
                    ),
                  ),
                ),
                margin: EdgeInsets.only(bottom: 8),
                child: ListTile(
                  title: Text(
                    "Customer: " + "ABC Corp.",
                    style: TextStyle(
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  trailing: Icon(Icons.arrow_right_sharp),
                  onTap: () => PushSlideInAnimatedRoute(
                    context,
                    page: ManageCustomerWidget(),
                  ),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: Colors.grey[200]!,
                      width: 1,
                    ),
                  ),
                ),
                margin: EdgeInsets.only(bottom: 8),
                child: ListTile(
                  title: Text("References"),
                  trailing: Icon(Icons.arrow_right_sharp),
                  onTap: () {
                    PushSlideInAnimatedRoute(
                      context,
                      page: ManageReferencesWidget(),
                    );
                  },
                ),
              ),

              Container(
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: Colors.grey[200]!,
                      width: 1,
                    ),
                  ),
                ),
                margin: EdgeInsets.only(bottom: 8),
                child: (itemsList.isEmpty)
                    ? ListTile(
                        title: Text("Add items"),
                      )
                    : ListView.builder(
                        shrinkWrap: true,
                        itemCount: itemsList.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            visualDensity: VisualDensity.compact,
                            dense: true,
                            title: RichText(
                              text: TextSpan(
                                text: (index + 1).toString() + ". ",
                                style: Theme.of(context).textTheme.titleSmall,
                                children: <TextSpan>[
                                  TextSpan(
                                    text: itemsList[index].particulars,
                                    style:
                                        Theme.of(context).textTheme.titleMedium,
                                  ),
                                  TextSpan(
                                    text: ", " +
                                        itemsList[index].quantity.toString() +
                                        " x \u{20B9}" +
                                        itemsList[index].rate.toString(),
                                    style:
                                        Theme.of(context).textTheme.titleSmall,
                                  ),
                                ],
                              ),
                            ),
                            trailing: Text(
                              "\u{20B9} ${itemsList[index].amount}",
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
