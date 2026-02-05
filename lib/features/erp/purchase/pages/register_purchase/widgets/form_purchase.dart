import 'package:gloria_finance/core/layout/modal_page_layout.dart';
import 'package:gloria_finance/core/theme/app_color.dart';
import 'package:gloria_finance/core/theme/app_fonts.dart';
import 'package:gloria_finance/core/toast.dart';
import 'package:gloria_finance/core/utils/index.dart';
import 'package:gloria_finance/core/widgets/button_acton_table.dart';
import 'package:gloria_finance/core/widgets/custom_button.dart';
import 'package:gloria_finance/core/widgets/loading.dart';
import 'package:gloria_finance/features/erp/settings/availability_accounts/pages/list_availability_accounts/store/availability_accounts_list_store.dart';
import 'package:gloria_finance/features/erp/settings/banks/store/bank_store.dart';
import 'package:gloria_finance/features/erp/settings/cost_center/store/cost_center_list_store.dart';
import 'package:gloria_finance/features/erp/settings/financial_concept/store/financial_concept_store.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../state/purchase_register_form_state.dart';
import '../store/purchase_register_form_store.dart';
import 'add_item_purchase.dart';
import 'layouts/form_desktop_layout.dart';
import 'layouts/form_mobile_layout.dart';
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
                      context,
                      costCenterStore,
                      availabilityAccountsListStore,
                      conceptStore,
                      formStore,
                    )
                    : formDesktopLayout(
                      context,
                      costCenterStore,
                      availabilityAccountsListStore,
                      conceptStore,
                      formStore,
                    ),
                const SizedBox(height: 32),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Cadastre cada item da compra',
                    style: TextStyle(
                      fontSize: 16,
                      color: AppColors.grey,
                      fontFamily: AppFonts.fontSubTitle,
                    ),
                  ),
                ),
                _btnAddItem(formStore),
                const SizedBox(height: 12),
                TableItem(),
                const SizedBox(height: 32),
                isMobile(context)
                    ? _btnSave(formStore)
                    : Align(
                      alignment: Alignment.centerRight,
                      child: SizedBox(width: 300, child: _btnSave(formStore)),
                    ),
              ],
            );
          },
        ),
      ),
    );
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
            onPressed: () => _saveRecord(formStore),
          ),
        );
  }

  Widget _btnAddItem(PurchaseRegisterFormStore formStore) {
    return Row(
      children: [
        ButtonActionTable(
          color: AppColors.mustard,
          text: "Adicionar item",
          onPressed: () {
            ModalPage(
              title: "Adicionar item",
              body: AddItemPurchase(
                symbol: formStore.state.symbol,
                onCallback: (PurchaseItem item) {
                  formStore.addItem(item);
                },
              ),
            ).show(context);
          },
          icon: Icons.add_box_outlined,
        ),
      ],
    );
  }

  void _saveRecord(PurchaseRegisterFormStore formStore) async {
    if (!formKey.currentState!.validate()) {
      return;
    }

    final finished = await formStore.send();

    if (finished) {
      context.go("/purchase");
      Toast.showMessage("Comprada com sucesso", ToastType.info);
    }
  }
}
