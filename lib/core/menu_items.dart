import 'package:church_finance_bk/finance/router.dart';
import 'package:flutter/material.dart';

List<Map<String, dynamic>> items = const [
  {
    "label": "Configuraçōes",
    "icon": Icons.settings,
    "items": [
      {
        "label": "Usuarios",
        "icon": Icons.person_add,
        "to": "/security-system/users"
      },
      {"label": "Membros", "icon": Icons.people, "to": "/members"},
      {
        "label": "Conceitos de financeiros",
        "icon": Icons.attach_money,
        "to": "/banking-rail"
      },
    ],
  },
];

final menuItems = [...items, ...financialMenuItems];
