import 'package:flutter/material.dart';

import '../../store/form_supplier_store.dart';
import '../form_supplier_inputs.dart';

Widget formSupplierMobileLayout(
    BuildContext context, FormSupplierStore formStore) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      SizedBox(height: 30),
      supplierType(formStore),
      dni(formStore),
      name(formStore),
      street(formStore),
      number(formStore),
      city(formStore),
      stateName(formStore),
      zipCode(formStore),
      phone(formStore),
      email(formStore),
    ],
  );
}
