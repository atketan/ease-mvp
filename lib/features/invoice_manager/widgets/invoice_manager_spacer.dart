import 'package:flutter/material.dart';

class InvoiceManagerSpacer extends StatelessWidget {
  final double height;
  final double? horizontalPadding;
  InvoiceManagerSpacer({this.height = 12, this.horizontalPadding});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding ?? 16),
      child: Container(
        height: height,
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: Theme.of(context).primaryColorLight,
              width: 1.0,
            ),
          ),
        ),
      ),
    );
  }
}
