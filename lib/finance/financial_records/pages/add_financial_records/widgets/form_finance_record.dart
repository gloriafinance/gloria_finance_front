import 'package:church_finance_bk/core/theme/app_color.dart';
import 'package:church_finance_bk/core/toast.dart';
import 'package:church_finance_bk/core/widgets/custom_button.dart';
import 'package:church_finance_bk/core/widgets/loading.dart';
import 'package:church_finance_bk/helpers/index.dart';
import 'package:church_finance_bk/settings/banks/store/bank_store.dart';
import 'package:church_finance_bk/settings/financial_concept/models/financial_concept_model.dart';
import 'package:church_finance_bk/settings/financial_concept/store/financial_concept_store.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../store/form_finance_record_store.dart';
import 'finance_record_desktop_layout.dart';
import 'finance_record_mobile_layout.dart';

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
    final bankStore = Provider.of<BankStore>(context);
    final formStore = Provider.of<FormFinanceRecordStore>(context);

    return SingleChildScrollView(
      child: Form(
        key: formKey,
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Column(
              children: [
                isMobile(context)
                    ? formMobileLayout(
                        bankStore, conceptStore, formStore, context)
                    : formDesktopLayout(
                        bankStore, conceptStore, formStore, context),
                const SizedBox(height: 32),
                isMobile(context)
                    ? _btnSave(formStore)
                    : Align(
                        alignment: Alignment.centerRight,
                        child: SizedBox(
                          width: 300,
                          child: _btnSave(formStore),
                        ),
                      ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _btnSave(FormFinanceRecordStore formStore) {
    return (formStore.state.makeRequest)
        ? const Loading()
        : Padding(
            padding: EdgeInsets.only(top: 20),
            child: CustomButton(
                text: "Salvar",
                backgroundColor: AppColors.green,
                textColor: Colors.black,
                onPressed: () => _saveRecord(formStore)));
  }

  void _saveRecord(FormFinanceRecordStore formStore) async {
    if (!formKey.currentState!.validate()) {
      return;
    }

    if (formStore.state.isPurchase) {
      Toast.showMessage("Registro de compras em contruçāo", ToastType.warning);
      return;
    }

    if (await formStore.send()) {
      Toast.showMessage("Registro salvo com sucesso", ToastType.info);
      context.go("/financial-record");
    }
  }
}
