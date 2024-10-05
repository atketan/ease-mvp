import 'package:ease/features/invoice_manager/bloc/invoice_manager_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DiscountManagerWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return DiscountManagerWidgetState();
  }
}

class DiscountManagerWidgetState extends State<DiscountManagerWidget> {
  final TextEditingController _discountTextController = TextEditingController();
  final FocusNode _discountFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    // Request focus when the widget is initialized
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _discountFocusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _discountTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _discountTextController.text =
        context.read<InvoiceManagerCubit>().invoice.discount.toString();
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        child: Wrap(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Discount (₹):',
                      style: Theme.of(context).textTheme.labelLarge,
                    ),
                    SizedBox(width: 16.0),
                    Flexible(
                      child: TextField(
                        controller: _discountTextController,
                        focusNode: _discountFocusNode,
                        style: Theme.of(context).textTheme.labelLarge,
                        keyboardType: TextInputType.number,
                        onChanged: (value) {
                          if (value.isEmpty) value = "0";
                          context
                              .read<InvoiceManagerCubit>()
                              .setDiscount(double.parse(value));
                        },
                      ),
                    ),
                  ],
                ),
                // SizedBox(height: 16.0),
                // SizedBox(
                //   width: double.maxFinite / 2,
                //   child: TextButton(
                //     onPressed: () {
                //       Navigator.pop(
                //           context,
                //           _discountTextController.text.isEmpty
                //               ? 0.0
                //               : double.parse(_discountTextController.text));
                //     },
                //     child: Text(
                //       'Save',
                //       style: TextStyle().copyWith(
                //         fontWeight: FontWeight.bold,
                //       ),
                //     ),
                //   ),
                // ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
