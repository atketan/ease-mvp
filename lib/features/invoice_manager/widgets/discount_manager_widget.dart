import 'package:flutter/material.dart';

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
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 16.0,
        right: 16.0,
        top: 24.0,
      ),
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
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    SizedBox(width: 16.0),
                    Flexible(
                      child: TextField(
                        controller: _discountTextController,
                        focusNode: _discountFocusNode,
                        style: Theme.of(context).textTheme.titleMedium,
                        keyboardType: TextInputType.number,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16.0),
                SizedBox(
                  width: double.maxFinite / 2,
                  child: TextButton(
                    onPressed: () {
                      Navigator.pop(
                          context,
                          _discountTextController.text.isEmpty
                              ? 0.0
                              : double.parse(_discountTextController.text));
                    },
                    child: Text(
                      'Save',
                      style: TextStyle().copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
