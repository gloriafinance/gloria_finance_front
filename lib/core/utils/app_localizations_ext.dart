import 'package:flutter/widgets.dart';

import 'package:church_finance_bk/l10n/app_localizations.dart';

extension L10nX on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this)!;
}

extension L10nMenuX on AppLocalizations {
  String menuLabel(String key) {
    switch (key) {
      case 'erp_menu_settings':
        return erp_menu_settings;
      case 'erp_menu_settings_users_access':
        return erp_menu_settings_users_access;
      case 'erp_menu_settings_roles_permissions':
        return erp_menu_settings_roles_permissions;
      case 'erp_menu_settings_members':
        return erp_menu_settings_members;
      case 'erp_menu_settings_financial_periods':
        return erp_menu_settings_financial_periods;
      case 'erp_menu_settings_availability_accounts':
        return erp_menu_settings_availability_accounts;
      case 'erp_menu_settings_banks':
        return erp_menu_settings_banks;
      case 'erp_menu_settings_cost_centers':
        return erp_menu_settings_cost_centers;
      case 'erp_menu_settings_suppliers':
        return erp_menu_settings_suppliers;
      case 'erp_menu_settings_financial_concepts':
        return erp_menu_settings_financial_concepts;
      case 'erp_menu_finance':
        return erp_menu_finance;
      case 'erp_menu_finance_contributions':
        return erp_menu_finance_contributions;
      case 'erp_menu_finance_records':
        return erp_menu_finance_records;
      case 'erp_menu_finance_bank_reconciliation':
        return erp_menu_finance_bank_reconciliation;
      case 'erp_menu_finance_accounts_receivable':
        return erp_menu_finance_accounts_receivable;
      case 'erp_menu_finance_accounts_payable':
        return erp_menu_finance_accounts_payable;
      case 'erp_menu_finance_purchases':
        return erp_menu_finance_purchases;
      case 'erp_menu_assets':
        return erp_menu_assets;
      case 'erp_menu_assets_items':
        return erp_menu_assets_items;
      case 'erp_menu_reports':
        return erp_menu_reports;
      case 'erp_menu_reports_monthly_tithes':
        return erp_menu_reports_monthly_tithes;
      case 'erp_menu_reports_income_statement':
        return erp_menu_reports_income_statement;
      case 'erp_menu_reports_dre':
        return erp_menu_reports_dre;
      default:
        return key;
    }
  }
}
