import 'package:church_finance_bk/settings/availability_accounts/pages/availability_accounts/store/form_availability_store.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FromAddAvailabilityAccount extends StatefulWidget {
  const FromAddAvailabilityAccount({super.key});

  @override
  State<FromAddAvailabilityAccount> createState() =>
      _FromAddAvailabilityAccountState();
}

class _FromAddAvailabilityAccountState
    extends State<FromAddAvailabilityAccount> {
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final formStore = Provider.of<FormAvailabilityStore>(context);

    return SingleChildScrollView(
      child: Form(
        key: formKey,
        child: LayoutBuilder(builder: (context, constraints) {
          return Column(children: []);
        }),
      ),
    );
  }
}
