import 'package:church_finance_bk/features/erp//settings/members/pages/add_members/store/form_member_store.dart';
import 'package:flutter/material.dart';

import 'form_member_inputs.dart';

Widget formMemberDesktopLayout(
  BuildContext context,
  FormMemberStore formStore,
) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(child: birthdate(context, formStore)),
          const SizedBox(width: 16),
          Expanded(child: phone(formStore)),
          const SizedBox(width: 16),
          Expanded(child: email(formStore)),
        ],
      ),
      Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(width: 200, child: conversionDate(context, formStore)),
          const SizedBox(width: 16),
          SizedBox(width: 200, child: baptismDate(context, formStore)),
          const SizedBox(width: 16),
          SizedBox(
            width: 216,
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 25),
              child: active(formStore),
            ),
          ),
        ],
      ),
      const SizedBox(height: 16),
    ],
  );
}
