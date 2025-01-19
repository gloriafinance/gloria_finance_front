import 'package:church_finance_bk/core/theme/app_color.dart';
import 'package:church_finance_bk/core/widgets/custom_button.dart';
import 'package:church_finance_bk/core/widgets/form_controls.dart';
import 'package:church_finance_bk/core/widgets/loading.dart';
import 'package:church_finance_bk/core/widgets/upload_file.dart';
import 'package:church_finance_bk/helpers/index.dart';
import 'package:church_finance_bk/settings/banks/stores/bank_store.dart';
import 'package:church_finance_bk/settings/financial_concept/store/financial_concept_store.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_multi_formatter/formatters/currency_input_formatter.dart';
import 'package:flutter_multi_formatter/formatters/money_input_enums.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'store/form_record_offerings_store.dart';
import 'validators/form_record_offerings.dart';

class ContributionOfferingsScreen extends StatefulWidget {
  const ContributionOfferingsScreen({super.key});

  @override
  State<ContributionOfferingsScreen> createState() =>
      _ContributionOfferingsScreenState();
}

class _ContributionOfferingsScreenState
    extends State<ContributionOfferingsScreen> {
  final validator = FormRecordOfferingsValidator();
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final formOfferingStore = Provider.of<FormRecordOfferingStore>(context);
    final conceptStore = Provider.of<FinancialConceptStore>(context);

    final bankStore = Provider.of<BankStore>(context);
    //TODO esto porque existe un solo banco, pero si existen mas de uno, se debe seleccionar
    if (bankStore.state.banks.isNotEmpty) {
      final bank = bankStore.state.banks.first;

      formOfferingStore.setBankId(bank.bankId);
    }

    return Form(
        key: formKey,
        child: Column(
          children: [
            _searchFinancialConcepts(formOfferingStore, conceptStore),
            const SizedBox(height: 16),
            amount(formOfferingStore),
            const SizedBox(height: 16),
            _uploadFile(formOfferingStore),
            const SizedBox(height: 16),
            isMobile(context)
                ? _btnSave(formOfferingStore)
                : Align(
                    alignment: Alignment.centerRight,
                    child: SizedBox(
                      width: 300,
                      child: _btnSave(formOfferingStore),
                    ),
                  ),
          ],
        ));
  }

  Widget _searchFinancialConcepts(
      FormRecordOfferingStore form, FinancialConceptStore conceptStore) {
    return Dropdown(
      label: "Conceito",
      items: conceptStore.state.financialConcepts
          .where((e) => e.name.startsWith("Oferta"))
          .map((e) => e.name)
          .toList(),
      onValidator: validator.byField(form.state, 'financialConceptId'),
      onChanged: (value) {
        final v = conceptStore.state.financialConcepts
            .firstWhere((e) => e.name == value);

        form.setFinancialConceptId(v.financialConceptId);
      },
    );
  }

  Widget amount(FormRecordOfferingStore form) {
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

        form.setAmount(double.parse(cleanedValue));
      },
      onValidator: validator.byField(form.state, 'amount'),
    );
  }

  Widget _uploadFile(FormRecordOfferingStore form) {
    return UploadFile(
      label: "Comprovante da transferência",
      multipartFile: (MultipartFile m) => form.setFile(m),
    );
  }

  Widget _btnSave(FormRecordOfferingStore form) {
    return (form.state.makeRequest)
        ? const Loading()
        : Padding(
            padding: EdgeInsets.only(top: 20),
            child: CustomButton(
                text: "Salvar",
                backgroundColor: AppColors.green,
                textColor: Colors.black,
                onPressed: () => _save(form)));
  }

  void _save(FormRecordOfferingStore form) async {
    if (!formKey.currentState!.validate()) {
      return;
    }

    form.send().then((bool value) {
      if (value) {
        context.go("/contributions_list");
      }
    });
  }
}
