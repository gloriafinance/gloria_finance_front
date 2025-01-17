import 'package:church_finance_bk/core/theme/app_color.dart';
import 'package:church_finance_bk/core/widgets/custom_button.dart';
import 'package:church_finance_bk/core/widgets/loading.dart';
import 'package:church_finance_bk/finance/pages/register_purchase/widgets/form_desktop_layout.dart';
import 'package:church_finance_bk/helpers/index.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../stores/financial_concept_store.dart';
import '../store/purchase_register_form_store.dart';

class FormPurchase extends StatefulWidget {
  const FormPurchase({super.key});

  @override
  State<StatefulWidget> createState() => _FormPurchaseState();
}

class _FormPurchaseState extends State<FormPurchase> {
  final formKey = GlobalKey<FormState>();
  final formStore = PurchaseRegisterFormStore();

  @override
  Widget build(BuildContext context) {
    final conceptStore = Provider.of<FinancialConceptStore>(context);
    final formStore = Provider.of<PurchaseRegisterFormStore>(context);

    return SingleChildScrollView(
        child: Form(
            key: formKey,
            child: LayoutBuilder(builder: (context, constraints) {
              return Column(children: [
                formDesktopLayout(conceptStore, formStore),
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
              ]);
            })));
  }

  Widget _btnSave(PurchaseRegisterFormStore formStore) {
    print("SSS");
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

  void _saveRecord(PurchaseRegisterFormStore formStore) async {
    if (!formKey.currentState!.validate()) {
      return;
    }
  }
}
