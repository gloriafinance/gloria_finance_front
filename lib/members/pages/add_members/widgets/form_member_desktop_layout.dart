import 'package:flutter/material.dart';

import 'form_member_inputs.dart';

Widget formMemberDesktopLayout(BuildContext context) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(child: birthdate(context)),
          const SizedBox(width: 16),
          Expanded(child: phone()),
          const SizedBox(width: 16),
          Expanded(child: email()),
        ],
      ),
      Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(width: 200, child: conversionDate(context)),
          const SizedBox(width: 16),
          SizedBox(width: 200, child: baptismDate(context)),
        ],
      ),
      const SizedBox(height: 16),
    ],
  );
}
