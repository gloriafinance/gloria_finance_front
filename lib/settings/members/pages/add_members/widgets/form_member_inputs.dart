import 'package:church_finance_bk/core/widgets/form_controls.dart';
import 'package:church_finance_bk/helpers/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';

import '../state/form_member_state.dart';
import '../validator/form_member_validator.dart';

final validator = FormMemberValidator();
final formMemberState = FormMemberState.init();

Widget name() {
  return ListenableBuilder(
    listenable: formMemberState,
    builder: (
      context,
      child,
    ) {
      return Input(
        label: 'Nome completo',
        initialValue: formMemberState.name,
        onChanged: (value) => formMemberState.name = value,
        onValidator: validator.byField(formMemberState, 'name'),
      );
    },
  );
}

Widget email() {
  return ListenableBuilder(
    listenable: formMemberState,
    builder: (
      context,
      child,
    ) {
      return Input(
        label: 'Email',
        keyboardType: TextInputType.emailAddress,
        initialValue: formMemberState.email,
        onChanged: (value) => formMemberState.email = value,
        onValidator: validator.byField(formMemberState, 'email'),
      );
    },
  );
}

Widget phone() {
  return ListenableBuilder(
    listenable: formMemberState,
    builder: (
      context,
      child,
    ) {
      return Input(
        label: 'Telefone',
        keyboardType: TextInputType.number,
        initialValue: formMemberState.phone,
        onChanged: (value) => formMemberState.phone = value,
        onValidator: validator.byField(formMemberState, 'phone'),
        inputFormatters: [
          MaskedInputFormatter(
            '(##) #####-####',
          )
        ],
      );
    },
  );
}

Widget dni() {
  return ListenableBuilder(
    listenable: formMemberState,
    builder: (
      context,
      child,
    ) {
      return Input(
        label: 'CPF',
        keyboardType: TextInputType.number,
        initialValue: formMemberState.dni,
        onChanged: (value) => formMemberState.dni = value,
        onValidator: validator.byField(formMemberState, 'dni'),
        inputFormatters: [
          MaskedInputFormatter(
            '###.###.###-##',
          )
        ],
      );
    },
  );
}

Widget conversionDate(BuildContext context) {
  return ListenableBuilder(
    listenable: formMemberState,
    builder: (
      context,
      child,
    ) {
      return Input(
        label: 'Data de conversão',
        initialValue: formMemberState.conversionDate,
        keyboardType: TextInputType.number,
        onChanged: (value) => formMemberState.conversionDate = value,
        onTap: () {
          selectDate(context).then((picked) {
            if (picked == null) return;
            formMemberState.copyWith(
                conversionDate: convertDateFormatToDDMMYYYY(picked.toString()));
          });
        },
        onValidator: validator.byField(formMemberState, 'conversionDate'),
      );
    },
  );
}

Widget baptismDate(BuildContext context) {
  return ListenableBuilder(
    listenable: formMemberState,
    builder: (
      context,
      child,
    ) {
      return Input(
        label: 'Data de batismo',
        initialValue: formMemberState.baptismDate,
        keyboardType: TextInputType.number,
        onChanged: (value) => formMemberState.baptismDate = value,
        onTap: () {
          selectDate(context).then((picked) {
            if (picked == null) return;
            formMemberState.copyWith(
                baptismDate: convertDateFormatToDDMMYYYY(picked.toString()));
          });
        },
        onValidator: validator.byField(formMemberState, 'baptismDate'),
      );
    },
  );
}

Widget birthdate(BuildContext context) {
  return ListenableBuilder(
    listenable: formMemberState,
    builder: (
      context,
      child,
    ) {
      return Input(
        label: 'Data de nascimento',
        initialValue: formMemberState.birthdate,
        keyboardType: TextInputType.number,
        onChanged: (value) => formMemberState.birthdate = value,
        onTap: () {
          selectDate(context).then((picked) {
            if (picked == null) return;
            formMemberState.copyWith(
                birthdate: convertDateFormatToDDMMYYYY(picked.toString()));
          });
        },
        onValidator: validator.byField(formMemberState, 'birthdate'),
      );
    },
  );
}
