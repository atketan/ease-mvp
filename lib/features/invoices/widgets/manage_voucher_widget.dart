import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ManageVoucherWidget extends StatefulWidget {
  const ManageVoucherWidget({Key? key}) : super(key: key);

  @override
  _ManageVoucherWidgetState createState() => _ManageVoucherWidgetState();
}

class _ManageVoucherWidgetState extends State<ManageVoucherWidget> {
  late String dueDate;
  @override
  void initState() {
    dueDate = DateFormat('dd-MMM-yyyy').format(DateTime.now());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
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
            child: ListTile(
              title: Text("Due Date"),
              subtitle: Text(dueDate),
              trailing: Icon(Icons.arrow_right_sharp),
              onTap: () {
                showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime.now(),
                  lastDate: DateTime(2025),
                ).then((value) {
                  setState(() {
                    if (value != null)
                      dueDate = DateFormat('dd-MM-yyyy').format(value);
                  });
                });
                ;
              },
            ),
          ),
        ],
      ),
    );
  }
}
