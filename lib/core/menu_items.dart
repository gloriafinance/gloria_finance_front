// lib/core/menu_items.dart

import 'package:flutter/material.dart';

List<Map<String, dynamic>> items = const [
  {
    "label": "Configuraçōes",
    "icon": Icons.settings,
    "items": [
      {
        "label": "Usuários e acesso",
        "icon": Icons.admin_panel_settings,
        "to": "/rbac/users",
      },
      {
        "label": "Papéis e permissões",
        "icon": Icons.badge_outlined,
        "to": "/rbac/roles",
      },
      {"label": "Membros", "icon": Icons.people, "to": "/members"},
      {
        "label": "Períodos Financeiros",
        "icon": Icons.calendar_month_outlined,
        "to": "/financial-months",
      },
      {
        "label": "Contas de disponibilidade",
        "icon": Icons.account_balance_wallet_outlined,
        "to": "/availability-accounts",
      },
      {"label": "Bancos", "icon": Icons.account_balance, "to": "/banks"},
      {
        "label": "Centros de custo",
        "icon": Icons.account_tree,
        "to": "/cost-center",
      },
      {"label": "Fornecedores", "icon": Icons.business, "to": "/suppliers"},
      {
        "label": "Conceitos financeiros",
        "icon": Icons.attach_money,
        "to": "/financial-concepts",
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
        "to": "/contributions_list",
      },
      {
        "label": "Registro financeiros",
        "icon": Icons.money,
        "to": "/financial-record",
      },
      {
        "label": "Conciliação bancária",
        "icon": Icons.account_balance_outlined,
        "to": "/finance/bank-statements",
      },
      {
        "label": "Contas a receber",
        "icon": Icons.account_balance_wallet,
        "to": "/accounts-receivables",
      },
      {
        "label": "Contas a pagar",
        "icon": Icons.payments_outlined,
        "to": "/accounts-payable/list",
      },

      //TODO Registro de compras puede ser un mdulo.
      {"label": "Compras", "icon": Icons.sell_outlined, "to": "/purchase"},
    ],
  },
  {
    "label": "Patrimônio",
    "icon": Icons.inventory_2_outlined,
    "items": [
      {
        "label": "Bens patrimoniais",
        "icon": Icons.account_balance,
        "to": "/patrimony/assets",
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
        "to": "/report/monthly-tithes",
      },
      {
        "label": "Estado de Ingresos",
        "icon": Icons.account_balance,
        "to": "/report/income-statement",
      },
      {"label": "DRE", "icon": Icons.assessment, "to": "/report/dre"},
    ],
  },
];

List<Map<String, dynamic>> menuItems(List<String> roles) {
  if (roles.contains('ADMIN')) {
    return items;
  }

  if (roles.contains('PASTOR') || roles.contains('TREASURER')) {
    return items
        .where((element) => element['label'] != 'Configuraçōes')
        .toList();
  }

  return [];
}
