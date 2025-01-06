import 'package:church_finance_bk/core/app_router.dart';
import 'package:church_finance_bk/core/theme/app_color.dart';
import 'package:church_finance_bk/core/toast.dart';
import 'package:church_finance_bk/core/widgets/custom_button.dart';
import 'package:church_finance_bk/core/widgets/loading.dart';
import 'package:church_finance_bk/finance/models/financial_concept_model.dart';
import 'package:church_finance_bk/finance/pages/financial_records/widgets/finance_record_desktop_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../usecases/financial_record_save.dart';
import 'finance_record_mobile_layout.dart';
import 'form_financial_record_inputs.dart';

class FormFinancialRecord extends ConsumerStatefulWidget {
  const FormFinancialRecord({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _FormFinancialRecordState();
}

class _FormFinancialRecordState extends ConsumerState<FormFinancialRecord> {
  bool _makeRequest = false;
  final List<FinancialConceptModel> financialConcepts = [];
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Form(
        key: formKey,
        child: LayoutBuilder(
          builder: (context, constraints) {
            bool isMobile = constraints.maxWidth < 600;

            return Column(
              children: [
                isMobile ? formMobileLayout() : formDesktopLayout(),
                const SizedBox(height: 32),
                isMobile
                    ? _btnSave()
                    : Align(
                        alignment: Alignment.centerRight,
                        child: _btnSave(),
                      ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _btnSave() {
    return (_makeRequest)
        ? const Loading()
        : Padding(
            padding: EdgeInsets.only(top: 20),
            child: CustomButton(
                text: "Salvar",
                backgroundColor: AppColors.purple,
                textColor: Colors.white,
                onPressed: () => _saveRecord()));
  }

  void _saveRecord() async {
    if (!formKey.currentState!.validate()) {
      return;
    }

    _makeRequest = true;
    setState(() {});

    if (formFinanceRecordState.isPurchase) {
      Toast.showMessage("Registro de compras em contruçāo", ToastType.warning);
      return;
    }

    await financeRecordSave(formFinanceRecordState).then((value) {
      _makeRequest = false;
      setState(() {});
      if (value) {
        Toast.showMessage("Registro salvo com sucesso", ToastType.info);
        ref.read(appRouterProvider).go("/financial-record");
      }
    });
  }
}
