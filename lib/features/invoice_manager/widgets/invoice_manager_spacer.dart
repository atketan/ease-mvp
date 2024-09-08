import 'package:flutter/material.dart';

class InvoiceManagerSpacer extends StatelessWidget {
  final double height;
  InvoiceManagerSpacer({this.height = 12});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        height: height,
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: Colors.grey[300]!,
              width: 1.0,
            ),
          ),
        ),
      ),
    );
  }
}
