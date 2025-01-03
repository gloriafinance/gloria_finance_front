import 'package:church_finance_bk/core/theme/app_color.dart';
import 'package:church_finance_bk/core/toast.dart';
import 'package:church_finance_bk/core/widgets/custom_button.dart';
import 'package:church_finance_bk/core/widgets/loading.dart';
import 'package:church_finance_bk/finance/models/financial_concept_model.dart';
import 'package:church_finance_bk/finance/pages/financial_records/widgets/finance_record_desktop_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
  final List<FinancialConcept> financialConcepts = [];
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Form(
        key: formKey,
        //formGroup: form,
        child: LayoutBuilder(
          builder: (context, constraints) {
            bool isMobile = constraints.maxWidth < 600;

            return Column(
              children: [
                isMobile ? formMobileLayout(ref) : formDesktopLayout(ref),
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

  void _saveRecord() {
    if (!formKey.currentState!.validate()) {
      final result = validator.validate(formFinanceRecordState);
      for (var exception in result.exceptions) {
        print(exception.message);
      }

      return;
    }

    _makeRequest = true;
    setState(() {});
    print('save record');

    if (formFinanceRecordState.isPurchase) {
      Toast.showMessage("Registro de compras em contruçāo", ToastType.warning);
    }
    // _makeRequest = true;
    // setState(() {});
    // print(record);
  }
}
