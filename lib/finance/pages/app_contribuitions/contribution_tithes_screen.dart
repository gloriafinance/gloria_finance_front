import 'package:church_finance_bk/core/theme/app_color.dart';
import 'package:church_finance_bk/core/widgets/custom_button.dart';
import 'package:church_finance_bk/core/widgets/form_controls.dart';
import 'package:church_finance_bk/core/widgets/loading.dart';
import 'package:church_finance_bk/core/widgets/upload_file.dart';
import 'package:church_finance_bk/helpers/index.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../stores/bank_store.dart';
import '../../stores/financial_concept_store.dart';
import 'store/form_tithes_store.dart';
import 'validators/form_tithes_validator.dart';
import 'widgets/month_dropdown.dart';

class ContributionTithesScreen extends StatefulWidget {
  const ContributionTithesScreen({super.key});

  @override
  State<ContributionTithesScreen> createState() =>
      _ContributionTithesScreenState();
}

class _ContributionTithesScreenState extends State<ContributionTithesScreen> {
  final validator = FormTithesValidator();
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final formTitheStore = Provider.of<FormTitheStore>(context);

    final conceptStore = Provider.of<FinancialConceptStore>(context);
    final bankStore = Provider.of<BankStore>(context);

    if (conceptStore.state.financialConcepts.isNotEmpty) {
      final titheConcept = conceptStore.state.financialConcepts
          .firstWhere((e) => e.name.startsWith("Dízimo"));

      formTitheStore.setFinancialConceptId(titheConcept.financialConceptId);
    }

    //TODO esto porque existe un solo banco, pero si existen mas de uno, se debe seleccionar
    if (bankStore.state.banks.isNotEmpty) {
      final bank = bankStore.state.banks.first;

      formTitheStore.setBankId(bank.bankId);
    }

    return Form(
      key: formKey,
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Dropdown(
                  label: "Mês",
                  items: monthDropdown(context)
                      .map((item) => item.value.toString())
                      .toList(),
                  onValidator: validator.byField(formTitheStore.state, 'month'),
                  onChanged: (value) {
                    formTitheStore.setMonth(value);
                  },
                ),
              ),
              const SizedBox(width: 16),
              Expanded(child: amount(formTitheStore)),
            ],
          ),
          const SizedBox(height: 16),
          _uploadFile(formTitheStore),
          const SizedBox(height: 16),
          isMobile(context)
              ? _btnSave(formTitheStore)
              : Align(
                  alignment: Alignment.centerRight,
                  child: SizedBox(
                    width: 300,
                    child: _btnSave(formTitheStore),
                  ),
                ),
        ],
      ),
    );
  }

  Widget amount(FormTitheStore formTitheState) {
    return Input(
      label: "Valor",
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
        final cleanedValue =
            value.replaceAll(RegExp(r'[^\d,]'), '').replaceAll(',', '.');

        formTitheState.setAmount(double.parse(cleanedValue));
      },
      onValidator: validator.byField(formTitheState.state, 'amount'),
    );
  }

  Widget _uploadFile(FormTitheStore formTitheState) {
    return UploadFile(
      label: "Comprovante da transferência",
      multipartFile: (MultipartFile m) => formTitheState.setFile(m),
    );
  }

  Widget _btnSave(FormTitheStore formTitheState) {
    return (formTitheState.state.makeRequest)
        ? const Loading()
        : Padding(
            padding: EdgeInsets.only(top: 20),
            child: CustomButton(
                text: "Salvar",
                backgroundColor: AppColors.green,
                textColor: Colors.black,
                onPressed: () => _save(formTitheState)));
  }

  void _save(FormTitheStore formTitheState) async {
    if (!formKey.currentState!.validate()) {
      return;
    }

    formTitheState.send().then((bool value) {
      if (value) {
        context.go("/contributions");
      }
    });
  }
}
