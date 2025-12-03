import 'package:church_finance_bk/core/theme/app_color.dart';
import 'package:church_finance_bk/core/toast.dart';
import 'package:church_finance_bk/core/utils/app_localizations_ext.dart';
import 'package:church_finance_bk/core/utils/index.dart';
import 'package:church_finance_bk/core/widgets/custom_button.dart';
import 'package:church_finance_bk/core/widgets/loading.dart';
import 'package:church_finance_bk/features/erp/settings/availability_accounts/pages/list_availability_accounts/store/availability_accounts_list_store.dart';
import 'package:church_finance_bk/features/erp/settings/cost_center/store/cost_center_list_store.dart';
import 'package:church_finance_bk/features/erp/settings/financial_concept/models/financial_concept_model.dart';
import 'package:church_finance_bk/features/erp/settings/financial_concept/store/financial_concept_store.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../store/form_finance_record_store.dart';
import 'layouts/finance_record_desktop_layout.dart';
import 'layouts/finance_record_mobile_layout.dart';

class FormFinanceRecord extends StatefulWidget {
  const FormFinanceRecord({super.key});

  @override
  State<StatefulWidget> createState() => _FormFinanceRecordState();
}

class _FormFinanceRecordState extends State<FormFinanceRecord> {
  final List<FinancialConceptModel> financialConcepts = [];
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final conceptStore = Provider.of<FinancialConceptStore>(context);

    final formStore = Provider.of<FormFinanceRecordStore>(context);
    final availabilityAccountsListStore =
        Provider.of<AvailabilityAccountsListStore>(context);
    final costCenterStore = Provider.of<CostCenterListStore>(context);

    return SingleChildScrollView(
      child: Form(
        key: formKey,
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Column(
              children: [
                isMobile(context)
                    ? formMobileLayout(
                      costCenterStore,
                      availabilityAccountsListStore,
                      conceptStore,
                      formStore,
                      context,
                    )
                    : formDesktopLayout(
                      costCenterStore,
                      availabilityAccountsListStore,
                      conceptStore,
                      formStore,
                      context,
                    ),
                const SizedBox(height: 32),
                isMobile(context)
                    ? _btnSave(context, formStore)
                    : Align(
                      alignment: Alignment.centerRight,
                      child: SizedBox(
                        width: 300,
                        child: _btnSave(context, formStore),
                      ),
                    ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _btnSave(BuildContext context, FormFinanceRecordStore formStore) {
    return (formStore.state.makeRequest)
        ? const Loading()
        : Padding(
          padding: EdgeInsets.only(top: 20),
          child: CustomButton(
            text: context.l10n.finance_records_form_save,
            backgroundColor: AppColors.green,
            textColor: Colors.black,
            onPressed: () => _saveRecord(context, formStore),
          ),
        );
  }

  void _saveRecord(
    BuildContext context,
    FormFinanceRecordStore formStore,
  ) async {
    if (!formKey.currentState!.validate()) {
      return;
    }

    if (formStore.state.isPurchase) {
      Toast.showMessage(
        context.l10n.finance_records_form_toast_purchase_in_construction,
        ToastType.warning,
      );
      return;
    }

    if (await formStore.send()) {
      Toast.showMessage(
        context.l10n.finance_records_form_toast_saved_success,
        ToastType.info,
      );
      context.go("/financial-record");
    }
  }
}
