import 'package:flutter/material.dart';

import '../auth/auth_session_model.dart';

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
  {
    "label": "Finanzas",
    "icon": Icons.monetization_on,
    "items": [
      {
        "label": "Contribuiçōes",
        "icon": Icons.bar_chart,
        "to": "/contributions"
      },
      {
        "label": "Registro financeiros",
        "icon": Icons.money,
        "to": "/financial-record"
      },
    ],
  },
];

menuItems(List<Profile> profiles) {
  if (profiles.where((p) => p.profileType == 'SUPERUSER').isNotEmpty) {
    return items;
  }

  if (profiles.where((p) => p.profileType == 'ADMINISTRATOR').isNotEmpty) {
    return items
        .where((element) => element['label'] != 'Configuraçōes')
        .toList();
  }

  return [];

  //   return items
  //       .where((element) => element['label'] != 'Configuraçōes')
  //       .toList();
  // }
  // if (profile == 'admin') {
  //   return items;
  // } else {
  //   return items
  //       .where((element) => element['label'] != 'Configuraçōes')
  //       .toList();
  // }
}
