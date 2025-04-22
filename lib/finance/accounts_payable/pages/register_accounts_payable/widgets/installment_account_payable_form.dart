import 'package:church_finance_bk/core/theme/index.dart';
import 'package:church_finance_bk/core/widgets/index.dart';
import 'package:church_finance_bk/helpers/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

import '../store/form_accounts_payable_store.dart';

class InstallmentAccountPayableForm extends StatefulWidget {
  final FormAccountsPayableStore formStore;

  const InstallmentAccountPayableForm({
    super.key,
    required this.formStore,
  });

  @override
  State<InstallmentAccountPayableForm> createState() =>
      _InstallmentAccountPayableForm();
}

class _InstallmentAccountPayableForm
    extends State<InstallmentAccountPayableForm> {
  int numberOfInstallments = 0;
  int selectedDueDate = 0;
  double amountInstallment = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Adicionar Parcela',
            style:
                const TextStyle(fontFamily: AppFonts.fontTitle, fontSize: 15)),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.greyMiddle),
            borderRadius: BorderRadius.circular(18),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Input(
                label: 'Quantidade de parcelas',
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                ],
                onChanged: (value) {
                  setState(() {
                    numberOfInstallments = int.tryParse(value) ?? 0;
                  });
                },
              ),
              Input(
                label: 'Valor',
                keyboardType: TextInputType.number,
                inputFormatters: [CurrencyFormatter.getInputFormatters('R\$')],
                onChanged: (value) {
                  setState(() {
                    amountInstallment = CurrencyFormatter.cleanCurrency(value);
                  });
                },
              ),
              Dropdown(
                label: 'Dia de vencimento',
                items: List.generate(31, (index) => (index + 1).toString()),
                onChanged: (value) {
                  setState(() {
                    selectedDueDate = int.tryParse(value) ?? 0;
                  });
                },
              ),
              const SizedBox(height: 16),
              ButtonActionTable(
                  color: AppColors.blue,
                  text: "Gerar parcelas",
                  onPressed: () => _generateInstallments(),
                  icon: Icons.add_box_outlined)
            ],
          ),
        ),
      ],
    );
  }

  _generateInstallments() {
    DateTime now = DateTime.now();

    for (int i = 0; i < numberOfInstallments; i++) {
      DateTime dueDate = DateTime(now.year, now.month + i, selectedDueDate);

      String formattedDueDate = DateFormat('dd/MM/yyyy').format(dueDate);

      widget.formStore.addInstallment(amountInstallment, formattedDueDate);
    }
  }
}
