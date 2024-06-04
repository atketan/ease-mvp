import 'package:flutter/material.dart';

class ManageReferencesWidget extends StatefulWidget {
  const ManageReferencesWidget({Key? key}) : super(key: key);

  @override
  _ManageReferencesWidgetState createState() => _ManageReferencesWidgetState();
}

class _ManageReferencesWidgetState extends State<ManageReferencesWidget> {
  TextEditingController _reference1TextController = TextEditingController();
  TextEditingController _reference2TextController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
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
    );
  }
}
