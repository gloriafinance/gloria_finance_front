import 'package:flutter/material.dart';

import '../store/form_member_store.dart';
import 'form_member_inputs.dart';

Widget formMemberMobileLayout(BuildContext context, FormMemberStore formStore) {
  return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
    SizedBox(height: 30),
    Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(child: name(formStore)),
        const SizedBox(width: 16),
        Expanded(child: dni(formStore)),
      ],
    ),
    Row(
      children: [
        Expanded(child: birthdate(context, formStore)),
        const SizedBox(width: 16),
        Expanded(child: phone(formStore)),
      ],
    ),
    Row(
      children: [
        Expanded(child: email(formStore)),
      ],
    ),
    Row(
      children: [
        Expanded(child: conversionDate(context, formStore)),
        const SizedBox(width: 16),
        Expanded(child: baptismDate(context, formStore)),
      ],
    ),
    Row(
      children: [
        Expanded(child: active(formStore)),
      ],
    ),
  ]);
}
