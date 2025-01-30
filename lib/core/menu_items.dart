import 'package:flutter/material.dart';

import '../auth/auth_session_model.dart';

List<Map<String, dynamic>> items = const [
  {
    "label": "Configuraçōes",
    "icon": Icons.settings,
    "items": [
      // {
      //   "label": "Usuarios",
      //   "icon": Icons.person_add,
      //   "to": "/security-system/users"
      // },
      {"label": "Membros", "icon": Icons.people, "to": "/members"},
      // {
      //   "label": "Conceitos de financeiros",
      //   "icon": Icons.attach_money,
      //   "to": "/banking-rail"
      // },
    ],
  },
  {
    "label": "Finanzas",
    "icon": Icons.monetization_on,
    "items": [
      {
        "label": "Contribuiçōes",
        "icon": Icons.bar_chart,
        "to": "/contributions_list"
      },
      {
        "label": "Registro financeiros",
        "icon": Icons.money,
        "to": "/financial-record"
      },
    ],
  },
  {
    "label": "Relatórios",
    "icon": Icons.insert_chart,
    "items": [
      {
        "label": "Dízimos mensais",
        "icon": Icons.bar_chart,
        "to": "/report/monthly-tithes"
      },
    ],
  }
];

List<Map<String, dynamic>> menuItems(List<Profile> profiles) {
  if (profiles.where((p) => p.profileType == 'SUPERUSER').isNotEmpty) {
    return items;
  }

  if (profiles
      .where((p) => ['TREASURER', 'ADMINISTRATOR'].contains(p.profileType))
      .isNotEmpty) {
    return items
        .where((element) => element['label'] != 'Configuraçōes')
        .toList();
  }

  return [];
}
