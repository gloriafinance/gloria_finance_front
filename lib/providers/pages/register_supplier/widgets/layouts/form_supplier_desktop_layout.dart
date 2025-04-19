import 'package:flutter/material.dart';

import '../../store/form_supplier_store.dart';
import '../form_supplier_inputs.dart';

Widget formSupplierDesktopLayout(
    BuildContext context, FormSupplierStore formStore) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      SizedBox(height: 30),
      Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(child: supplierType(formStore)),
          const SizedBox(width: 16),
          Expanded(child: dni(formStore)),
          const SizedBox(width: 16),
          Expanded(flex: 2, child: name(formStore)),
        ],
      ),
      SizedBox(height: 16),
      Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(flex: 2, child: street(formStore)),
          const SizedBox(width: 16),
          Expanded(child: number(formStore)),
        ],
      ),
      SizedBox(height: 16),
      Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(child: city(formStore)),
          const SizedBox(width: 16),
          Expanded(child: stateName(formStore)),
          const SizedBox(width: 16),
          Expanded(child: zipCode(formStore)),
        ],
      ),
      SizedBox(height: 16),
      Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(child: phone(formStore)),
          const SizedBox(width: 16),
          Expanded(flex: 2, child: email(formStore)),
        ],
      ),
    ],
  );
}
