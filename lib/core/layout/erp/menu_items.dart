// lib/core/menu_items.dart

import 'package:flutter/material.dart';

/// Estrutura base do menu ERP sem textos hard-coded.
///
/// Os labels devem ser resueltos em la UI usando AppLocalizations.
final List<Map<String, dynamic>> items = [
  {
    "key": "erp_menu_settings",
    "icon": Icons.settings,
    "items": [
      {
        "key": "erp_menu_settings_users_access",
        "icon": Icons.admin_panel_settings,
        "to": "/rbac/users",
      },
      {
        "key": "erp_menu_settings_roles_permissions",
        "icon": Icons.badge_outlined,
        "to": "/rbac/roles",
      },
      {
        "key": "erp_menu_settings_members",
        "icon": Icons.people,
        "to": "/members",
      },
      {
        "key": "erp_menu_settings_financial_periods",
        "icon": Icons.calendar_month_outlined,
        "to": "/financial-months",
      },
      {
        "key": "erp_menu_settings_availability_accounts",
        "icon": Icons.account_balance_wallet_outlined,
        "to": "/availability-accounts",
      },
      {
        "key": "erp_menu_settings_banks",
        "icon": Icons.account_balance,
        "to": "/banks",
      },
      {
        "key": "erp_menu_settings_cost_centers",
        "icon": Icons.account_tree,
        "to": "/cost-center",
      },
      {
        "key": "erp_menu_settings_suppliers",
        "icon": Icons.business,
        "to": "/suppliers",
      },
      {
        "key": "erp_menu_settings_financial_concepts",
        "icon": Icons.attach_money,
        "to": "/financial-concepts",
      },
    ],
  },
  {
    "key": "erp_menu_finance",
    "icon": Icons.monetization_on,
    "items": [
      {
        "key": "erp_menu_finance_contributions",
        "icon": Icons.bar_chart,
        "to": "/contributions_list",
      },
      {
        "key": "erp_menu_finance_records",
        "icon": Icons.money,
        "to": "/financial-record",
      },
      {
        "key": "erp_menu_finance_bank_reconciliation",
        "icon": Icons.account_balance_outlined,
        "to": "/finance/bank-statements",
      },
      {
        "key": "erp_menu_finance_accounts_receivable",
        "icon": Icons.account_balance_wallet,
        "to": "/accounts-receivables",
      },
      {
        "key": "erp_menu_finance_accounts_payable",
        "icon": Icons.payments_outlined,
        "to": "/accounts-payable/list",
      },
      {
        "key": "erp_menu_finance_purchases",
        "icon": Icons.sell_outlined,
        "to": "/purchase",
      },
    ],
  },
  {
    "key": "erp_menu_assets",
    "icon": Icons.inventory_2_outlined,
    "items": [
      {
        "key": "erp_menu_assets_items",
        "icon": Icons.account_balance,
        "to": "/patrimony/assets",
      },
    ],
  },
  {
    "key": "erp_menu_reports",
    "icon": Icons.insert_chart,
    "items": [
      {
        "key": "erp_menu_reports_monthly_tithes",
        "icon": Icons.bar_chart,
        "to": "/report/monthly-tithes",
      },
      {
        "key": "erp_menu_reports_income_statement",
        "icon": Icons.account_balance,
        "to": "/report/income-statement",
      },
      {
        "key": "erp_menu_reports_dre",
        "icon": Icons.assessment,
        "to": "/report/dre",
      },
    ],
  },
];

List<Map<String, dynamic>> menuItems(List<String> roles) {
  if (roles.contains('ADMIN')) {
    return items;
  }

  if (roles.contains('PASTOR') || roles.contains('TREASURER')) {
    return items.where((element) => element['key'] != 'erp_menu_settings').toList();
  }

  return [];
}
