import 'package:church_finance_bk/core/layout/modal_page_layout.dart';
import 'package:church_finance_bk/core/theme/app_color.dart';
import 'package:church_finance_bk/core/theme/app_fonts.dart';
import 'package:church_finance_bk/core/widgets/custom_button.dart';
import 'package:church_finance_bk/core/widgets/loading.dart';
import 'package:church_finance_bk/finance/pages/register_purchase/widgets/form_desktop_layout.dart';
import 'package:church_finance_bk/finance/pages/register_purchase/widgets/form_mobile_layout.dart';
import 'package:church_finance_bk/finance/stores/bank_store.dart';
import 'package:church_finance_bk/helpers/index.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/widgets/button_acton_table.dart';
import '../../../stores/financial_concept_store.dart';
import '../state/purchase_register_form_state.dart';
import '../store/purchase_register_form_store.dart';
import 'add_item_purchase/add_item_purchase.dart';
import 'table_item.dart';

class FormPurchase extends StatefulWidget {
  const FormPurchase({super.key});

  @override
  State<StatefulWidget> createState() => _FormPurchaseState();
}

class _FormPurchaseState extends State<FormPurchase> {
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final conceptStore = Provider.of<FinancialConceptStore>(context);
    final formStore = Provider.of<PurchaseRegisterFormStore>(context);
    final bankStore = Provider.of<BankStore>(context);

    return SingleChildScrollView(
        child: Form(
            key: formKey,
            child: LayoutBuilder(builder: (context, constraints) {
              return Column(children: [
                isMobile(context)
                    ? formMobileLayout(
                        context, bankStore, conceptStore, formStore)
                    : formDesktopLayout(
                        context, bankStore, conceptStore, formStore),
                const SizedBox(height: 32),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text('Cadastre cada item da compra',
                      style: TextStyle(
                          fontSize: 16,
                          color: AppColors.grey,
                          fontFamily: AppFonts.fontLight)),
                ),
                _btnAddItem(formStore),
                const SizedBox(height: 12),
                TableItem(),
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

  Widget _btnAddItem(PurchaseRegisterFormStore formStore) {
    return Row(
      children: [
        ButtonActionTable(
            color: AppColors.purple,
            text: "Adicionar item",
            onPressed: () {
              ModalPage(
                title: "Adicionar item",
                body: AddItemPurchase(
                  onCallback: (PurchaseItem item) {
                    formStore.addItem(item);
                  },
                ),
              ).show(context);
            },
            icon: Icons.add_box_outlined),
      ],
    );
  }

  void _saveRecord(PurchaseRegisterFormStore formStore) async {
    if (!formKey.currentState!.validate()) {
      return;
    }

    print(formStore.state.toJson());
  }
}
