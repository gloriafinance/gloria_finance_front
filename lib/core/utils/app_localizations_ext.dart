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
      case 'erp_menu_schedule':
        return erp_menu_schedule;
      case 'erp_menu_schedule_events':
        return erp_menu_schedule_events;
      default:
        return key;
    }
  }

  String translate(String key) {
    switch (key) {
      // ScheduleItemType keys
      case 'schedule_type_service':
        return schedule_type_service;
      case 'schedule_type_cell':
        return schedule_type_cell;
      case 'schedule_type_ministry_meeting':
        return schedule_type_ministry_meeting;
      case 'schedule_type_regular_event':
        return schedule_type_regular_event;
      case 'schedule_type_other':
        return schedule_type_other;

      // ScheduleVisibility keys
      case 'schedule_visibility_public':
        return schedule_visibility_public;
      case 'schedule_visibility_internal_leaders':
        return schedule_visibility_internal_leaders;

      // DayOfWeek keys
      case 'schedule_day_sunday':
        return schedule_day_sunday;
      case 'schedule_day_monday':
        return schedule_day_monday;
      case 'schedule_day_tuesday':
        return schedule_day_tuesday;
      case 'schedule_day_wednesday':
        return schedule_day_wednesday;
      case 'schedule_day_thursday':
        return schedule_day_thursday;
      case 'schedule_day_friday':
        return schedule_day_friday;
      case 'schedule_day_saturday':
        return schedule_day_saturday;

      default:
        return key; // Return the key itself if not found
    }
  }
}
