import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/invoice_manager_cubit.dart';

class InvoiceNotesWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    String notes = '';
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Additional Notes',
            style: Theme.of(context).textTheme.labelLarge,
          ),
          TextField(
            maxLines: 3,
            style: Theme.of(context).textTheme.labelLarge,
            decoration: InputDecoration(
              hintText: 'Enter your notes here.',
              // border: OutlineInputBorder(),
            ),
            onChanged: (value) {
              notes = value;
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
