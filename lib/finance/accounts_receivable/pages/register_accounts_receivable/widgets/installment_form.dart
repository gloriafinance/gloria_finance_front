import 'package:church_finance_bk/core/theme/app_color.dart';
import 'package:church_finance_bk/core/widgets/custom_button.dart';
import 'package:church_finance_bk/core/widgets/form_controls.dart';
import 'package:church_finance_bk/finance/accounts_receivable/pages/register_accounts_receivable/store/form_install_store.dart';
import 'package:church_finance_bk/helpers/currency_formatter.dart';
import 'package:church_finance_bk/helpers/date_formatter.dart';
import 'package:flutter/material.dart';

import '../../../models/index.dart';
import '../store/form_accounts_receivable_store.dart';

class InstallmentForm extends StatelessWidget {
  final FormAccountsReceivableStore formStore;
  final Function(InstallmentModel) onCallback;
  final FormInstallStore store = FormInstallStore();

  InstallmentForm(
      {super.key, required this.formStore, required this.onCallback});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 5,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: Input(
                  label: 'Valor',
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    CurrencyFormatter.getInputFormatters('R\$')
                  ],
                  onChanged: (value) => store.setInstallmentValue(
                      CurrencyFormatter.cleanCurrency(value)),
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                child: ListenableBuilder(
                    listenable: store,
                    builder: (context, child) {
                      return Input(
                        label: 'Data de Vencimento',
                        keyboardType: TextInputType.number,
                        initialValue: store.installmentDate,
                        onChanged: (_) {},
                        onTap: () {
                          selectDate(context).then((picked) {
                            if (picked == null) return;
                            store.setInstallmentDate(
                                convertDateFormatToDDMMYYYY(picked.toString()));
                          });
                        },
                      );
                    }),
              ),
            ],
          ),
          SizedBox(height: 16),
          Center(
            child: CustomButton(
              text: 'Adicionar Parelas',
              backgroundColor: AppColors.green,
              textColor: Colors.black,
              onPressed: () => __addInstallment(context),
            ),
          ),
        ],
      ),
    );
  }

  __addInstallment(BuildContext context) {
    // final amount = CurrencyFormatter.cleanCurrency(store.amount);
    // final dueDate = convertDateFormat(store.dueDate);
    //
    // formStore.addInstallment(
    //   InstallmentModel(amount: amount, dueDate: dueDate),
    // );
    //
    // store.clear();

    onCallback(store.getInstallment());
    Navigator.pop(context);
  }
}
