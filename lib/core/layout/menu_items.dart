import 'package:flutter/material.dart';

List<Map<String, dynamic>> menuItems = const [
  {
    "label": "Configuraçōes",
    "icon": Icons.settings,
    "items": [
      {"label": "Países", "icon": Icons.public, "to": "/country"},
      {
        "label": "Rieles de pago",
        "icon": Icons.attach_money,
        "to": "/banking-rail"
      },
      {
        "label": "Pares de intercambio",
        "icon": Icons.swap_horiz,
        "to": "/exchange-pairs"
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
        "label": "Movimientos financieros",
        "icon": Icons.money,
        "to": "/contributions"
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
