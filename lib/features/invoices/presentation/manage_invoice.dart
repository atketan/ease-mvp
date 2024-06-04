import 'package:ease_mvp/features/invoices/data_models/invoice_operation.dart';
import 'package:ease_mvp/features/invoices/data_models/invoice_type_enum.dart';
import 'package:ease_mvp/widgets/toggle_tab.dart';
import 'package:flutter/material.dart';

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
  TextEditingController _reference1TextController = TextEditingController();
  TextEditingController _reference2TextController = TextEditingController();

  @override
  void initState() {
    _invoiceType = widget.invoiceType;
    _invoiceOperation = widget.invoiceOperation;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
        padding: const EdgeInsets.all(8.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.all(8),
                child: Flex(
                  direction: Axis.horizontal,
                  children: [
                    ToggleTab(
                      callback: (int i) {},
                      tabTexts: const [
                        'Cash',
                        'Credit',
                      ],
                      height: 40,
                      width: 360,
                      boxDecoration: BoxDecoration(
                          // color: Color(0xFFc3d2db),
                          ),
                      animatedBoxDecoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFFc3d2db).withOpacity(0.1),
                            spreadRadius: 1,
                            blurRadius: 5,
                            offset: const Offset(2, 2),
                          ),
                        ],
                        // color: kDarkBlueColor,
                        borderRadius: const BorderRadius.all(
                          Radius.circular(5),
                        ),
                        border: Border.all(
                          color: Colors.grey,
                          width: 1,
                        ),
                      ),
                      duration: const Duration(milliseconds: 50),
                      activeStyle: const TextStyle(
                        color: Colors.blue,
                      ),
                      inactiveStyle: const TextStyle(
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
              Card(
                child: ListTile(
                  title: Text("Voucher Number"),
                  subtitle: Text("INV-2022-0001"),
                  trailing: Icon(Icons.arrow_right_sharp),
                ),
              ),
              Card(
                child: ListTile(
                  title: Text("Customer"),
                  subtitle: Text("ABC Corp."),
                  trailing: Icon(Icons.arrow_right_sharp),
                ),
              ),
              Card(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4),
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _reference1TextController,
                        decoration: const InputDecoration(
                          icon: Icon(Icons.note_add),
                          // hintText: 'Useful for search',
                          labelText: 'Reference 1',
                        ),
                        onSaved: (String? value) {
                          // This optional block of code can be used to run
                          // code when the user saves the form.
                        },
                        validator: (String? value) {
                          return (value != null && value.contains('@'))
                              ? 'Do not use the @ char.'
                              : null;
                        },
                      ),
                      TextFormField(
                        controller: _reference2TextController,
                        decoration: const InputDecoration(
                          icon: Icon(Icons.note_add_outlined),
                          // hintText: 'Useful for search',
                          labelText: 'Reference 2',
                        ),
                        onSaved: (String? value) {
                          // This optional block of code can be used to run
                          // code when the user saves the form.
                        },
                        validator: (String? value) {
                          return (value != null && value.contains('#'))
                              ? 'Do not use the # char.'
                              : null;
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
