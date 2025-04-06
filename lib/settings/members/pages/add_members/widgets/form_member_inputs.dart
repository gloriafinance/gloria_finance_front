import 'package:church_finance_bk/core/widgets/form_controls.dart';
import 'package:church_finance_bk/helpers/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';

import '../../../validator/form_member_validator.dart';
import '../store/form_member_store.dart';

final validator = FormMemberValidator();

Widget name(FormMemberStore formStore) {
  return Input(
    label: 'Nome completo',
    initialValue: formStore.state.name,
    onChanged: (value) => formStore.state.name = value,
    onValidator: validator.byField(formStore.state, 'name'),
  );
}

Widget email(FormMemberStore formStore) {
  return Input(
    label: 'Email',
    keyboardType: TextInputType.emailAddress,
    initialValue: formStore.state.email,
    onChanged: (value) => formStore.state.email = value,
    onValidator: validator.byField(formStore.state, 'email'),
  );
}

Widget phone(FormMemberStore formStore) {
  return Input(
    label: 'Telefone',
    keyboardType: TextInputType.number,
    initialValue: formStore.state.phone,
    onChanged: (value) => formStore.state.phone = value,
    onValidator: validator.byField(formStore.state, 'phone'),
    inputFormatters: [
      MaskedInputFormatter(
        '(##) #####-####',
      )
    ],
  );
}

Widget dni(FormMemberStore formStore) {
  return Input(
    label: 'CPF',
    keyboardType: TextInputType.number,
    initialValue: formStore.state.dni,
    onChanged: (value) => formStore.state.dni = value,
    onValidator: validator.byField(formStore.state, 'dni'),
    inputFormatters: [
      MaskedInputFormatter(
        '###.###.###-##',
      )
    ],
  );
}

Widget conversionDate(BuildContext context, FormMemberStore formStore) {
  return Input(
    label: 'Data de conversão',
    initialValue: formStore.state.conversionDate,
    keyboardType: TextInputType.number,
    onChanged: (value) {},
    onTap: () {
      selectDate(context).then((picked) {
        if (picked == null) return;

        formStore
            .setConversionDate(convertDateFormatToDDMMYYYY(picked.toString()));
      });
    },
    onValidator: validator.byField(formStore.state, 'conversionDate'),
  );
}

Widget baptismDate(BuildContext context, FormMemberStore formStore) {
  return Input(
    label: 'Data de batismo',
    initialValue: formStore.state.baptismDate,
    keyboardType: TextInputType.number,
    onChanged: (value) {},
    onTap: () {
      selectDate(context).then((picked) {
        if (picked == null) return;
        formStore
            .setBaptismDate(convertDateFormatToDDMMYYYY(picked.toString()));
      });
    },
    onValidator: validator.byField(formStore.state, 'baptismDate'),
  );
}

Widget birthdate(BuildContext context, FormMemberStore formStore) {
  return Input(
    label: 'Data de nascimento',
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
  );
}

Widget active(FormMemberStore formStore) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const Text('Ativo?', style: TextStyle(fontSize: 16)),
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
          const Text('Sim'),
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
          const Text('Não'),
        ],
      ),
    ],
  );
}
