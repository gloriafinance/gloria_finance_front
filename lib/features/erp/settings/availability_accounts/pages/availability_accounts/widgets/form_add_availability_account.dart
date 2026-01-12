import 'package:church_finance_bk/core/theme/app_color.dart';
import 'package:church_finance_bk/core/toast.dart';
import 'package:church_finance_bk/core/utils/app_localizations_ext.dart';
import 'package:church_finance_bk/core/utils/index.dart';
import 'package:church_finance_bk/core/widgets/custom_button.dart';
import 'package:church_finance_bk/core/widgets/loading.dart';
import 'package:church_finance_bk/features/erp/settings/availability_accounts/pages/availability_accounts/widgets/layouts/form_add_availability_account_desktop_layout.dart';
import 'package:church_finance_bk/features/erp/settings/availability_accounts/pages/availability_accounts/widgets/layouts/form_add_availability_account_mobile_layout.dart';
import 'package:church_finance_bk/features/erp/settings/banks/store/bank_store.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../store/form_availability_store.dart';

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
    final bankStore = Provider.of<BankStore>(context);

    return SingleChildScrollView(
      child: Form(
        key: formKey,
        child: Column(
          children: [
            isMobile(context)
                ? formAddAvailabilityAccountMobileLayout(
                  context,
                  formStore,
                  bankStore,
                )
                : formAddAvailabilityAccountDesktopLayout(
                  context,
                  formStore,
                  bankStore,
                ),
            const SizedBox(height: 32),
            isMobile(context)
                ? _btnSave(formStore)
                : Align(
                  alignment: Alignment.centerRight,
                  child: SizedBox(width: 300, child: _btnSave(formStore)),
                ),
          ],
        ),
      ),
    );
  }

  Widget _btnSave(FormAvailabilityStore formStore) {
    return (formStore.state.makeRequest)
        ? const Loading()
        : Padding(
          padding: EdgeInsets.only(top: 20),
          child: CustomButton(
            text: context.l10n.settings_availability_save,
            backgroundColor: AppColors.green,
            textColor: Colors.black,
            onPressed: () => _saveRecord(formStore),
          ),
        );
  }

  void _saveRecord(FormAvailabilityStore formStore) async {
    if (!formKey.currentState!.validate()) {
      return;
    }

    if (await formStore.send()) {
      Toast.showMessage(
        context.l10n.settings_availability_toast_saved,
        ToastType.info,
      );
      context.go("/availability-accounts");
    }
  }
}
