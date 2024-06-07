import 'package:flutter/material.dart';

class ManageDiscountWidget extends StatefulWidget {
  ManageDiscountWidget({Key? key}) : super(key: key);

  @override
  _ManageDiscountWidgetState createState() => _ManageDiscountWidgetState();
}

class _ManageDiscountWidgetState extends State<ManageDiscountWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Discount"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextFormField(
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Discount',
                prefixText: '\u{20B9}',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
