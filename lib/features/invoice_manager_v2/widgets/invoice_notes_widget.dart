import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/invoice_manager_v2_cubit.dart';

class InvoiceNotesWidget extends StatelessWidget {
  final String initialNotes;
  InvoiceNotesWidget({required this.initialNotes});

  final TextEditingController _notesTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    String notes = initialNotes;
    _notesTextController.text = initialNotes;
    return Padding(
      padding: const EdgeInsets.all(0.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Text(
          //   'Additional Notes',
          //   style: Theme.of(context).textTheme.labelLarge,
          // ),
          TextField(
            controller: _notesTextController,
            maxLines: 3,
            style: Theme.of(context).textTheme.labelLarge,
            decoration: InputDecoration(
              hintText: 'Enter your notes here.',
              // border: OutlineInputBorder(),
            ),
            onChanged: (value) {
              notes = value;
              context.read<InvoiceManagerCubit>().updateInvoiceNotes(notes);
            },
            onEditingComplete: () {
              context.read<InvoiceManagerCubit>().updateInvoiceNotes(notes);
            },
            onSubmitted: (value) {
              notes = value;
              context.read<InvoiceManagerCubit>().updateInvoiceNotes(notes);
            },
          ),
        ],
      ),
    );
  }
}
