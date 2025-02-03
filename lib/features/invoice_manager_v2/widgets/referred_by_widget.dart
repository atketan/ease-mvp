import 'package:ease/features/invoice_manager_v2/bloc/invoice_manager_v2_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ReferredByWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => ReferredByWidgetState();
}

class ReferredByWidgetState extends State<ReferredByWidget> {
  final TextEditingController _referredByController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _referredByController.text =
        context.read<InvoiceManagerCubit>().ledgerEntry.referredBy.toString();
  }

  @override
  void dispose() {
    _referredByController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          flex: 3,
          child: Text(
            'Reference:',
            style: Theme.of(context).textTheme.labelLarge,
          ),
        ),
        SizedBox(width: 16.0),
        Expanded(
          flex: 7,
          child: TextField(
            controller: _referredByController,
            style: Theme.of(context).textTheme.labelLarge,
            keyboardType: TextInputType.name,
            onChanged: (value) {
              context.read<InvoiceManagerCubit>().setReference(value);
            },
          ),
        ),
      ],
    );
  }
}
