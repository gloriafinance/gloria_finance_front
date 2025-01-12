import 'package:church_finance_bk/core/widgets/form_controls.dart';
import 'package:church_finance_bk/core/widgets/upload_file.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';

import 'state/form_tithes_state.dart';
import 'validators/form_tithes_validator.dart';
import 'widgets/month_dropdown.dart';

class ContributionTithesScreen extends StatefulWidget {
  const ContributionTithesScreen({super.key});

  @override
  State<ContributionTithesScreen> createState() =>
      _ContributionTithesScreenState();
}

class _ContributionTithesScreenState extends State<ContributionTithesScreen> {
  final formTitheState = FormTitheState.init();
  final validator = FormTithesValidator();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Dropdown(
          label: "Mês",
          items: monthDropdown(context)
              .map((item) => item.value.toString())
              .toList(),
          onChanged: (value) {
            formTitheState.copyWith(month: value);
          },
        ),
        const SizedBox(height: 16),
        amount(),
        const SizedBox(height: 16),
        uploadFile()
      ],
    );
  }

  Widget amount() {
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

        formTitheState.copyWith(amount: double.parse(cleanedValue));
      },
      onValidator: validator.byField(formTitheState, 'amount'),
    );
  }

  Widget uploadFile() {
    return UploadFile(
      label: "Comprovante do movimento bancario",
      multipartFile: (MultipartFile m) => formTitheState.copyWith(file: m),
    );
  }
}
