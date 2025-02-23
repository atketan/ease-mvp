import 'package:flutter/material.dart';

class PaymentCategorySelectorDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      elevation: 5,
      insetPadding: EdgeInsets.all(16.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      child: Material(
        color: Colors.transparent, 
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0)
                ),
                child: ListTile(
                  title: Text('Customer Payment'),
                  trailing: Icon(Icons.arrow_right),
                  onTap: () {
                    Navigator.of(context).pop(0);
                  },
                ),
              ),
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0)),
                child: ListTile(
                  title: Text('Supplier Payment'),
                  trailing: Icon(Icons.arrow_right),
                  onTap: () {
                    Navigator.of(context).pop(1);
                  },
                ),
              ),
              // Card(
              //   elevation: 2,
              //   shape: RoundedRectangleBorder(
              //       borderRadius: BorderRadius.circular(8.0)),
              //   child: ListTile(
              //     title: Text('Other Payment'),
              //     trailing: Icon(Icons.arrow_right),
              //     onTap: () {
              //       Navigator.of(context).pop(2);
              //     },
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
