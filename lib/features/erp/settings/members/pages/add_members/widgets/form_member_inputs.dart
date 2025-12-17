import 'package:church_finance_bk/core/widgets/form_controls.dart';
import 'package:church_finance_bk/core/utils/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';
import '../../../../../../../../l10n/app_localizations.dart';

import '../../../validator/form_member_validator.dart';
import '../store/form_member_store.dart';

Widget name(BuildContext context, FormMemberStore formStore) {
  final l10n = AppLocalizations.of(context)!;
  final validator = FormMemberValidator(l10n);
  return Input(
    label: l10n.member_register_name_label,
    initialValue: formStore.state.name,
    onChanged: (value) => formStore.state.name = value,
    onValidator: validator.byField(formStore.state, 'name'),
  );
}

Widget email(BuildContext context, FormMemberStore formStore) {
  final l10n = AppLocalizations.of(context)!;
  final validator = FormMemberValidator(l10n);
  return Input(
    label: l10n.member_register_email_label,
    keyboardType: TextInputType.emailAddress,
    initialValue: formStore.state.email,
    onChanged: (value) => formStore.state.email = value,
    onValidator: validator.byField(formStore.state, 'email'),
  );
}

Widget phone(BuildContext context, FormMemberStore formStore) {
  final l10n = AppLocalizations.of(context)!;
  final validator = FormMemberValidator(l10n);
  final isEs = l10n.localeName == 'es';

  return Input(
    label: l10n.member_register_phone_label,
    keyboardType: TextInputType.number,
    initialValue: formStore.state.phone,
    onChanged: (value) => formStore.state.phone = value,
    onValidator: validator.byField(formStore.state, 'phone'),
    inputFormatters: [
      MaskedInputFormatter(isEs ? '(####) #######' : '(##) #####-####'),
    ],
  );
}

Widget dni(BuildContext context, FormMemberStore formStore) {
  final l10n = AppLocalizations.of(context)!;
  final validator = FormMemberValidator(l10n);
  final isPt = l10n.localeName == 'pt';

  return Input(
    label: l10n.member_register_dni_label,
    keyboardType: isPt ? TextInputType.number : TextInputType.text,
    initialValue: formStore.state.dni,
    onChanged: (value) => formStore.state.dni = value,
    onValidator: validator.byField(formStore.state, 'dni'),
    inputFormatters: isPt ? [MaskedInputFormatter('###.###.###-##')] : [],
  );
}

Widget conversionDate(BuildContext context, FormMemberStore formStore) {
  final l10n = AppLocalizations.of(context)!;
  final validator = FormMemberValidator(l10n);
  return Input(
    label: l10n.member_register_conversion_date_label,
    initialValue: formStore.state.conversionDate,
    keyboardType: TextInputType.number,
    onChanged: (value) {},
    onTap: () {
      selectDate(context).then((picked) {
        if (picked == null) return;

        formStore.setConversionDate(
          convertDateFormatToDDMMYYYY(picked.toString()),
        );
      });
    },
    onValidator: validator.byField(formStore.state, 'conversionDate'),
    inputFormatters: [MaskedInputFormatter('##/##/####')],
  );
}

Widget baptismDate(BuildContext context, FormMemberStore formStore) {
  final l10n = AppLocalizations.of(context)!;
  final validator = FormMemberValidator(l10n);
  return Input(
    label: l10n.member_register_baptism_date_label,
    initialValue: formStore.state.baptismDate,
    keyboardType: TextInputType.number,
    onChanged: (value) {},
    onTap: () {
      selectDate(context).then((picked) {
        if (picked == null) return;
        formStore.setBaptismDate(
          convertDateFormatToDDMMYYYY(picked.toString()),
        );
      });
    },
    onValidator: validator.byField(formStore.state, 'baptismDate'),
    inputFormatters: [MaskedInputFormatter('##/##/####')],
  );
}

Widget birthdate(BuildContext context, FormMemberStore formStore) {
  final l10n = AppLocalizations.of(context)!;
  final validator = FormMemberValidator(l10n);
  return Input(
    label: l10n.member_register_birthdate_label,
    initialValue: formStore.state.birthdate,
    keyboardType: TextInputType.number,
    onChanged: (value) {},
    onTap: () {
      selectDate(context).then((picked) {
        if (picked == null) return;

        formStore.setBirthdate(convertDateFormatToDDMMYYYY(picked.toString()));
      });
    },
    onValidator: validator.byField(formStore.state, 'birthdate'),
    inputFormatters: [MaskedInputFormatter('##/##/####')],
  );
}

Widget active(BuildContext context, FormMemberStore formStore) {
  final l10n = AppLocalizations.of(context)!;
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        l10n.member_register_active_label,
        style: const TextStyle(fontSize: 16),
      ),
      const SizedBox(height: 8),
      Row(
        children: [
          Radio<bool>(
            value: true,
            groupValue: formStore.state.active,
            onChanged: (value) {
              if (value != null) {
                formStore.setActive(value);
              }
            },
          ),
          Text(l10n.member_register_yes),
          const SizedBox(width: 16),
          Radio<bool>(
            value: false,
            groupValue: formStore.state.active,
            onChanged: (value) {
              if (value != null) {
                formStore.setActive(value);
              }
            },
          ),
          Text(l10n.member_register_no),
        ],
      ),
    ],
  );
}
