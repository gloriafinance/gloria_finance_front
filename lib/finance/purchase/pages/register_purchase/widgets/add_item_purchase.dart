import 'package:church_finance_bk/core/theme/app_color.dart';
import 'package:church_finance_bk/core/widgets/custom_button.dart';
import 'package:church_finance_bk/core/widgets/form_controls.dart';
import 'package:flutter/material.dart';
import 'package:flutter_multi_formatter/formatters/currency_input_formatter.dart';
import 'package:flutter_multi_formatter/formatters/money_input_enums.dart';

import '../state/purchase_register_form_state.dart';
import '../store/add_item_purchase_from_store.dart';
import '../validators/add_item_purchase_validator.dart';

class AddItemPurchase extends StatelessWidget {
  final formKey = GlobalKey<FormState>();
  final AddItemPurchaseFromStore store = AddItemPurchaseFromStore();
  final Function(PurchaseItem) onCallback;

  AddItemPurchase({super.key, required this.onCallback});

  @override
  Widget build(BuildContext context) {
    final validator = AddItemPurchaseValidator();

    return Form(
        key: formKey,
        child: Card(
            color: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
            elevation: 4,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Input(
                      label: "Produto",
                      keyboardType: TextInputType.text,
                      onChanged: (value) => store.setProduct(value),
                      onValidator: validator.byField(store, 'product'),
                    ),
                    Input(
                      label: "Valor do produto",
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        CurrencyInputFormatter(
                          leadingSymbol: 'R\$ ',
                          useSymbolPadding: true,
                          mantissaLength: 2,
                          thousandSeparator: ThousandSeparator.Period,
                        ),
                      ],
                      onChanged: (value) {
                        final cleanedValue = value
                            .replaceAll(RegExp(r'[^\d,]'), '')
                            .replaceAll(',', '.');

                        store.setPriceUnit(double.parse(cleanedValue));
                      },
                      onValidator: validator.byField(store, 'priceUnit'),
                    ),
                    Input(
                      label: "Quantidade",
                      keyboardType: TextInputType.number,
                      onChanged: (value) {
                        final cleanedValue = value
                            .replaceAll(RegExp(r'[^\d,]'), '')
                            .replaceAll(',', '.');

                        store.setQuantity(int.parse(cleanedValue));
                      },
                      onValidator: validator.byField(store, 'quantity'),
                    ),
                    Input(
                      label: "Total",
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        CurrencyInputFormatter(
                          leadingSymbol: 'R\$ ',
                          useSymbolPadding: true,
                          mantissaLength: 2,
                          thousandSeparator: ThousandSeparator.Period,
                        ),
                      ],
                      onChanged: (value) {
                        final cleanedValue = value
                            .replaceAll(RegExp(r'[^\d,]'), '')
                            .replaceAll(',', '.');

                        store.setTotal(double.parse(cleanedValue));
                      },
                      onValidator: validator.byField(store, 'total'),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: CustomButton(
                        text: "Adicionar item",
                        onPressed: () => _addItemTable(context),
                        icon: Icons.add_box_outlined,
                        backgroundColor: AppColors.green,
                      ),
                    ),
                  ]),
            )));
  }

  _addItemTable(BuildContext context) {
    if (!formKey.currentState!.validate()) return;

    onCallback(store.getItem());

    Navigator.pop(context);
  }
}
