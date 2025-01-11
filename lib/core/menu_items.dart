import 'package:church_finance_bk/finance/router.dart';
import 'package:flutter/material.dart';

List<Map<String, dynamic>> items = const [
  {
    "label": "Configuraçōes",
    "icon": Icons.settings,
    "items": [
      {"label": "Membros", "icon": Icons.people, "to": "/members"},
      {
        "label": "Conceitos de financeiros",
        "icon": Icons.attach_money,
        "to": "/banking-rail"
      },
    ],
  },
  {
    "label": "Seguridad del sistema",
    "icon": Icons.security,
    "items": [
      {
        "label": "Usuarios",
        "icon": Icons.person_add,
        "to": "/security-system/users"
      },
      {
        "label": "Perfiles de usuario",
        "icon": Icons.lock_open,
        "to": "/security-system/profiles"
      },
      {
        "label": "Módulos del sistema",
        "icon": Icons.menu,
        "to": "/security-system/system-modules"
      },
    ],
  },
];

final menuItems = [...items, ...financialMenuItems];
