import 'package:flutter/material.dart';

import 'form_member_inputs.dart';

Widget formMemberMobileLayout(BuildContext context) {
  return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
    SizedBox(height: 30),
    Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(child: name()),
        const SizedBox(width: 16),
        Expanded(child: dni()),
      ],
    ),
    Row(
      children: [
        Expanded(child: birthdate(context)),
        const SizedBox(width: 16),
        Expanded(child: phone()),
      ],
    ),
    Row(
      children: [
        Expanded(child: email()),
      ],
    ),
    Row(
      children: [
        Expanded(child: conversionDate(context)),
        const SizedBox(width: 16),
        Expanded(child: baptismDate(context)),
      ],
    )
  ]);
}
