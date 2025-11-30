import 'package:church_finance_bk/core/widgets/form_controls.dart';
import 'package:flutter/material.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';

import '../../../models/supplier_model.dart';
import '../store/form_supplier_store.dart';
import '../validators/form_supplier_register_validator.dart';

final validator = FormSupplierValidator();

Widget dni(FormSupplierStore formStore) {
  return Input(
    label: 'CPF/CNPJ',
    keyboardType: TextInputType.number,
    initialValue: formStore.state.dni,
    onChanged: (value) => formStore.setDni(value),
    onValidator: validator.byField(formStore.state, 'dni'),
    inputFormatters: [
      MaskedInputFormatter(
        '###.###.###-##',
      )
    ],
  );
}

Widget name(FormSupplierStore formStore) {
  return Input(
    label: 'Nome do Fornecedor',
    initialValue: formStore.state.name,
    onChanged: (value) => formStore.setName(value),
    onValidator: validator.byField(formStore.state, 'name'),
  );
}

Widget street(FormSupplierStore formStore) {
  return Input(
    label: 'Rua',
    initialValue: formStore.state.street,
    onChanged: (value) => formStore.setStreet(value),
    onValidator: validator.byField(formStore.state, 'street'),
  );
}

Widget number(FormSupplierStore formStore) {
  return Input(
    label: 'Número',
    initialValue: formStore.state.number,
    onChanged: (value) => formStore.setNumber(value),
    onValidator: validator.byField(formStore.state, 'number'),
  );
}

Widget city(FormSupplierStore formStore) {
  return Input(
    label: 'Cidade',
    initialValue: formStore.state.city,
    onChanged: (value) => formStore.setCity(value),
    onValidator: validator.byField(formStore.state, 'city'),
  );
}

Widget stateName(FormSupplierStore formStore) {
  return Input(
    label: 'Estado',
    initialValue: formStore.state.state,
    onChanged: (value) => formStore.setState(value),
    onValidator: validator.byField(formStore.state, 'state'),
  );
}

Widget zipCode(FormSupplierStore formStore) {
  return Input(
    label: 'CEP',
    keyboardType: TextInputType.number,
    initialValue: formStore.state.zipCode,
    onChanged: (value) => formStore.setZipCode(value),
    onValidator: validator.byField(formStore.state, 'zipCode'),
    inputFormatters: [
      MaskedInputFormatter(
        '#####-###',
      )
    ],
  );
}

Widget phone(FormSupplierStore formStore) {
  return Input(
    label: 'Telefone',
    keyboardType: TextInputType.phone,
    initialValue: formStore.state.phone,
    onChanged: (value) => formStore.setPhone(value),
    onValidator: validator.byField(formStore.state, 'phone'),
    inputFormatters: [
      MaskedInputFormatter(
        '(##) #####-####',
      )
    ],
  );
}

Widget email(FormSupplierStore formStore) {
  return Input(
    label: 'Email',
    keyboardType: TextInputType.emailAddress,
    initialValue: formStore.state.email,
    onChanged: (value) => formStore.setEmail(value),
    onValidator: validator.byField(formStore.state, 'email'),
  );
}

Widget supplierType(FormSupplierStore formStore) {
  // Encontrar el tipo de forma segura, con un valor por defecto
  String friendlyName = '';
  try {
    friendlyName = SupplierType.values
        .firstWhere((e) => e.apiValue == formStore.state.type)
        .friendlyName;
  } catch (e) {
    // Si no se encuentra, usar el valor por defecto (primer elemento del enum)
    friendlyName = SupplierType.SUPPLIER.friendlyName;
  }

  return Dropdown(
    label: 'Tipo de Fornecedor',
    initialValue: friendlyName,
    items: SupplierType.values.map((type) => type.friendlyName).toList(),
    onChanged: (value) {
      final type = SupplierType.values
          .firstWhere((e) => e.friendlyName == value)
          .apiValue;
      formStore.setType(type);
    },
    onValidator: validator.byField(formStore.state, 'type'),
  );
}
