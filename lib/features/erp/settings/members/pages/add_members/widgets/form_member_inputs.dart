import 'package:gloria_finance/core/widgets/form_controls.dart';
import 'package:gloria_finance/core/utils/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';
import '../../../../../../../../l10n/app_localizations.dart';

import '../../../models/member_status.dart';
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

Widget status(BuildContext context, FormMemberStore formStore) {
  final l10n = AppLocalizations.of(context)!;

  final items = [
    MemberStatus.approved.value,
    MemberStatus.inactive.value,
    MemberStatus.pendingReview.value,
  ];

  String labelFor(String value) {
    return switch (value) {
      'APPROVED' => l10n.member_register_status_approved,
      'INACTIVE' => l10n.member_register_status_inactive,
      'PENDING_REVIEW' => l10n.member_register_status_pending_review,
      _ => value,
    };
  }

  return Dropdown(
    label: l10n.member_register_status_label,
    items: items,
    initialValue: formStore.state.status.value,
    itemLabelBuilder: labelFor,
    onChanged: (value) {
      if (value != null) {
        formStore.setStatus(MemberStatus.fromString(value));
      }
    },
  );
}
