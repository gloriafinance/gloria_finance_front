import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_pt.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('es'),
    Locale('pt')
  ];

  /// No description provided for @month_january.
  ///
  /// In en, this message translates to:
  /// **'January'**
  String get month_january;

  /// No description provided for @month_february.
  ///
  /// In en, this message translates to:
  /// **'February'**
  String get month_february;

  /// No description provided for @month_march.
  ///
  /// In en, this message translates to:
  /// **'March'**
  String get month_march;

  /// No description provided for @month_april.
  ///
  /// In en, this message translates to:
  /// **'April'**
  String get month_april;

  /// No description provided for @month_may.
  ///
  /// In en, this message translates to:
  /// **'May'**
  String get month_may;

  /// No description provided for @month_june.
  ///
  /// In en, this message translates to:
  /// **'June'**
  String get month_june;

  /// No description provided for @month_july.
  ///
  /// In en, this message translates to:
  /// **'July'**
  String get month_july;

  /// No description provided for @month_august.
  ///
  /// In en, this message translates to:
  /// **'August'**
  String get month_august;

  /// No description provided for @month_september.
  ///
  /// In en, this message translates to:
  /// **'September'**
  String get month_september;

  /// No description provided for @month_october.
  ///
  /// In en, this message translates to:
  /// **'October'**
  String get month_october;

  /// No description provided for @month_november.
  ///
  /// In en, this message translates to:
  /// **'November'**
  String get month_november;

  /// No description provided for @month_december.
  ///
  /// In en, this message translates to:
  /// **'December'**
  String get month_december;

  /// No description provided for @common_filters.
  ///
  /// In en, this message translates to:
  /// **'Filters'**
  String get common_filters;

  /// No description provided for @common_filters_upper.
  ///
  /// In en, this message translates to:
  /// **'FILTERS'**
  String get common_filters_upper;

  /// No description provided for @common_all_banks.
  ///
  /// In en, this message translates to:
  /// **'All banks'**
  String get common_all_banks;

  /// No description provided for @common_all_status.
  ///
  /// In en, this message translates to:
  /// **'All statuses'**
  String get common_all_status;

  /// No description provided for @common_all_months.
  ///
  /// In en, this message translates to:
  /// **'All months'**
  String get common_all_months;

  /// No description provided for @common_all_years.
  ///
  /// In en, this message translates to:
  /// **'All years'**
  String get common_all_years;

  /// No description provided for @common_bank.
  ///
  /// In en, this message translates to:
  /// **'Bank'**
  String get common_bank;

  /// No description provided for @common_status.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get common_status;

  /// No description provided for @common_start_date.
  ///
  /// In en, this message translates to:
  /// **'Start date'**
  String get common_start_date;

  /// No description provided for @common_end_date.
  ///
  /// In en, this message translates to:
  /// **'End date'**
  String get common_end_date;

  /// No description provided for @common_month.
  ///
  /// In en, this message translates to:
  /// **'Month'**
  String get common_month;

  /// No description provided for @common_year.
  ///
  /// In en, this message translates to:
  /// **'Year'**
  String get common_year;

  /// No description provided for @common_clear_filters.
  ///
  /// In en, this message translates to:
  /// **'Clear filters'**
  String get common_clear_filters;

  /// No description provided for @common_loading.
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get common_loading;

  /// No description provided for @common_apply_filters.
  ///
  /// In en, this message translates to:
  /// **'Apply filters'**
  String get common_apply_filters;

  /// No description provided for @common_load_more.
  ///
  /// In en, this message translates to:
  /// **'Load more'**
  String get common_load_more;

  /// No description provided for @common_no_results_found.
  ///
  /// In en, this message translates to:
  /// **'No results found'**
  String get common_no_results_found;

  /// No description provided for @common_search_hint.
  ///
  /// In en, this message translates to:
  /// **'Search...'**
  String get common_search_hint;

  /// No description provided for @common_actions.
  ///
  /// In en, this message translates to:
  /// **'Actions'**
  String get common_actions;

  /// No description provided for @common_edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get common_edit;

  /// No description provided for @auth_login_email_label.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get auth_login_email_label;

  /// No description provided for @auth_login_password_label.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get auth_login_password_label;

  /// No description provided for @auth_login_forgot_password.
  ///
  /// In en, this message translates to:
  /// **'Forgot your password?'**
  String get auth_login_forgot_password;

  /// No description provided for @auth_login_submit.
  ///
  /// In en, this message translates to:
  /// **'Sign in'**
  String get auth_login_submit;

  /// No description provided for @auth_login_error_invalid_email.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid email address'**
  String get auth_login_error_invalid_email;

  /// No description provided for @auth_login_error_required_password.
  ///
  /// In en, this message translates to:
  /// **'Enter your password'**
  String get auth_login_error_required_password;

  /// No description provided for @auth_error_generic.
  ///
  /// In en, this message translates to:
  /// **'An internal system error occurred, please contact your system administrator'**
  String get auth_error_generic;

  /// No description provided for @auth_recovery_request_title.
  ///
  /// In en, this message translates to:
  /// **'Enter the email associated with your account and we will send you a temporary password.'**
  String get auth_recovery_request_title;

  /// No description provided for @auth_recovery_request_loading.
  ///
  /// In en, this message translates to:
  /// **'Requesting temporary password'**
  String get auth_recovery_request_loading;

  /// No description provided for @auth_recovery_request_submit.
  ///
  /// In en, this message translates to:
  /// **'Send'**
  String get auth_recovery_request_submit;

  /// No description provided for @auth_recovery_request_email_required.
  ///
  /// In en, this message translates to:
  /// **'Email is required'**
  String get auth_recovery_request_email_required;

  /// No description provided for @auth_recovery_change_title.
  ///
  /// In en, this message translates to:
  /// **'Set a new password'**
  String get auth_recovery_change_title;

  /// No description provided for @auth_recovery_change_description.
  ///
  /// In en, this message translates to:
  /// **'Create a new password. Make sure it is different from previous ones for security'**
  String get auth_recovery_change_description;

  /// No description provided for @auth_recovery_old_password_label.
  ///
  /// In en, this message translates to:
  /// **'Current password'**
  String get auth_recovery_old_password_label;

  /// No description provided for @auth_recovery_new_password_label.
  ///
  /// In en, this message translates to:
  /// **'New password'**
  String get auth_recovery_new_password_label;

  /// No description provided for @auth_recovery_change_error_old_password_required.
  ///
  /// In en, this message translates to:
  /// **'Enter your current password'**
  String get auth_recovery_change_error_old_password_required;

  /// No description provided for @auth_recovery_change_error_new_password_required.
  ///
  /// In en, this message translates to:
  /// **'Enter a new password'**
  String get auth_recovery_change_error_new_password_required;

  /// No description provided for @auth_recovery_change_error_min_length.
  ///
  /// In en, this message translates to:
  /// **'The password must be at least 8 characters long'**
  String get auth_recovery_change_error_min_length;

  /// No description provided for @auth_recovery_change_error_lowercase.
  ///
  /// In en, this message translates to:
  /// **'The password must contain at least one lowercase letter'**
  String get auth_recovery_change_error_lowercase;

  /// No description provided for @auth_recovery_change_error_uppercase.
  ///
  /// In en, this message translates to:
  /// **'The password must contain at least one uppercase letter'**
  String get auth_recovery_change_error_uppercase;

  /// No description provided for @auth_recovery_change_error_number.
  ///
  /// In en, this message translates to:
  /// **'The password must contain at least one number'**
  String get auth_recovery_change_error_number;

  /// No description provided for @auth_recovery_success_title.
  ///
  /// In en, this message translates to:
  /// **'Check your email'**
  String get auth_recovery_success_title;

  /// No description provided for @auth_recovery_success_body.
  ///
  /// In en, this message translates to:
  /// **'We sent a temporary password to {email}. If you do not see it, check your spam folder. If you have already received it, click the button below.'**
  String auth_recovery_success_body(String email);

  /// No description provided for @auth_recovery_success_continue.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get auth_recovery_success_continue;

  /// No description provided for @auth_recovery_success_resend.
  ///
  /// In en, this message translates to:
  /// **'Haven\'t received the email yet? Resend email'**
  String get auth_recovery_success_resend;

  /// No description provided for @auth_recovery_success_resend_ok.
  ///
  /// In en, this message translates to:
  /// **'Email resent successfully'**
  String get auth_recovery_success_resend_ok;

  /// No description provided for @auth_recovery_success_resend_error.
  ///
  /// In en, this message translates to:
  /// **'Error while resending email'**
  String get auth_recovery_success_resend_error;

  /// No description provided for @auth_recovery_back_to_login.
  ///
  /// In en, this message translates to:
  /// **'Back to login'**
  String get auth_recovery_back_to_login;

  /// No description provided for @auth_policies_title.
  ///
  /// In en, this message translates to:
  /// **'Before continuing, please review and accept Glória Finance policies'**
  String get auth_policies_title;

  /// No description provided for @auth_policies_info_title.
  ///
  /// In en, this message translates to:
  /// **'Important information:'**
  String get auth_policies_info_title;

  /// No description provided for @auth_policies_info_body.
  ///
  /// In en, this message translates to:
  /// **'• The church and Glória Finance process personal and sensitive data in order for the system to work.\n\n• In accordance with the Brazilian General Data Protection Law (LGPD), you must accept the policies below to continue using the platform.\n\n• Click the links to read the full text before accepting.'**
  String get auth_policies_info_body;

  /// No description provided for @auth_policies_privacy.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get auth_policies_privacy;

  /// No description provided for @auth_policies_sensitive.
  ///
  /// In en, this message translates to:
  /// **'Sensitive Data Processing Policy'**
  String get auth_policies_sensitive;

  /// No description provided for @auth_policies_accept_and_continue.
  ///
  /// In en, this message translates to:
  /// **'Accept and continue'**
  String get auth_policies_accept_and_continue;

  /// No description provided for @auth_policies_link_error.
  ///
  /// In en, this message translates to:
  /// **'Could not open link: {url}'**
  String auth_policies_link_error(String url);

  /// No description provided for @auth_policies_checkbox_prefix.
  ///
  /// In en, this message translates to:
  /// **'I have read and agree with the '**
  String get auth_policies_checkbox_prefix;

  /// No description provided for @auth_layout_version_loading.
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get auth_layout_version_loading;

  /// No description provided for @auth_layout_footer.
  ///
  /// In en, this message translates to:
  /// **'© {year} Jaspesoft CNPJ 43.716.343/0001-60 '**
  String auth_layout_footer(int year);

  /// No description provided for @erp_menu_settings.
  ///
  /// In en, this message translates to:
  /// **'Financial Settings'**
  String get erp_menu_settings;

  /// No description provided for @erp_menu_settings_security.
  ///
  /// In en, this message translates to:
  /// **'Security Settings'**
  String get erp_menu_settings_security;

  /// No description provided for @erp_menu_settings_users_access.
  ///
  /// In en, this message translates to:
  /// **'Users and access'**
  String get erp_menu_settings_users_access;

  /// No description provided for @erp_menu_settings_roles_permissions.
  ///
  /// In en, this message translates to:
  /// **'Roles and permissions'**
  String get erp_menu_settings_roles_permissions;

  /// No description provided for @erp_menu_settings_members.
  ///
  /// In en, this message translates to:
  /// **'Members'**
  String get erp_menu_settings_members;

  /// No description provided for @erp_menu_settings_financial_periods.
  ///
  /// In en, this message translates to:
  /// **'Financial periods'**
  String get erp_menu_settings_financial_periods;

  /// No description provided for @erp_menu_settings_availability_accounts.
  ///
  /// In en, this message translates to:
  /// **'Availability accounts'**
  String get erp_menu_settings_availability_accounts;

  /// No description provided for @erp_menu_settings_banks.
  ///
  /// In en, this message translates to:
  /// **'Banks'**
  String get erp_menu_settings_banks;

  /// No description provided for @erp_menu_settings_cost_centers.
  ///
  /// In en, this message translates to:
  /// **'Cost centers'**
  String get erp_menu_settings_cost_centers;

  /// No description provided for @erp_menu_settings_suppliers.
  ///
  /// In en, this message translates to:
  /// **'Suppliers'**
  String get erp_menu_settings_suppliers;

  /// No description provided for @erp_menu_settings_financial_concepts.
  ///
  /// In en, this message translates to:
  /// **'Financial concepts'**
  String get erp_menu_settings_financial_concepts;

  /// No description provided for @erp_menu_finance.
  ///
  /// In en, this message translates to:
  /// **'Finance'**
  String get erp_menu_finance;

  /// No description provided for @erp_menu_finance_contributions.
  ///
  /// In en, this message translates to:
  /// **'Contributions'**
  String get erp_menu_finance_contributions;

  /// No description provided for @erp_menu_finance_records.
  ///
  /// In en, this message translates to:
  /// **'Financial records'**
  String get erp_menu_finance_records;

  /// No description provided for @erp_menu_finance_bank_reconciliation.
  ///
  /// In en, this message translates to:
  /// **'Bank reconciliation'**
  String get erp_menu_finance_bank_reconciliation;

  /// No description provided for @erp_menu_finance_accounts_receivable.
  ///
  /// In en, this message translates to:
  /// **'Accounts receivable'**
  String get erp_menu_finance_accounts_receivable;

  /// No description provided for @erp_menu_finance_accounts_payable.
  ///
  /// In en, this message translates to:
  /// **'Accounts payable'**
  String get erp_menu_finance_accounts_payable;

  /// No description provided for @erp_menu_finance_purchases.
  ///
  /// In en, this message translates to:
  /// **'Purchases'**
  String get erp_menu_finance_purchases;

  /// No description provided for @erp_menu_assets.
  ///
  /// In en, this message translates to:
  /// **'Assets'**
  String get erp_menu_assets;

  /// No description provided for @erp_menu_assets_items.
  ///
  /// In en, this message translates to:
  /// **'Asset items'**
  String get erp_menu_assets_items;

  /// No description provided for @erp_menu_reports.
  ///
  /// In en, this message translates to:
  /// **'Reports'**
  String get erp_menu_reports;

  /// No description provided for @erp_menu_reports_monthly_tithes.
  ///
  /// In en, this message translates to:
  /// **'Monthly tithes'**
  String get erp_menu_reports_monthly_tithes;

  /// No description provided for @erp_menu_reports_income_statement.
  ///
  /// In en, this message translates to:
  /// **'Income statement'**
  String get erp_menu_reports_income_statement;

  /// No description provided for @erp_menu_reports_dre.
  ///
  /// In en, this message translates to:
  /// **'DRE'**
  String get erp_menu_reports_dre;

  /// No description provided for @common_cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get common_cancel;

  /// No description provided for @common_retry.
  ///
  /// In en, this message translates to:
  /// **'Reload'**
  String get common_retry;

  /// No description provided for @common_processing.
  ///
  /// In en, this message translates to:
  /// **'Processing...'**
  String get common_processing;

  /// No description provided for @patrimony_assets_list_title.
  ///
  /// In en, this message translates to:
  /// **'Assets'**
  String get patrimony_assets_list_title;

  /// No description provided for @patrimony_assets_list_new.
  ///
  /// In en, this message translates to:
  /// **'Register asset'**
  String get patrimony_assets_list_new;

  /// No description provided for @patrimony_assets_filter_category.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get patrimony_assets_filter_category;

  /// No description provided for @patrimony_assets_table_error_loading.
  ///
  /// In en, this message translates to:
  /// **'Could not load assets. Please try again.'**
  String get patrimony_assets_table_error_loading;

  /// No description provided for @patrimony_assets_table_empty.
  ///
  /// In en, this message translates to:
  /// **'No assets found for the selected filters.'**
  String get patrimony_assets_table_empty;

  /// No description provided for @patrimony_assets_table_header_code.
  ///
  /// In en, this message translates to:
  /// **'Code'**
  String get patrimony_assets_table_header_code;

  /// No description provided for @patrimony_assets_table_header_name.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get patrimony_assets_table_header_name;

  /// No description provided for @patrimony_assets_table_header_category.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get patrimony_assets_table_header_category;

  /// No description provided for @patrimony_assets_table_header_value.
  ///
  /// In en, this message translates to:
  /// **'Value'**
  String get patrimony_assets_table_header_value;

  /// No description provided for @patrimony_assets_table_header_acquisition.
  ///
  /// In en, this message translates to:
  /// **'Acquisition'**
  String get patrimony_assets_table_header_acquisition;

  /// No description provided for @patrimony_assets_table_header_location.
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get patrimony_assets_table_header_location;

  /// No description provided for @patrimony_inventory_import_file_label.
  ///
  /// In en, this message translates to:
  /// **'Filled CSV file'**
  String get patrimony_inventory_import_file_label;

  /// No description provided for @patrimony_inventory_import_file_size.
  ///
  /// In en, this message translates to:
  /// **'Size: {size} KB'**
  String patrimony_inventory_import_file_size(int size);

  /// No description provided for @patrimony_inventory_import_description_title.
  ///
  /// In en, this message translates to:
  /// **'Upload the completed physical checklist to update the assets.'**
  String get patrimony_inventory_import_description_title;

  /// No description provided for @patrimony_inventory_import_description_body.
  ///
  /// In en, this message translates to:
  /// **'Make sure the columns \"Asset ID\", \"Inventory code\" and \"Inventory quantity\" are filled in. Optional fields such as status and notes will also be processed when provided.'**
  String get patrimony_inventory_import_description_body;

  /// No description provided for @patrimony_inventory_import_button_loading.
  ///
  /// In en, this message translates to:
  /// **'Importing...'**
  String get patrimony_inventory_import_button_loading;

  /// No description provided for @patrimony_inventory_import_button_submit.
  ///
  /// In en, this message translates to:
  /// **'Import checklist'**
  String get patrimony_inventory_import_button_submit;

  /// No description provided for @patrimony_inventory_import_error_no_file.
  ///
  /// In en, this message translates to:
  /// **'Select the exported file before importing.'**
  String get patrimony_inventory_import_error_no_file;

  /// No description provided for @patrimony_inventory_import_error_read_file.
  ///
  /// In en, this message translates to:
  /// **'Could not read the selected file.'**
  String get patrimony_inventory_import_error_read_file;

  /// No description provided for @patrimony_inventory_import_error_generic.
  ///
  /// In en, this message translates to:
  /// **'Could not import the checklist. Please try again.'**
  String get patrimony_inventory_import_error_generic;

  /// No description provided for @patrimony_asset_detail_tab_details.
  ///
  /// In en, this message translates to:
  /// **'Details'**
  String get patrimony_asset_detail_tab_details;

  /// No description provided for @patrimony_asset_detail_tab_history.
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get patrimony_asset_detail_tab_history;

  /// No description provided for @patrimony_asset_detail_category.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get patrimony_asset_detail_category;

  /// No description provided for @patrimony_asset_detail_quantity.
  ///
  /// In en, this message translates to:
  /// **'Quantity'**
  String get patrimony_asset_detail_quantity;

  /// No description provided for @patrimony_asset_detail_acquisition_date.
  ///
  /// In en, this message translates to:
  /// **'Acquisition date'**
  String get patrimony_asset_detail_acquisition_date;

  /// No description provided for @patrimony_asset_detail_location.
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get patrimony_asset_detail_location;

  /// No description provided for @patrimony_asset_detail_responsible.
  ///
  /// In en, this message translates to:
  /// **'Responsible'**
  String get patrimony_asset_detail_responsible;

  /// No description provided for @patrimony_asset_detail_pending_documents.
  ///
  /// In en, this message translates to:
  /// **'Pending documents'**
  String get patrimony_asset_detail_pending_documents;

  /// No description provided for @patrimony_asset_detail_notes.
  ///
  /// In en, this message translates to:
  /// **'Notes'**
  String get patrimony_asset_detail_notes;

  /// No description provided for @patrimony_asset_detail_quantity_badge.
  ///
  /// In en, this message translates to:
  /// **'Qty: {quantity}'**
  String patrimony_asset_detail_quantity_badge(int quantity);

  /// No description provided for @patrimony_asset_detail_updated_at.
  ///
  /// In en, this message translates to:
  /// **'Updated at {date}'**
  String patrimony_asset_detail_updated_at(String date);

  /// No description provided for @patrimony_asset_detail_inventory_register.
  ///
  /// In en, this message translates to:
  /// **'Register inventory'**
  String get patrimony_asset_detail_inventory_register;

  /// No description provided for @patrimony_asset_detail_inventory_update.
  ///
  /// In en, this message translates to:
  /// **'Update inventory'**
  String get patrimony_asset_detail_inventory_update;

  /// No description provided for @patrimony_asset_detail_inventory_modal_title.
  ///
  /// In en, this message translates to:
  /// **'Register physical inventory'**
  String get patrimony_asset_detail_inventory_modal_title;

  /// No description provided for @patrimony_asset_detail_inventory_success.
  ///
  /// In en, this message translates to:
  /// **'Inventory registered successfully.'**
  String get patrimony_asset_detail_inventory_success;

  /// No description provided for @patrimony_asset_detail_disposal_register.
  ///
  /// In en, this message translates to:
  /// **'Register disposal'**
  String get patrimony_asset_detail_disposal_register;

  /// No description provided for @patrimony_asset_detail_disposal_modal_title.
  ///
  /// In en, this message translates to:
  /// **'Register disposal'**
  String get patrimony_asset_detail_disposal_modal_title;

  /// No description provided for @patrimony_asset_detail_disposal_success.
  ///
  /// In en, this message translates to:
  /// **'Disposal registered'**
  String get patrimony_asset_detail_disposal_success;

  /// No description provided for @patrimony_asset_detail_disposal_error.
  ///
  /// In en, this message translates to:
  /// **'Error while registering disposal'**
  String get patrimony_asset_detail_disposal_error;

  /// No description provided for @patrimony_asset_detail_disposal_status.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get patrimony_asset_detail_disposal_status;

  /// No description provided for @patrimony_asset_detail_disposal_reason.
  ///
  /// In en, this message translates to:
  /// **'Reason'**
  String get patrimony_asset_detail_disposal_reason;

  /// No description provided for @patrimony_asset_detail_disposal_date.
  ///
  /// In en, this message translates to:
  /// **'Disposal date'**
  String get patrimony_asset_detail_disposal_date;

  /// No description provided for @patrimony_asset_detail_disposal_performed_by.
  ///
  /// In en, this message translates to:
  /// **'Registered by'**
  String get patrimony_asset_detail_disposal_performed_by;

  /// No description provided for @patrimony_asset_detail_disposal_value.
  ///
  /// In en, this message translates to:
  /// **'Disposal value'**
  String get patrimony_asset_detail_disposal_value;

  /// No description provided for @patrimony_asset_detail_inventory_result.
  ///
  /// In en, this message translates to:
  /// **'Result'**
  String get patrimony_asset_detail_inventory_result;

  /// No description provided for @patrimony_asset_detail_inventory_checked_at.
  ///
  /// In en, this message translates to:
  /// **'Check date'**
  String get patrimony_asset_detail_inventory_checked_at;

  /// No description provided for @patrimony_asset_detail_inventory_checked_by.
  ///
  /// In en, this message translates to:
  /// **'Checked by'**
  String get patrimony_asset_detail_inventory_checked_by;

  /// No description provided for @patrimony_asset_detail_inventory_title.
  ///
  /// In en, this message translates to:
  /// **'Physical inventory'**
  String get patrimony_asset_detail_inventory_title;

  /// No description provided for @patrimony_asset_detail_attachments_empty.
  ///
  /// In en, this message translates to:
  /// **'No attachments available.'**
  String get patrimony_asset_detail_attachments_empty;

  /// No description provided for @patrimony_asset_detail_attachments_title.
  ///
  /// In en, this message translates to:
  /// **'Attachments'**
  String get patrimony_asset_detail_attachments_title;

  /// No description provided for @patrimony_asset_detail_attachment_view_pdf.
  ///
  /// In en, this message translates to:
  /// **'View PDF'**
  String get patrimony_asset_detail_attachment_view_pdf;

  /// No description provided for @patrimony_asset_detail_attachment_open.
  ///
  /// In en, this message translates to:
  /// **'Open'**
  String get patrimony_asset_detail_attachment_open;

  /// No description provided for @patrimony_asset_detail_history_empty.
  ///
  /// In en, this message translates to:
  /// **'No change history.'**
  String get patrimony_asset_detail_history_empty;

  /// No description provided for @patrimony_asset_detail_history_title.
  ///
  /// In en, this message translates to:
  /// **'Movement history'**
  String get patrimony_asset_detail_history_title;

  /// No description provided for @patrimony_asset_detail_history_changes_title.
  ///
  /// In en, this message translates to:
  /// **'Registered changes'**
  String get patrimony_asset_detail_history_changes_title;

  /// No description provided for @patrimony_asset_detail_yes.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get patrimony_asset_detail_yes;

  /// No description provided for @patrimony_asset_detail_no.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get patrimony_asset_detail_no;

  /// No description provided for @erp_header_change_password.
  ///
  /// In en, this message translates to:
  /// **'Change password'**
  String get erp_header_change_password;

  /// No description provided for @erp_header_logout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get erp_header_logout;

  /// No description provided for @auth_policies_submit_error_null.
  ///
  /// In en, this message translates to:
  /// **'Could not register your acceptance. Please try again.'**
  String get auth_policies_submit_error_null;

  /// No description provided for @auth_policies_submit_error_generic.
  ///
  /// In en, this message translates to:
  /// **'An error occurred while registering your acceptance. Please try again.'**
  String get auth_policies_submit_error_generic;

  /// No description provided for @auth_recovery_step_title_request.
  ///
  /// In en, this message translates to:
  /// **'Send temporary password'**
  String get auth_recovery_step_title_request;

  /// No description provided for @auth_recovery_step_title_confirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm receipt of temporary password'**
  String get auth_recovery_step_title_confirm;

  /// No description provided for @auth_recovery_step_title_new_password.
  ///
  /// In en, this message translates to:
  /// **'Set new password'**
  String get auth_recovery_step_title_new_password;

  /// No description provided for @erp_home_welcome_member.
  ///
  /// In en, this message translates to:
  /// **'Welcome to Church Finance!\\n\\n'**
  String get erp_home_welcome_member;

  /// No description provided for @erp_home_no_availability_accounts.
  ///
  /// In en, this message translates to:
  /// **'No availability accounts found'**
  String get erp_home_no_availability_accounts;

  /// No description provided for @erp_home_availability_summary_title.
  ///
  /// In en, this message translates to:
  /// **'Availability accounts summary'**
  String get erp_home_availability_summary_title;

  /// No description provided for @erp_home_availability_swipe_hint.
  ///
  /// In en, this message translates to:
  /// **'Swipe to see all accounts'**
  String get erp_home_availability_swipe_hint;

  /// No description provided for @erp_home_header_title.
  ///
  /// In en, this message translates to:
  /// **'Dashboard'**
  String get erp_home_header_title;

  /// No description provided for @settings_banks_title.
  ///
  /// In en, this message translates to:
  /// **'Banks'**
  String get settings_banks_title;

  /// No description provided for @settings_banks_new_bank.
  ///
  /// In en, this message translates to:
  /// **'New bank'**
  String get settings_banks_new_bank;

  /// No description provided for @settings_banks_form_title_create.
  ///
  /// In en, this message translates to:
  /// **'New bank'**
  String get settings_banks_form_title_create;

  /// No description provided for @settings_banks_form_title_edit.
  ///
  /// In en, this message translates to:
  /// **'Edit bank'**
  String get settings_banks_form_title_edit;

  /// No description provided for @settings_banks_field_name.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get settings_banks_field_name;

  /// No description provided for @settings_banks_field_holder_name.
  ///
  /// In en, this message translates to:
  /// **'Account holder name'**
  String get settings_banks_field_holder_name;

  /// No description provided for @settings_banks_field_document_id.
  ///
  /// In en, this message translates to:
  /// **'Document ID'**
  String get settings_banks_field_document_id;

  /// No description provided for @settings_banks_field_tag.
  ///
  /// In en, this message translates to:
  /// **'Tag'**
  String get settings_banks_field_tag;

  /// No description provided for @settings_banks_field_account_type.
  ///
  /// In en, this message translates to:
  /// **'Account type'**
  String get settings_banks_field_account_type;

  /// No description provided for @settings_banks_field_pix_key.
  ///
  /// In en, this message translates to:
  /// **'PIX key'**
  String get settings_banks_field_pix_key;

  /// No description provided for @settings_banks_field_bank_code.
  ///
  /// In en, this message translates to:
  /// **'Bank code'**
  String get settings_banks_field_bank_code;

  /// No description provided for @settings_banks_field_agency.
  ///
  /// In en, this message translates to:
  /// **'Branch'**
  String get settings_banks_field_agency;

  /// No description provided for @settings_banks_field_account.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get settings_banks_field_account;

  /// No description provided for @settings_banks_field_active.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get settings_banks_field_active;

  /// No description provided for @settings_banks_error_required.
  ///
  /// In en, this message translates to:
  /// **'Required field'**
  String get settings_banks_error_required;

  /// No description provided for @settings_banks_error_invalid_number.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid number'**
  String get settings_banks_error_invalid_number;

  /// No description provided for @settings_banks_error_select_account_type.
  ///
  /// In en, this message translates to:
  /// **'Select an account type'**
  String get settings_banks_error_select_account_type;

  /// No description provided for @settings_banks_save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get settings_banks_save;

  /// No description provided for @settings_banks_toast_saved.
  ///
  /// In en, this message translates to:
  /// **'Record saved successfully'**
  String get settings_banks_toast_saved;

  /// No description provided for @settings_availability_list_title.
  ///
  /// In en, this message translates to:
  /// **'Accounts list'**
  String get settings_availability_list_title;

  /// No description provided for @settings_availability_new_account.
  ///
  /// In en, this message translates to:
  /// **'Availability account'**
  String get settings_availability_new_account;

  /// No description provided for @settings_availability_form_title.
  ///
  /// In en, this message translates to:
  /// **'Register availability account'**
  String get settings_availability_form_title;

  /// No description provided for @settings_availability_save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get settings_availability_save;

  /// No description provided for @settings_availability_toast_saved.
  ///
  /// In en, this message translates to:
  /// **'Record saved successfully'**
  String get settings_availability_toast_saved;

  /// No description provided for @settings_cost_center_title.
  ///
  /// In en, this message translates to:
  /// **'Cost centers'**
  String get settings_cost_center_title;

  /// No description provided for @settings_cost_center_new.
  ///
  /// In en, this message translates to:
  /// **'New cost center'**
  String get settings_cost_center_new;

  /// No description provided for @settings_cost_center_field_code.
  ///
  /// In en, this message translates to:
  /// **'Code'**
  String get settings_cost_center_field_code;

  /// No description provided for @settings_cost_center_field_name.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get settings_cost_center_field_name;

  /// No description provided for @settings_cost_center_field_category.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get settings_cost_center_field_category;

  /// No description provided for @settings_cost_center_field_responsible.
  ///
  /// In en, this message translates to:
  /// **'Responsible'**
  String get settings_cost_center_field_responsible;

  /// No description provided for @settings_cost_center_field_description.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get settings_cost_center_field_description;

  /// No description provided for @settings_cost_center_field_active.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get settings_cost_center_field_active;

  /// No description provided for @settings_cost_center_error_required.
  ///
  /// In en, this message translates to:
  /// **'Required field'**
  String get settings_cost_center_error_required;

  /// No description provided for @settings_cost_center_error_select_category.
  ///
  /// In en, this message translates to:
  /// **'Select a category'**
  String get settings_cost_center_error_select_category;

  /// No description provided for @settings_cost_center_error_select_responsible.
  ///
  /// In en, this message translates to:
  /// **'Select a responsible member'**
  String get settings_cost_center_error_select_responsible;

  /// No description provided for @settings_cost_center_help_code.
  ///
  /// In en, this message translates to:
  /// **'Use an easy-to-remember code with up to {maxLength} characters.'**
  String settings_cost_center_help_code(int maxLength);

  /// No description provided for @settings_cost_center_help_description.
  ///
  /// In en, this message translates to:
  /// **'Describe briefly how this cost center will be used.'**
  String get settings_cost_center_help_description;

  /// No description provided for @settings_cost_center_save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get settings_cost_center_save;

  /// No description provided for @settings_cost_center_update.
  ///
  /// In en, this message translates to:
  /// **'Update'**
  String get settings_cost_center_update;

  /// No description provided for @settings_cost_center_toast_saved.
  ///
  /// In en, this message translates to:
  /// **'Record saved successfully'**
  String get settings_cost_center_toast_saved;

  /// No description provided for @settings_cost_center_toast_updated.
  ///
  /// In en, this message translates to:
  /// **'Record updated successfully'**
  String get settings_cost_center_toast_updated;

  /// No description provided for @settings_financial_concept_title.
  ///
  /// In en, this message translates to:
  /// **'Financial concepts'**
  String get settings_financial_concept_title;

  /// No description provided for @settings_financial_concept_new.
  ///
  /// In en, this message translates to:
  /// **'New concept'**
  String get settings_financial_concept_new;

  /// No description provided for @settings_financial_concept_filter_all.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get settings_financial_concept_filter_all;

  /// No description provided for @settings_financial_concept_filter_by_type.
  ///
  /// In en, this message translates to:
  /// **'Filter by type'**
  String get settings_financial_concept_filter_by_type;

  /// No description provided for @settings_financial_concept_field_name.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get settings_financial_concept_field_name;

  /// No description provided for @settings_financial_concept_field_description.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get settings_financial_concept_field_description;

  /// No description provided for @settings_financial_concept_field_type.
  ///
  /// In en, this message translates to:
  /// **'Concept type'**
  String get settings_financial_concept_field_type;

  /// No description provided for @settings_financial_concept_field_statement_category.
  ///
  /// In en, this message translates to:
  /// **'Statement category'**
  String get settings_financial_concept_field_statement_category;

  /// No description provided for @settings_financial_concept_field_active.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get settings_financial_concept_field_active;

  /// No description provided for @settings_financial_concept_indicators_title.
  ///
  /// In en, this message translates to:
  /// **'Accounting indicators'**
  String get settings_financial_concept_indicators_title;

  /// No description provided for @settings_financial_concept_indicator_cash_flow.
  ///
  /// In en, this message translates to:
  /// **'Impacts cash flow'**
  String get settings_financial_concept_indicator_cash_flow;

  /// No description provided for @settings_financial_concept_indicator_result.
  ///
  /// In en, this message translates to:
  /// **'Impacts result (P&L)'**
  String get settings_financial_concept_indicator_result;

  /// No description provided for @settings_financial_concept_indicator_balance.
  ///
  /// In en, this message translates to:
  /// **'Impacts balance sheet'**
  String get settings_financial_concept_indicator_balance;

  /// No description provided for @settings_financial_concept_indicator_operational.
  ///
  /// In en, this message translates to:
  /// **'Recurring operational event'**
  String get settings_financial_concept_indicator_operational;

  /// No description provided for @settings_financial_concept_error_required.
  ///
  /// In en, this message translates to:
  /// **'Required field'**
  String get settings_financial_concept_error_required;

  /// No description provided for @settings_financial_concept_error_select_type.
  ///
  /// In en, this message translates to:
  /// **'Select a type'**
  String get settings_financial_concept_error_select_type;

  /// No description provided for @settings_financial_concept_error_select_category.
  ///
  /// In en, this message translates to:
  /// **'Select a category'**
  String get settings_financial_concept_error_select_category;

  /// No description provided for @settings_financial_concept_help_statement_categories.
  ///
  /// In en, this message translates to:
  /// **'Understand the categories'**
  String get settings_financial_concept_help_statement_categories;

  /// No description provided for @settings_financial_concept_help_indicators.
  ///
  /// In en, this message translates to:
  /// **'Understand the indicators'**
  String get settings_financial_concept_help_indicators;

  /// No description provided for @settings_financial_concept_save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get settings_financial_concept_save;

  /// No description provided for @settings_financial_concept_toast_saved.
  ///
  /// In en, this message translates to:
  /// **'Record saved successfully'**
  String get settings_financial_concept_toast_saved;

  /// No description provided for @settings_financial_concept_help_statement_title.
  ///
  /// In en, this message translates to:
  /// **'Statement categories'**
  String get settings_financial_concept_help_statement_title;

  /// No description provided for @settings_financial_concept_help_indicator_intro.
  ///
  /// In en, this message translates to:
  /// **'These indicators determine how the concept will be reflected in financial reports. They can be adjusted as needed for specific cases.'**
  String get settings_financial_concept_help_indicator_intro;

  /// No description provided for @settings_financial_concept_help_indicator_cash_flow_title.
  ///
  /// In en, this message translates to:
  /// **'Impacts cash flow'**
  String get settings_financial_concept_help_indicator_cash_flow_title;

  /// No description provided for @settings_financial_concept_help_indicator_cash_flow_desc.
  ///
  /// In en, this message translates to:
  /// **'Check when the entry changes the available balance after payment or receipt.'**
  String get settings_financial_concept_help_indicator_cash_flow_desc;

  /// No description provided for @settings_financial_concept_help_indicator_result_title.
  ///
  /// In en, this message translates to:
  /// **'Impacts result (P&L)'**
  String get settings_financial_concept_help_indicator_result_title;

  /// No description provided for @settings_financial_concept_help_indicator_result_desc.
  ///
  /// In en, this message translates to:
  /// **'Use when the amount should be part of the income statement, affecting profit or loss.'**
  String get settings_financial_concept_help_indicator_result_desc;

  /// No description provided for @settings_financial_concept_help_indicator_balance_title.
  ///
  /// In en, this message translates to:
  /// **'Impacts balance sheet'**
  String get settings_financial_concept_help_indicator_balance_title;

  /// No description provided for @settings_financial_concept_help_indicator_balance_desc.
  ///
  /// In en, this message translates to:
  /// **'Select for events that create or settle assets and liabilities directly in the balance sheet.'**
  String get settings_financial_concept_help_indicator_balance_desc;

  /// No description provided for @settings_financial_concept_help_indicator_operational_title.
  ///
  /// In en, this message translates to:
  /// **'Recurring operational event'**
  String get settings_financial_concept_help_indicator_operational_title;

  /// No description provided for @settings_financial_concept_help_indicator_operational_desc.
  ///
  /// In en, this message translates to:
  /// **'Enable for routine commitments in the church\'s day-to-day operations, related to core activities.'**
  String get settings_financial_concept_help_indicator_operational_desc;

  /// No description provided for @settings_financial_concept_help_understood.
  ///
  /// In en, this message translates to:
  /// **'Got it'**
  String get settings_financial_concept_help_understood;

  /// No description provided for @bankStatements_empty_title.
  ///
  /// In en, this message translates to:
  /// **'No statements imported yet.'**
  String get bankStatements_empty_title;

  /// No description provided for @bankStatements_empty_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Import a CSV file to start bank reconciliation.'**
  String get bankStatements_empty_subtitle;

  /// No description provided for @bankStatements_header_date.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get bankStatements_header_date;

  /// No description provided for @bankStatements_header_bank.
  ///
  /// In en, this message translates to:
  /// **'Bank'**
  String get bankStatements_header_bank;

  /// No description provided for @bankStatements_header_description.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get bankStatements_header_description;

  /// No description provided for @bankStatements_header_amount.
  ///
  /// In en, this message translates to:
  /// **'Amount'**
  String get bankStatements_header_amount;

  /// No description provided for @bankStatements_header_direction.
  ///
  /// In en, this message translates to:
  /// **'Direction'**
  String get bankStatements_header_direction;

  /// No description provided for @bankStatements_header_status.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get bankStatements_header_status;

  /// No description provided for @bankStatements_action_details.
  ///
  /// In en, this message translates to:
  /// **'Details'**
  String get bankStatements_action_details;

  /// No description provided for @bankStatements_action_retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get bankStatements_action_retry;

  /// No description provided for @bankStatements_action_link.
  ///
  /// In en, this message translates to:
  /// **'Link'**
  String get bankStatements_action_link;

  /// No description provided for @bankStatements_action_linking.
  ///
  /// In en, this message translates to:
  /// **'Linking...'**
  String get bankStatements_action_linking;

  /// No description provided for @bankStatements_toast_auto_reconciled.
  ///
  /// In en, this message translates to:
  /// **'Statement reconciled automatically.'**
  String get bankStatements_toast_auto_reconciled;

  /// No description provided for @bankStatements_toast_no_match.
  ///
  /// In en, this message translates to:
  /// **'No matching transaction found.'**
  String get bankStatements_toast_no_match;

  /// No description provided for @bankStatements_details_title.
  ///
  /// In en, this message translates to:
  /// **'Bank statement details'**
  String get bankStatements_details_title;

  /// No description provided for @bankStatements_toast_link_success.
  ///
  /// In en, this message translates to:
  /// **'Statement linked successfully.'**
  String get bankStatements_toast_link_success;

  /// No description provided for @settings_financial_months_empty.
  ///
  /// In en, this message translates to:
  /// **'No financial months found.'**
  String get settings_financial_months_empty;

  /// No description provided for @settings_financial_months_header_month.
  ///
  /// In en, this message translates to:
  /// **'Month'**
  String get settings_financial_months_header_month;

  /// No description provided for @settings_financial_months_header_year.
  ///
  /// In en, this message translates to:
  /// **'Year'**
  String get settings_financial_months_header_year;

  /// No description provided for @settings_financial_months_header_status.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get settings_financial_months_header_status;

  /// No description provided for @settings_financial_months_action_reopen.
  ///
  /// In en, this message translates to:
  /// **'Reopen'**
  String get settings_financial_months_action_reopen;

  /// No description provided for @settings_financial_months_action_close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get settings_financial_months_action_close;

  /// No description provided for @settings_financial_months_modal_close_title.
  ///
  /// In en, this message translates to:
  /// **'Close month'**
  String get settings_financial_months_modal_close_title;

  /// No description provided for @settings_financial_months_modal_reopen_title.
  ///
  /// In en, this message translates to:
  /// **'Reopen month'**
  String get settings_financial_months_modal_reopen_title;

  /// No description provided for @accountsReceivable_list_title.
  ///
  /// In en, this message translates to:
  /// **'Accounts receivable list'**
  String get accountsReceivable_list_title;

  /// No description provided for @accountsReceivable_list_title_mobile.
  ///
  /// In en, this message translates to:
  /// **'Accounts receivable'**
  String get accountsReceivable_list_title_mobile;

  /// No description provided for @accountsReceivable_list_new.
  ///
  /// In en, this message translates to:
  /// **'Register account receivable'**
  String get accountsReceivable_list_new;

  /// No description provided for @accountsReceivable_table_empty.
  ///
  /// In en, this message translates to:
  /// **'No accounts receivable to show'**
  String get accountsReceivable_table_empty;

  /// No description provided for @accountsReceivable_table_header_debtor.
  ///
  /// In en, this message translates to:
  /// **'Debtor'**
  String get accountsReceivable_table_header_debtor;

  /// No description provided for @accountsReceivable_table_header_description.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get accountsReceivable_table_header_description;

  /// No description provided for @accountsReceivable_table_header_type.
  ///
  /// In en, this message translates to:
  /// **'Type'**
  String get accountsReceivable_table_header_type;

  /// No description provided for @accountsReceivable_table_header_installments.
  ///
  /// In en, this message translates to:
  /// **'No. of installments'**
  String get accountsReceivable_table_header_installments;

  /// No description provided for @accountsReceivable_table_header_received.
  ///
  /// In en, this message translates to:
  /// **'Received'**
  String get accountsReceivable_table_header_received;

  /// No description provided for @accountsReceivable_table_header_pending.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get accountsReceivable_table_header_pending;

  /// No description provided for @accountsReceivable_table_header_total.
  ///
  /// In en, this message translates to:
  /// **'Total receivable'**
  String get accountsReceivable_table_header_total;

  /// No description provided for @accountsReceivable_table_header_status.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get accountsReceivable_table_header_status;

  /// No description provided for @accountsReceivable_table_action_view.
  ///
  /// In en, this message translates to:
  /// **'View'**
  String get accountsReceivable_table_action_view;

  /// No description provided for @accountsReceivable_register_title.
  ///
  /// In en, this message translates to:
  /// **'Register account receivable'**
  String get accountsReceivable_register_title;

  /// No description provided for @accountsReceivable_view_title.
  ///
  /// In en, this message translates to:
  /// **'Account receivable detail'**
  String get accountsReceivable_view_title;

  /// No description provided for @accountsReceivable_form_field_financial_concept.
  ///
  /// In en, this message translates to:
  /// **'Financial concept'**
  String get accountsReceivable_form_field_financial_concept;

  /// No description provided for @accountsReceivable_form_field_debtor_dni.
  ///
  /// In en, this message translates to:
  /// **'Debtor tax ID'**
  String get accountsReceivable_form_field_debtor_dni;

  /// No description provided for @accountsReceivable_form_field_debtor_phone.
  ///
  /// In en, this message translates to:
  /// **'Debtor phone'**
  String get accountsReceivable_form_field_debtor_phone;

  /// No description provided for @accountsReceivable_form_field_debtor_name.
  ///
  /// In en, this message translates to:
  /// **'Debtor name'**
  String get accountsReceivable_form_field_debtor_name;

  /// No description provided for @accountsReceivable_form_field_debtor_email.
  ///
  /// In en, this message translates to:
  /// **'Debtor email'**
  String get accountsReceivable_form_field_debtor_email;

  /// No description provided for @accountsReceivable_form_field_debtor_address.
  ///
  /// In en, this message translates to:
  /// **'Debtor address'**
  String get accountsReceivable_form_field_debtor_address;

  /// No description provided for @accountsReceivable_form_field_member.
  ///
  /// In en, this message translates to:
  /// **'Select member'**
  String get accountsReceivable_form_field_member;

  /// No description provided for @accountsReceivable_form_field_single_due_date.
  ///
  /// In en, this message translates to:
  /// **'Due date'**
  String get accountsReceivable_form_field_single_due_date;

  /// No description provided for @accountsReceivable_form_field_automatic_installments.
  ///
  /// In en, this message translates to:
  /// **'Number of installments'**
  String get accountsReceivable_form_field_automatic_installments;

  /// No description provided for @accountsReceivable_form_field_automatic_amount.
  ///
  /// In en, this message translates to:
  /// **'Amount per installment'**
  String get accountsReceivable_form_field_automatic_amount;

  /// No description provided for @accountsReceivable_form_error_member_required.
  ///
  /// In en, this message translates to:
  /// **'Select a member'**
  String get accountsReceivable_form_error_member_required;

  /// No description provided for @accountsReceivable_form_error_description_required.
  ///
  /// In en, this message translates to:
  /// **'Description is required'**
  String get accountsReceivable_form_error_description_required;

  /// No description provided for @accountsReceivable_form_error_financial_concept_required.
  ///
  /// In en, this message translates to:
  /// **'Select a financial concept'**
  String get accountsReceivable_form_error_financial_concept_required;

  /// No description provided for @accountsReceivable_form_error_debtor_name_required.
  ///
  /// In en, this message translates to:
  /// **'Debtor name is required'**
  String get accountsReceivable_form_error_debtor_name_required;

  /// No description provided for @accountsReceivable_form_error_debtor_dni_required.
  ///
  /// In en, this message translates to:
  /// **'Debtor identifier is required'**
  String get accountsReceivable_form_error_debtor_dni_required;

  /// No description provided for @accountsReceivable_form_error_debtor_phone_required.
  ///
  /// In en, this message translates to:
  /// **'Debtor phone is required'**
  String get accountsReceivable_form_error_debtor_phone_required;

  /// No description provided for @accountsReceivable_form_error_debtor_email_required.
  ///
  /// In en, this message translates to:
  /// **'Debtor email is required'**
  String get accountsReceivable_form_error_debtor_email_required;

  /// No description provided for @accountsReceivable_form_error_total_amount_required.
  ///
  /// In en, this message translates to:
  /// **'Enter the total amount'**
  String get accountsReceivable_form_error_total_amount_required;

  /// No description provided for @accountsReceivable_form_error_single_due_date_required.
  ///
  /// In en, this message translates to:
  /// **'Enter the due date'**
  String get accountsReceivable_form_error_single_due_date_required;

  /// No description provided for @accountsReceivable_form_error_installments_required.
  ///
  /// In en, this message translates to:
  /// **'Generate the installments to continue'**
  String get accountsReceivable_form_error_installments_required;

  /// No description provided for @accountsReceivable_form_error_installments_invalid.
  ///
  /// In en, this message translates to:
  /// **'Fill in amount and due date for each installment'**
  String get accountsReceivable_form_error_installments_invalid;

  /// No description provided for @accountsReceivable_form_error_automatic_installments_required.
  ///
  /// In en, this message translates to:
  /// **'Enter the number of installments'**
  String get accountsReceivable_form_error_automatic_installments_required;

  /// No description provided for @accountsReceivable_form_error_automatic_amount_required.
  ///
  /// In en, this message translates to:
  /// **'Enter the amount per installment'**
  String get accountsReceivable_form_error_automatic_amount_required;

  /// No description provided for @accountsReceivable_form_error_automatic_first_due_date_required.
  ///
  /// In en, this message translates to:
  /// **'Enter the date of the first installment'**
  String get accountsReceivable_form_error_automatic_first_due_date_required;

  /// No description provided for @accountsReceivable_form_error_installments_count_mismatch.
  ///
  /// In en, this message translates to:
  /// **'The number of generated installments must match the total informed'**
  String get accountsReceivable_form_error_installments_count_mismatch;

  /// No description provided for @accountsReceivable_form_debtor_type_title.
  ///
  /// In en, this message translates to:
  /// **'Debtor type'**
  String get accountsReceivable_form_debtor_type_title;

  /// No description provided for @accountsReceivable_form_debtor_type_member.
  ///
  /// In en, this message translates to:
  /// **'Church member'**
  String get accountsReceivable_form_debtor_type_member;

  /// No description provided for @accountsReceivable_form_debtor_type_external.
  ///
  /// In en, this message translates to:
  /// **'External'**
  String get accountsReceivable_form_debtor_type_external;

  /// No description provided for @accountsReceivable_form_installments_single_empty_message.
  ///
  /// In en, this message translates to:
  /// **'Enter the amount and due date to see the summary.'**
  String get accountsReceivable_form_installments_single_empty_message;

  /// No description provided for @accountsReceivable_form_installments_automatic_empty_message.
  ///
  /// In en, this message translates to:
  /// **'Enter the data and click \"Generate installments\" to see the schedule.'**
  String get accountsReceivable_form_installments_automatic_empty_message;

  /// No description provided for @accountsReceivable_form_installments_summary_title.
  ///
  /// In en, this message translates to:
  /// **'Installments summary'**
  String get accountsReceivable_form_installments_summary_title;

  /// No description provided for @accountsReceivable_form_installment_item_title.
  ///
  /// In en, this message translates to:
  /// **'Installment {index}'**
  String accountsReceivable_form_installment_item_title(int index);

  /// No description provided for @accountsReceivable_form_installment_item_due_date.
  ///
  /// In en, this message translates to:
  /// **'Due date: {date}'**
  String accountsReceivable_form_installment_item_due_date(String date);

  /// No description provided for @accountsReceivable_form_installments_summary_total.
  ///
  /// In en, this message translates to:
  /// **'Total: {amount}'**
  String accountsReceivable_form_installments_summary_total(String amount);

  /// No description provided for @accountsReceivable_form_save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get accountsReceivable_form_save;

  /// No description provided for @accountsReceivable_form_toast_saved_success.
  ///
  /// In en, this message translates to:
  /// **'Account receivable registered successfully'**
  String get accountsReceivable_form_toast_saved_success;

  /// No description provided for @accountsReceivable_form_toast_saved_error.
  ///
  /// In en, this message translates to:
  /// **'Error while registering account receivable'**
  String get accountsReceivable_form_toast_saved_error;

  /// No description provided for @accountsReceivable_view_debtor_section.
  ///
  /// In en, this message translates to:
  /// **'Debtor information'**
  String get accountsReceivable_view_debtor_section;

  /// No description provided for @accountsReceivable_view_debtor_name.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get accountsReceivable_view_debtor_name;

  /// No description provided for @accountsReceivable_view_debtor_dni.
  ///
  /// In en, this message translates to:
  /// **'Tax ID'**
  String get accountsReceivable_view_debtor_dni;

  /// No description provided for @accountsReceivable_view_debtor_type.
  ///
  /// In en, this message translates to:
  /// **'Debtor type'**
  String get accountsReceivable_view_debtor_type;

  /// No description provided for @accountsReceivable_view_installments_title.
  ///
  /// In en, this message translates to:
  /// **'Installments list'**
  String get accountsReceivable_view_installments_title;

  /// No description provided for @accountsReceivable_view_register_payment.
  ///
  /// In en, this message translates to:
  /// **'Register payment'**
  String get accountsReceivable_view_register_payment;

  /// No description provided for @accountsReceivable_view_general_section.
  ///
  /// In en, this message translates to:
  /// **'General information'**
  String get accountsReceivable_view_general_section;

  /// No description provided for @accountsReceivable_view_general_created.
  ///
  /// In en, this message translates to:
  /// **'Created'**
  String get accountsReceivable_view_general_created;

  /// No description provided for @accountsReceivable_view_general_updated.
  ///
  /// In en, this message translates to:
  /// **'Updated'**
  String get accountsReceivable_view_general_updated;

  /// No description provided for @accountsReceivable_view_general_description.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get accountsReceivable_view_general_description;

  /// No description provided for @accountsReceivable_view_general_type.
  ///
  /// In en, this message translates to:
  /// **'Type'**
  String get accountsReceivable_view_general_type;

  /// No description provided for @accountsReceivable_view_general_total.
  ///
  /// In en, this message translates to:
  /// **'Total amount'**
  String get accountsReceivable_view_general_total;

  /// No description provided for @accountsReceivable_view_general_paid.
  ///
  /// In en, this message translates to:
  /// **'Amount paid'**
  String get accountsReceivable_view_general_paid;

  /// No description provided for @accountsReceivable_view_general_pending.
  ///
  /// In en, this message translates to:
  /// **'Amount pending'**
  String get accountsReceivable_view_general_pending;

  /// No description provided for @accountsReceivable_payment_total_label.
  ///
  /// In en, this message translates to:
  /// **'Total amount to be paid'**
  String get accountsReceivable_payment_total_label;

  /// No description provided for @accountsReceivable_payment_submit.
  ///
  /// In en, this message translates to:
  /// **'Submit payment'**
  String get accountsReceivable_payment_submit;

  /// No description provided for @accountsReceivable_payment_receipt_label.
  ///
  /// In en, this message translates to:
  /// **'Transfer receipt'**
  String get accountsReceivable_payment_receipt_label;

  /// No description provided for @accountsReceivable_payment_availability_account_label.
  ///
  /// In en, this message translates to:
  /// **'Availability account'**
  String get accountsReceivable_payment_availability_account_label;

  /// No description provided for @accountsReceivable_payment_amount_label.
  ///
  /// In en, this message translates to:
  /// **'Payment amount'**
  String get accountsReceivable_payment_amount_label;

  /// No description provided for @accountsReceivable_payment_toast_success.
  ///
  /// In en, this message translates to:
  /// **'Payment registered successfully'**
  String get accountsReceivable_payment_toast_success;

  /// No description provided for @accountsReceivable_payment_error_amount_required.
  ///
  /// In en, this message translates to:
  /// **'Enter the payment amount'**
  String get accountsReceivable_payment_error_amount_required;

  /// No description provided for @accountsReceivable_payment_error_availability_account_required.
  ///
  /// In en, this message translates to:
  /// **'Select an availability account'**
  String get accountsReceivable_payment_error_availability_account_required;

  /// No description provided for @accountsReceivable_form_field_automatic_first_due_date.
  ///
  /// In en, this message translates to:
  /// **'First installment date'**
  String get accountsReceivable_form_field_automatic_first_due_date;

  /// No description provided for @accountsReceivable_form_generate_installments.
  ///
  /// In en, this message translates to:
  /// **'Generate installments'**
  String get accountsReceivable_form_generate_installments;

  /// No description provided for @accountsReceivable_form_error_generate_installments_fill_data.
  ///
  /// In en, this message translates to:
  /// **'Fill in the data to generate the installments.'**
  String get accountsReceivable_form_error_generate_installments_fill_data;

  /// No description provided for @accountsReceivable_form_toast_generate_installments_success.
  ///
  /// In en, this message translates to:
  /// **'Installments generated automatically.'**
  String get accountsReceivable_form_toast_generate_installments_success;

  /// No description provided for @accountsPayable_list_title.
  ///
  /// In en, this message translates to:
  /// **'Accounts payable'**
  String get accountsPayable_list_title;

  /// No description provided for @accountsPayable_list_new.
  ///
  /// In en, this message translates to:
  /// **'Register accounts payable'**
  String get accountsPayable_list_new;

  /// No description provided for @accountsPayable_table_empty.
  ///
  /// In en, this message translates to:
  /// **'No accounts payable to show'**
  String get accountsPayable_table_empty;

  /// No description provided for @accountsPayable_table_header_supplier.
  ///
  /// In en, this message translates to:
  /// **'Supplier'**
  String get accountsPayable_table_header_supplier;

  /// No description provided for @accountsPayable_table_header_description.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get accountsPayable_table_header_description;

  /// No description provided for @accountsPayable_table_header_installments.
  ///
  /// In en, this message translates to:
  /// **'No. of installments'**
  String get accountsPayable_table_header_installments;

  /// No description provided for @accountsPayable_table_header_paid.
  ///
  /// In en, this message translates to:
  /// **'Paid'**
  String get accountsPayable_table_header_paid;

  /// No description provided for @accountsPayable_table_header_pending.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get accountsPayable_table_header_pending;

  /// No description provided for @accountsPayable_table_header_total.
  ///
  /// In en, this message translates to:
  /// **'Total payable'**
  String get accountsPayable_table_header_total;

  /// No description provided for @accountsPayable_table_header_status.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get accountsPayable_table_header_status;

  /// No description provided for @accountsPayable_table_action_view.
  ///
  /// In en, this message translates to:
  /// **'View'**
  String get accountsPayable_table_action_view;

  /// No description provided for @accountsPayable_register_title.
  ///
  /// In en, this message translates to:
  /// **'Register account payable'**
  String get accountsPayable_register_title;

  /// No description provided for @accountsPayable_view_title.
  ///
  /// In en, this message translates to:
  /// **'Accounts payable detail'**
  String get accountsPayable_view_title;

  /// No description provided for @accountsPayable_view_installments_title.
  ///
  /// In en, this message translates to:
  /// **'Installments list'**
  String get accountsPayable_view_installments_title;

  /// No description provided for @accountsPayable_view_register_payment.
  ///
  /// In en, this message translates to:
  /// **'Register payment'**
  String get accountsPayable_view_register_payment;

  /// No description provided for @accountsPayable_view_provider_section.
  ///
  /// In en, this message translates to:
  /// **'Supplier information'**
  String get accountsPayable_view_provider_section;

  /// No description provided for @accountsPayable_view_provider_name.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get accountsPayable_view_provider_name;

  /// No description provided for @accountsPayable_view_provider_dni.
  ///
  /// In en, this message translates to:
  /// **'Tax ID'**
  String get accountsPayable_view_provider_dni;

  /// No description provided for @accountsPayable_view_provider_phone.
  ///
  /// In en, this message translates to:
  /// **'Phone'**
  String get accountsPayable_view_provider_phone;

  /// No description provided for @accountsPayable_view_provider_email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get accountsPayable_view_provider_email;

  /// No description provided for @accountsPayable_view_provider_type.
  ///
  /// In en, this message translates to:
  /// **'Supplier type'**
  String get accountsPayable_view_provider_type;

  /// No description provided for @accountsPayable_view_general_section.
  ///
  /// In en, this message translates to:
  /// **'General information'**
  String get accountsPayable_view_general_section;

  /// No description provided for @accountsPayable_view_general_created.
  ///
  /// In en, this message translates to:
  /// **'Created'**
  String get accountsPayable_view_general_created;

  /// No description provided for @accountsPayable_view_general_updated.
  ///
  /// In en, this message translates to:
  /// **'Updated'**
  String get accountsPayable_view_general_updated;

  /// No description provided for @accountsPayable_view_general_description.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get accountsPayable_view_general_description;

  /// No description provided for @accountsPayable_view_general_total.
  ///
  /// In en, this message translates to:
  /// **'Total amount'**
  String get accountsPayable_view_general_total;

  /// No description provided for @accountsPayable_view_general_paid.
  ///
  /// In en, this message translates to:
  /// **'Amount paid'**
  String get accountsPayable_view_general_paid;

  /// No description provided for @accountsPayable_view_general_pending.
  ///
  /// In en, this message translates to:
  /// **'Amount pending'**
  String get accountsPayable_view_general_pending;

  /// No description provided for @accountsPayable_payment_total_label.
  ///
  /// In en, this message translates to:
  /// **'Total amount to be paid'**
  String get accountsPayable_payment_total_label;

  /// No description provided for @accountsPayable_payment_submit.
  ///
  /// In en, this message translates to:
  /// **'Submit payment'**
  String get accountsPayable_payment_submit;

  /// No description provided for @accountsPayable_payment_receipt_label.
  ///
  /// In en, this message translates to:
  /// **'Transfer receipt'**
  String get accountsPayable_payment_receipt_label;

  /// No description provided for @accountsPayable_payment_cost_center_label.
  ///
  /// In en, this message translates to:
  /// **'Cost center'**
  String get accountsPayable_payment_cost_center_label;

  /// No description provided for @accountsPayable_payment_availability_account_label.
  ///
  /// In en, this message translates to:
  /// **'Availability account'**
  String get accountsPayable_payment_availability_account_label;

  /// No description provided for @accountsPayable_payment_amount_label.
  ///
  /// In en, this message translates to:
  /// **'Payment amount'**
  String get accountsPayable_payment_amount_label;

  /// No description provided for @accountsPayable_payment_toast_success.
  ///
  /// In en, this message translates to:
  /// **'Payment registered successfully'**
  String get accountsPayable_payment_toast_success;

  /// No description provided for @accountsPayable_form_section_basic_title.
  ///
  /// In en, this message translates to:
  /// **'Basic information'**
  String get accountsPayable_form_section_basic_title;

  /// No description provided for @accountsPayable_form_section_basic_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Choose the supplier and describe the account payable.'**
  String get accountsPayable_form_section_basic_subtitle;

  /// No description provided for @accountsPayable_form_section_document_title.
  ///
  /// In en, this message translates to:
  /// **'Fiscal document'**
  String get accountsPayable_form_section_document_title;

  /// No description provided for @accountsPayable_form_section_document_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Provide the fiscal document associated with the payment.'**
  String get accountsPayable_form_section_document_subtitle;

  /// No description provided for @accountsPayable_form_section_tax_title.
  ///
  /// In en, this message translates to:
  /// **'Invoice taxation'**
  String get accountsPayable_form_section_tax_title;

  /// No description provided for @accountsPayable_form_section_tax_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Classify the invoice and enter the highlighted taxes.'**
  String get accountsPayable_form_section_tax_subtitle;

  /// No description provided for @accountsPayable_form_section_payment_title.
  ///
  /// In en, this message translates to:
  /// **'Payment configuration'**
  String get accountsPayable_form_section_payment_title;

  /// No description provided for @accountsPayable_form_section_payment_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Define how this account will be settled and review the installments schedule.'**
  String get accountsPayable_form_section_payment_subtitle;

  /// No description provided for @accountsPayable_form_field_supplier.
  ///
  /// In en, this message translates to:
  /// **'Supplier'**
  String get accountsPayable_form_field_supplier;

  /// No description provided for @accountsPayable_form_field_description.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get accountsPayable_form_field_description;

  /// No description provided for @accountsPayable_form_field_document_type.
  ///
  /// In en, this message translates to:
  /// **'Document type'**
  String get accountsPayable_form_field_document_type;

  /// No description provided for @accountsPayable_form_field_document_number.
  ///
  /// In en, this message translates to:
  /// **'Document number'**
  String get accountsPayable_form_field_document_number;

  /// No description provided for @accountsPayable_form_field_document_date.
  ///
  /// In en, this message translates to:
  /// **'Document date'**
  String get accountsPayable_form_field_document_date;

  /// No description provided for @accountsPayable_form_field_tax_exempt_switch.
  ///
  /// In en, this message translates to:
  /// **'Invoice exempt from taxes'**
  String get accountsPayable_form_field_tax_exempt_switch;

  /// No description provided for @accountsPayable_form_field_tax_exemption_reason.
  ///
  /// In en, this message translates to:
  /// **'Exemption reason'**
  String get accountsPayable_form_field_tax_exemption_reason;

  /// No description provided for @accountsPayable_form_field_tax_observation.
  ///
  /// In en, this message translates to:
  /// **'Observations'**
  String get accountsPayable_form_field_tax_observation;

  /// No description provided for @accountsPayable_form_field_tax_cst.
  ///
  /// In en, this message translates to:
  /// **'CST code'**
  String get accountsPayable_form_field_tax_cst;

  /// No description provided for @accountsPayable_form_field_tax_cfop.
  ///
  /// In en, this message translates to:
  /// **'CFOP'**
  String get accountsPayable_form_field_tax_cfop;

  /// No description provided for @accountsPayable_form_section_payment_mode_help_cst.
  ///
  /// In en, this message translates to:
  /// **'Quick help about CST'**
  String get accountsPayable_form_section_payment_mode_help_cst;

  /// No description provided for @accountsPayable_form_section_payment_mode_help_cfop.
  ///
  /// In en, this message translates to:
  /// **'Quick help about CFOP'**
  String get accountsPayable_form_section_payment_mode_help_cfop;

  /// No description provided for @accountsPayable_form_error_supplier_required.
  ///
  /// In en, this message translates to:
  /// **'Supplier is required'**
  String get accountsPayable_form_error_supplier_required;

  /// No description provided for @accountsPayable_form_error_description_required.
  ///
  /// In en, this message translates to:
  /// **'Description is required'**
  String get accountsPayable_form_error_description_required;

  /// No description provided for @accountsPayable_form_error_document_type_required.
  ///
  /// In en, this message translates to:
  /// **'Select the document type'**
  String get accountsPayable_form_error_document_type_required;

  /// No description provided for @accountsPayable_form_error_document_number_required.
  ///
  /// In en, this message translates to:
  /// **'Enter the document number'**
  String get accountsPayable_form_error_document_number_required;

  /// No description provided for @accountsPayable_form_error_document_date_required.
  ///
  /// In en, this message translates to:
  /// **'Enter the document date'**
  String get accountsPayable_form_error_document_date_required;

  /// No description provided for @accountsPayable_form_error_total_amount_required.
  ///
  /// In en, this message translates to:
  /// **'Enter an amount greater than zero'**
  String get accountsPayable_form_error_total_amount_required;

  /// No description provided for @accountsPayable_form_error_single_due_date_required.
  ///
  /// In en, this message translates to:
  /// **'Enter the due date'**
  String get accountsPayable_form_error_single_due_date_required;

  /// No description provided for @accountsPayable_form_error_installments_required.
  ///
  /// In en, this message translates to:
  /// **'Generate or add at least one installment'**
  String get accountsPayable_form_error_installments_required;

  /// No description provided for @accountsPayable_form_error_installments_contents.
  ///
  /// In en, this message translates to:
  /// **'Fill in amount and due date for each installment'**
  String get accountsPayable_form_error_installments_contents;

  /// No description provided for @accountsPayable_form_error_automatic_installments_required.
  ///
  /// In en, this message translates to:
  /// **'Enter the number of installments'**
  String get accountsPayable_form_error_automatic_installments_required;

  /// No description provided for @accountsPayable_form_error_automatic_amount_required.
  ///
  /// In en, this message translates to:
  /// **'Enter the amount per installment'**
  String get accountsPayable_form_error_automatic_amount_required;

  /// No description provided for @accountsPayable_form_error_automatic_first_due_date_required.
  ///
  /// In en, this message translates to:
  /// **'Enter the date of the first installment'**
  String get accountsPayable_form_error_automatic_first_due_date_required;

  /// No description provided for @accountsPayable_form_error_installments_count_mismatch.
  ///
  /// In en, this message translates to:
  /// **'The number of generated installments must match the total informed'**
  String get accountsPayable_form_error_installments_count_mismatch;

  /// No description provided for @accountsPayable_form_error_taxes_required.
  ///
  /// In en, this message translates to:
  /// **'Add withheld taxes when the invoice is not exempt'**
  String get accountsPayable_form_error_taxes_required;

  /// No description provided for @accountsPayable_form_error_taxes_invalid.
  ///
  /// In en, this message translates to:
  /// **'Enter type, percentage and amount for each tax'**
  String get accountsPayable_form_error_taxes_invalid;

  /// No description provided for @accountsPayable_form_error_tax_exemption_reason_required.
  ///
  /// In en, this message translates to:
  /// **'Enter the invoice exemption reason'**
  String get accountsPayable_form_error_tax_exemption_reason_required;

  /// No description provided for @accountsPayable_form_error_installments_add_one.
  ///
  /// In en, this message translates to:
  /// **'Add at least one installment'**
  String get accountsPayable_form_error_installments_add_one;

  /// No description provided for @accountsPayable_form_error_tax_exempt_must_not_have_taxes.
  ///
  /// In en, this message translates to:
  /// **'Exempt invoices must not have withheld taxes'**
  String get accountsPayable_form_error_tax_exempt_must_not_have_taxes;

  /// No description provided for @accountsPayable_form_error_tax_status_mismatch.
  ///
  /// In en, this message translates to:
  /// **'Update the tax status according to the highlighted taxes'**
  String get accountsPayable_form_error_tax_status_mismatch;

  /// No description provided for @accountsPayable_form_installments_single_empty_message.
  ///
  /// In en, this message translates to:
  /// **'Enter the amount and due date to see the summary.'**
  String get accountsPayable_form_installments_single_empty_message;

  /// No description provided for @accountsPayable_form_installments_automatic_empty_message.
  ///
  /// In en, this message translates to:
  /// **'Enter the data and click \"Generate installments\" to see the schedule.'**
  String get accountsPayable_form_installments_automatic_empty_message;

  /// No description provided for @accountsPayable_form_field_total_amount.
  ///
  /// In en, this message translates to:
  /// **'Total amount'**
  String get accountsPayable_form_field_total_amount;

  /// No description provided for @accountsPayable_form_field_single_due_date.
  ///
  /// In en, this message translates to:
  /// **'Due date'**
  String get accountsPayable_form_field_single_due_date;

  /// No description provided for @accountsPayable_form_field_automatic_installments.
  ///
  /// In en, this message translates to:
  /// **'Number of installments'**
  String get accountsPayable_form_field_automatic_installments;

  /// No description provided for @accountsPayable_form_field_automatic_amount.
  ///
  /// In en, this message translates to:
  /// **'Amount per installment'**
  String get accountsPayable_form_field_automatic_amount;

  /// No description provided for @accountsPayable_form_field_automatic_first_due_date.
  ///
  /// In en, this message translates to:
  /// **'First installment date'**
  String get accountsPayable_form_field_automatic_first_due_date;

  /// No description provided for @accountsPayable_form_generate_installments.
  ///
  /// In en, this message translates to:
  /// **'Generate installments'**
  String get accountsPayable_form_generate_installments;

  /// No description provided for @accountsPayable_form_error_generate_installments_fill_data.
  ///
  /// In en, this message translates to:
  /// **'Fill in the data to generate the installments.'**
  String get accountsPayable_form_error_generate_installments_fill_data;

  /// No description provided for @accountsPayable_form_toast_generate_installments_success.
  ///
  /// In en, this message translates to:
  /// **'Installments generated successfully.'**
  String get accountsPayable_form_toast_generate_installments_success;

  /// No description provided for @accountsPayable_form_installments_summary_title.
  ///
  /// In en, this message translates to:
  /// **'Installments summary'**
  String get accountsPayable_form_installments_summary_title;

  /// No description provided for @accountsPayable_form_installment_item_title.
  ///
  /// In en, this message translates to:
  /// **'Installment {index}'**
  String accountsPayable_form_installment_item_title(int index);

  /// No description provided for @accountsPayable_form_installment_item_due_date.
  ///
  /// In en, this message translates to:
  /// **'Due date: {date}'**
  String accountsPayable_form_installment_item_due_date(String date);

  /// No description provided for @accountsPayable_form_installments_summary_total.
  ///
  /// In en, this message translates to:
  /// **'Total: {amount}'**
  String accountsPayable_form_installments_summary_total(String amount);

  /// No description provided for @accountsPayable_form_toast_saved_success.
  ///
  /// In en, this message translates to:
  /// **'Account payable registered successfully'**
  String get accountsPayable_form_toast_saved_success;

  /// No description provided for @accountsPayable_form_toast_saved_error.
  ///
  /// In en, this message translates to:
  /// **'Error while registering account payable'**
  String get accountsPayable_form_toast_saved_error;

  /// No description provided for @accountsPayable_form_save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get accountsPayable_form_save;

  /// No description provided for @reports_income_download_pdf.
  ///
  /// In en, this message translates to:
  /// **'Download PDF'**
  String get reports_income_download_pdf;

  /// No description provided for @reports_income_download_success.
  ///
  /// In en, this message translates to:
  /// **'PDF downloaded successfully'**
  String get reports_income_download_success;

  /// No description provided for @reports_income_download_error.
  ///
  /// In en, this message translates to:
  /// **'Could not download the PDF'**
  String get reports_income_download_error;

  /// No description provided for @reports_income_download_error_generic.
  ///
  /// In en, this message translates to:
  /// **'Error while downloading the PDF'**
  String get reports_income_download_error_generic;

  /// No description provided for @reports_dre_download_pdf.
  ///
  /// In en, this message translates to:
  /// **'Download PDF'**
  String get reports_dre_download_pdf;

  /// No description provided for @reports_dre_download_success.
  ///
  /// In en, this message translates to:
  /// **'PDF downloaded successfully'**
  String get reports_dre_download_success;

  /// No description provided for @reports_dre_download_error.
  ///
  /// In en, this message translates to:
  /// **'Could not download the PDF'**
  String get reports_dre_download_error;

  /// No description provided for @reports_dre_download_error_generic.
  ///
  /// In en, this message translates to:
  /// **'Error while downloading the PDF'**
  String get reports_dre_download_error_generic;

  /// No description provided for @reports_income_breakdown_title.
  ///
  /// In en, this message translates to:
  /// **'Income and expenses by category'**
  String get reports_income_breakdown_title;

  /// No description provided for @reports_income_breakdown_empty.
  ///
  /// In en, this message translates to:
  /// **'No income and expense data for the selected period.'**
  String get reports_income_breakdown_empty;

  /// No description provided for @reports_income_breakdown_header_category.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get reports_income_breakdown_header_category;

  /// No description provided for @reports_income_breakdown_header_income.
  ///
  /// In en, this message translates to:
  /// **'Income'**
  String get reports_income_breakdown_header_income;

  /// No description provided for @reports_income_breakdown_header_expenses.
  ///
  /// In en, this message translates to:
  /// **'Expenses'**
  String get reports_income_breakdown_header_expenses;

  /// No description provided for @reports_income_breakdown_header_balance.
  ///
  /// In en, this message translates to:
  /// **'Balance'**
  String get reports_income_breakdown_header_balance;

  /// No description provided for @reports_income_cashflow_title.
  ///
  /// In en, this message translates to:
  /// **'Cash flow by availability account'**
  String get reports_income_cashflow_title;

  /// No description provided for @reports_income_cashflow_summary.
  ///
  /// In en, this message translates to:
  /// **'Total income: {income} | Total expenses: {expenses} | Consolidated balance: {total}'**
  String reports_income_cashflow_summary(String income, String expenses, String total);

  /// No description provided for @reports_income_cashflow_empty.
  ///
  /// In en, this message translates to:
  /// **'No availability account movements in this period.'**
  String get reports_income_cashflow_empty;

  /// No description provided for @reports_income_cashflow_header_account.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get reports_income_cashflow_header_account;

  /// No description provided for @reports_income_cashflow_header_income.
  ///
  /// In en, this message translates to:
  /// **'Income'**
  String get reports_income_cashflow_header_income;

  /// No description provided for @reports_income_cashflow_header_expenses.
  ///
  /// In en, this message translates to:
  /// **'Expenses'**
  String get reports_income_cashflow_header_expenses;

  /// No description provided for @reports_income_cashflow_header_balance.
  ///
  /// In en, this message translates to:
  /// **'Period balance'**
  String get reports_income_cashflow_header_balance;

  /// No description provided for @reports_income_cost_centers_title.
  ///
  /// In en, this message translates to:
  /// **'Cost center usage'**
  String get reports_income_cost_centers_title;

  /// No description provided for @reports_income_cost_centers_total_applied.
  ///
  /// In en, this message translates to:
  /// **'Total applied: {total}'**
  String reports_income_cost_centers_total_applied(String total);

  /// No description provided for @reports_income_cost_centers_empty.
  ///
  /// In en, this message translates to:
  /// **'No cost centers with movements in this period.'**
  String get reports_income_cost_centers_empty;

  /// No description provided for @reports_income_cost_centers_header_name.
  ///
  /// In en, this message translates to:
  /// **'Cost center'**
  String get reports_income_cost_centers_header_name;

  /// No description provided for @reports_income_cost_centers_header_total.
  ///
  /// In en, this message translates to:
  /// **'Total applied'**
  String get reports_income_cost_centers_header_total;

  /// No description provided for @reports_income_cost_centers_header_last_move.
  ///
  /// In en, this message translates to:
  /// **'Last movement'**
  String get reports_income_cost_centers_header_last_move;

  /// No description provided for @trends_header_title.
  ///
  /// In en, this message translates to:
  /// **'Composition of income, expenses and result'**
  String get trends_header_title;

  /// No description provided for @trends_header_comparison.
  ///
  /// In en, this message translates to:
  /// **'Comparison: {currentMonthYear} vs {previousMonthYear}'**
  String trends_header_comparison(String currentMonthYear, String previousMonthYear);

  /// No description provided for @trends_list_revenue.
  ///
  /// In en, this message translates to:
  /// **'Revenue'**
  String get trends_list_revenue;

  /// No description provided for @trends_list_opex.
  ///
  /// In en, this message translates to:
  /// **'Operating expenses'**
  String get trends_list_opex;

  /// No description provided for @trends_list_transfers.
  ///
  /// In en, this message translates to:
  /// **'Ministry transfers'**
  String get trends_list_transfers;

  /// No description provided for @trends_list_capex.
  ///
  /// In en, this message translates to:
  /// **'Investments'**
  String get trends_list_capex;

  /// No description provided for @trends_list_net_income.
  ///
  /// In en, this message translates to:
  /// **'Net result'**
  String get trends_list_net_income;

  /// No description provided for @trends_summary_revenue.
  ///
  /// In en, this message translates to:
  /// **'Revenue'**
  String get trends_summary_revenue;

  /// No description provided for @trends_summary_opex.
  ///
  /// In en, this message translates to:
  /// **'Operating'**
  String get trends_summary_opex;

  /// No description provided for @trends_summary_transfers.
  ///
  /// In en, this message translates to:
  /// **'Transfers'**
  String get trends_summary_transfers;

  /// No description provided for @trends_summary_capex.
  ///
  /// In en, this message translates to:
  /// **'Investments'**
  String get trends_summary_capex;

  /// No description provided for @trends_summary_net_income.
  ///
  /// In en, this message translates to:
  /// **'Result'**
  String get trends_summary_net_income;

  /// No description provided for @reports_dre_screen_title.
  ///
  /// In en, this message translates to:
  /// **'DRE - Statement of Income for the Year'**
  String get reports_dre_screen_title;

  /// No description provided for @reports_dre_header_title.
  ///
  /// In en, this message translates to:
  /// **'Statement of Income for the Year'**
  String get reports_dre_header_title;

  /// No description provided for @reports_dre_header_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Understand how your church received and used resources in the period'**
  String get reports_dre_header_subtitle;

  /// No description provided for @reports_dre_footer_note.
  ///
  /// In en, this message translates to:
  /// **'Note: This report considers only confirmed and reconciled entries that affect the accounting result.'**
  String get reports_dre_footer_note;

  /// No description provided for @reports_dre_main_indicators_title.
  ///
  /// In en, this message translates to:
  /// **'Key indicators'**
  String get reports_dre_main_indicators_title;

  /// No description provided for @reports_dre_card_gross_revenue_title.
  ///
  /// In en, this message translates to:
  /// **'Gross revenue'**
  String get reports_dre_card_gross_revenue_title;

  /// No description provided for @reports_dre_card_gross_revenue_description.
  ///
  /// In en, this message translates to:
  /// **'Total tithes, offerings and donations received'**
  String get reports_dre_card_gross_revenue_description;

  /// No description provided for @reports_dre_card_operational_result_title.
  ///
  /// In en, this message translates to:
  /// **'Operating result'**
  String get reports_dre_card_operational_result_title;

  /// No description provided for @reports_dre_card_operational_result_description.
  ///
  /// In en, this message translates to:
  /// **'Gross result minus operating expenses'**
  String get reports_dre_card_operational_result_description;

  /// No description provided for @reports_dre_card_net_result_title.
  ///
  /// In en, this message translates to:
  /// **'Net result'**
  String get reports_dre_card_net_result_title;

  /// No description provided for @reports_dre_card_net_result_description.
  ///
  /// In en, this message translates to:
  /// **'Final result for the period (surplus or deficit)'**
  String get reports_dre_card_net_result_description;

  /// No description provided for @reports_dre_detail_section_title.
  ///
  /// In en, this message translates to:
  /// **'Detail'**
  String get reports_dre_detail_section_title;

  /// No description provided for @reports_dre_item_net_revenue_title.
  ///
  /// In en, this message translates to:
  /// **'Net revenue'**
  String get reports_dre_item_net_revenue_title;

  /// No description provided for @reports_dre_item_net_revenue_description.
  ///
  /// In en, this message translates to:
  /// **'Gross revenue minus returns and adjustments'**
  String get reports_dre_item_net_revenue_description;

  /// No description provided for @reports_dre_item_direct_costs_title.
  ///
  /// In en, this message translates to:
  /// **'Direct costs'**
  String get reports_dre_item_direct_costs_title;

  /// No description provided for @reports_dre_item_direct_costs_description.
  ///
  /// In en, this message translates to:
  /// **'Event costs, materials and specific activities'**
  String get reports_dre_item_direct_costs_description;

  /// No description provided for @reports_dre_item_gross_profit_title.
  ///
  /// In en, this message translates to:
  /// **'Gross profit'**
  String get reports_dre_item_gross_profit_title;

  /// No description provided for @reports_dre_item_gross_profit_description.
  ///
  /// In en, this message translates to:
  /// **'Net revenue minus direct costs'**
  String get reports_dre_item_gross_profit_description;

  /// No description provided for @reports_dre_item_operational_expenses_title.
  ///
  /// In en, this message translates to:
  /// **'Operating expenses'**
  String get reports_dre_item_operational_expenses_title;

  /// No description provided for @reports_dre_item_operational_expenses_description.
  ///
  /// In en, this message translates to:
  /// **'Day-to-day expenses: electricity, water, salaries, cleaning'**
  String get reports_dre_item_operational_expenses_description;

  /// No description provided for @reports_dre_item_ministry_transfers_title.
  ///
  /// In en, this message translates to:
  /// **'Ministry transfers'**
  String get reports_dre_item_ministry_transfers_title;

  /// No description provided for @reports_dre_item_ministry_transfers_description.
  ///
  /// In en, this message translates to:
  /// **'Transfers to ministries, missions or to the board'**
  String get reports_dre_item_ministry_transfers_description;

  /// No description provided for @reports_monthly_tithes_title.
  ///
  /// In en, this message translates to:
  /// **'Monthly tithes report'**
  String get reports_monthly_tithes_title;

  /// No description provided for @reports_monthly_tithes_empty.
  ///
  /// In en, this message translates to:
  /// **'No monthly tithes to show'**
  String get reports_monthly_tithes_empty;

  /// No description provided for @reports_monthly_tithes_header_date.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get reports_monthly_tithes_header_date;

  /// No description provided for @reports_monthly_tithes_header_amount.
  ///
  /// In en, this message translates to:
  /// **'Amount'**
  String get reports_monthly_tithes_header_amount;

  /// No description provided for @reports_monthly_tithes_header_account.
  ///
  /// In en, this message translates to:
  /// **'Availability account'**
  String get reports_monthly_tithes_header_account;

  /// No description provided for @reports_monthly_tithes_header_account_type.
  ///
  /// In en, this message translates to:
  /// **'Account type'**
  String get reports_monthly_tithes_header_account_type;

  /// No description provided for @finance_records_filter_concept_type.
  ///
  /// In en, this message translates to:
  /// **'Concept type'**
  String get finance_records_filter_concept_type;

  /// No description provided for @finance_records_filter_concept.
  ///
  /// In en, this message translates to:
  /// **'Concept'**
  String get finance_records_filter_concept;

  /// No description provided for @finance_records_filter_availability_account.
  ///
  /// In en, this message translates to:
  /// **'Availability account'**
  String get finance_records_filter_availability_account;

  /// No description provided for @finance_records_table_empty.
  ///
  /// In en, this message translates to:
  /// **'No financial records to show'**
  String get finance_records_table_empty;

  /// No description provided for @finance_records_table_header_date.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get finance_records_table_header_date;

  /// No description provided for @finance_records_table_header_amount.
  ///
  /// In en, this message translates to:
  /// **'Amount'**
  String get finance_records_table_header_amount;

  /// No description provided for @finance_records_table_header_type.
  ///
  /// In en, this message translates to:
  /// **'Movement type'**
  String get finance_records_table_header_type;

  /// No description provided for @finance_records_table_header_concept.
  ///
  /// In en, this message translates to:
  /// **'Concept'**
  String get finance_records_table_header_concept;

  /// No description provided for @finance_records_table_header_availability_account.
  ///
  /// In en, this message translates to:
  /// **'Availability account'**
  String get finance_records_table_header_availability_account;

  /// No description provided for @finance_records_table_header_status.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get finance_records_table_header_status;

  /// No description provided for @finance_records_table_action_void.
  ///
  /// In en, this message translates to:
  /// **'Void'**
  String get finance_records_table_action_void;

  /// No description provided for @finance_records_table_confirm_void.
  ///
  /// In en, this message translates to:
  /// **'Do you want to void this financial movement?'**
  String get finance_records_table_confirm_void;

  /// No description provided for @finance_records_table_modal_title.
  ///
  /// In en, this message translates to:
  /// **'Financial movement'**
  String get finance_records_table_modal_title;

  /// No description provided for @finance_records_form_title.
  ///
  /// In en, this message translates to:
  /// **'Financial record'**
  String get finance_records_form_title;

  /// No description provided for @finance_records_form_field_description.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get finance_records_form_field_description;

  /// No description provided for @finance_records_form_field_date.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get finance_records_form_field_date;

  /// No description provided for @finance_records_form_field_receipt.
  ///
  /// In en, this message translates to:
  /// **'Bank movement receipt'**
  String get finance_records_form_field_receipt;

  /// No description provided for @finance_records_form_field_cost_center.
  ///
  /// In en, this message translates to:
  /// **'Cost center'**
  String get finance_records_form_field_cost_center;

  /// No description provided for @finance_records_form_save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get finance_records_form_save;

  /// No description provided for @finance_records_form_toast_purchase_in_construction.
  ///
  /// In en, this message translates to:
  /// **'Purchase records are under construction'**
  String get finance_records_form_toast_purchase_in_construction;

  /// No description provided for @finance_records_form_toast_saved_success.
  ///
  /// In en, this message translates to:
  /// **'Record saved successfully'**
  String get finance_records_form_toast_saved_success;

  /// No description provided for @common_view.
  ///
  /// In en, this message translates to:
  /// **'View'**
  String get common_view;

  /// No description provided for @contributions_status_processed.
  ///
  /// In en, this message translates to:
  /// **'Processed'**
  String get contributions_status_processed;

  /// No description provided for @contributions_status_pending_verification.
  ///
  /// In en, this message translates to:
  /// **'Pending verification'**
  String get contributions_status_pending_verification;

  /// No description provided for @contributions_status_rejected.
  ///
  /// In en, this message translates to:
  /// **'Rejected'**
  String get contributions_status_rejected;

  /// No description provided for @contributions_list_title.
  ///
  /// In en, this message translates to:
  /// **'Contributions list'**
  String get contributions_list_title;

  /// No description provided for @contributions_list_new.
  ///
  /// In en, this message translates to:
  /// **'Register contribution'**
  String get contributions_list_new;

  /// No description provided for @contributions_table_empty.
  ///
  /// In en, this message translates to:
  /// **'No contributions found'**
  String get contributions_table_empty;

  /// No description provided for @contributions_table_header_member.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get contributions_table_header_member;

  /// No description provided for @contributions_table_header_amount.
  ///
  /// In en, this message translates to:
  /// **'Amount'**
  String get contributions_table_header_amount;

  /// No description provided for @contributions_table_header_type.
  ///
  /// In en, this message translates to:
  /// **'Contribution type'**
  String get contributions_table_header_type;

  /// No description provided for @contributions_table_header_status.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get contributions_table_header_status;

  /// No description provided for @contributions_table_header_date.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get contributions_table_header_date;

  /// No description provided for @contributions_table_modal_title.
  ///
  /// In en, this message translates to:
  /// **'Contribution #{id}'**
  String contributions_table_modal_title(String id);

  /// No description provided for @contributions_view_field_amount.
  ///
  /// In en, this message translates to:
  /// **'Amount'**
  String get contributions_view_field_amount;

  /// No description provided for @contributions_view_field_status.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get contributions_view_field_status;

  /// No description provided for @contributions_view_field_date.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get contributions_view_field_date;

  /// No description provided for @contributions_view_field_account.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get contributions_view_field_account;

  /// No description provided for @contributions_view_section_member.
  ///
  /// In en, this message translates to:
  /// **'Member'**
  String get contributions_view_section_member;

  /// No description provided for @contributions_view_section_financial_concept.
  ///
  /// In en, this message translates to:
  /// **'Financial concept'**
  String get contributions_view_section_financial_concept;

  /// No description provided for @contributions_view_section_receipt.
  ///
  /// In en, this message translates to:
  /// **'Transfer receipt'**
  String get contributions_view_section_receipt;

  /// No description provided for @contributions_view_action_approve.
  ///
  /// In en, this message translates to:
  /// **'Approve'**
  String get contributions_view_action_approve;

  /// No description provided for @contributions_view_action_reject.
  ///
  /// In en, this message translates to:
  /// **'Reject'**
  String get contributions_view_action_reject;

  /// No description provided for @accountsReceivable_form_section_payment_title.
  ///
  /// In en, this message translates to:
  /// **'Payment configuration'**
  String get accountsReceivable_form_section_payment_title;

  /// No description provided for @accountsReceivable_form_section_payment_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Define how this receivable will be charged and review the installments schedule.'**
  String get accountsReceivable_form_section_payment_subtitle;

  /// No description provided for @accountsReceivable_form_field_type.
  ///
  /// In en, this message translates to:
  /// **'Account type'**
  String get accountsReceivable_form_field_type;

  /// No description provided for @accountsReceivable_type_help_title.
  ///
  /// In en, this message translates to:
  /// **'How to classify the account type'**
  String get accountsReceivable_type_help_title;

  /// No description provided for @accountsReceivable_type_help_intro.
  ///
  /// In en, this message translates to:
  /// **'Choose the type that best describes the origin of the receivable amount.'**
  String get accountsReceivable_type_help_intro;

  /// No description provided for @accountsReceivable_type_contribution_title.
  ///
  /// In en, this message translates to:
  /// **'Contribution'**
  String get accountsReceivable_type_contribution_title;

  /// No description provided for @accountsReceivable_type_contribution_description.
  ///
  /// In en, this message translates to:
  /// **'Voluntary commitments made by members or groups.'**
  String get accountsReceivable_type_contribution_description;

  /// No description provided for @accountsReceivable_type_contribution_example.
  ///
  /// In en, this message translates to:
  /// **'E.g.: missions campaigns, recurring offerings, special donations.'**
  String get accountsReceivable_type_contribution_example;

  /// No description provided for @accountsReceivable_type_service_title.
  ///
  /// In en, this message translates to:
  /// **'Service'**
  String get accountsReceivable_type_service_title;

  /// No description provided for @accountsReceivable_type_service_description.
  ///
  /// In en, this message translates to:
  /// **'Charges for activities or services provided by the church.'**
  String get accountsReceivable_type_service_description;

  /// No description provided for @accountsReceivable_type_service_example.
  ///
  /// In en, this message translates to:
  /// **'E.g.: music courses, conferences, event catering rental.'**
  String get accountsReceivable_type_service_example;

  /// No description provided for @accountsReceivable_type_interinstitutional_title.
  ///
  /// In en, this message translates to:
  /// **'Interinstitutional'**
  String get accountsReceivable_type_interinstitutional_title;

  /// No description provided for @accountsReceivable_type_interinstitutional_description.
  ///
  /// In en, this message translates to:
  /// **'Amounts arising from partnerships with other institutions.'**
  String get accountsReceivable_type_interinstitutional_description;

  /// No description provided for @accountsReceivable_type_interinstitutional_example.
  ///
  /// In en, this message translates to:
  /// **'E.g.: support for joint events, agreements with another church.'**
  String get accountsReceivable_type_interinstitutional_example;

  /// No description provided for @accountsReceivable_type_rental_title.
  ///
  /// In en, this message translates to:
  /// **'Rental'**
  String get accountsReceivable_type_rental_title;

  /// No description provided for @accountsReceivable_type_rental_description.
  ///
  /// In en, this message translates to:
  /// **'Paid use of spaces, vehicles or equipment.'**
  String get accountsReceivable_type_rental_description;

  /// No description provided for @accountsReceivable_type_rental_example.
  ///
  /// In en, this message translates to:
  /// **'E.g.: auditorium rental, instruments or chair rental.'**
  String get accountsReceivable_type_rental_example;

  /// No description provided for @accountsReceivable_type_loan_title.
  ///
  /// In en, this message translates to:
  /// **'Loan'**
  String get accountsReceivable_type_loan_title;

  /// No description provided for @accountsReceivable_type_loan_description.
  ///
  /// In en, this message translates to:
  /// **'Resources granted by the church that must be repaid.'**
  String get accountsReceivable_type_loan_description;

  /// No description provided for @accountsReceivable_type_loan_example.
  ///
  /// In en, this message translates to:
  /// **'E.g.: advances to ministries, temporary financial support.'**
  String get accountsReceivable_type_loan_example;

  /// No description provided for @accountsReceivable_type_financial_title.
  ///
  /// In en, this message translates to:
  /// **'Financial'**
  String get accountsReceivable_type_financial_title;

  /// No description provided for @accountsReceivable_type_financial_description.
  ///
  /// In en, this message translates to:
  /// **'Bank movements that are still pending settlement.'**
  String get accountsReceivable_type_financial_description;

  /// No description provided for @accountsReceivable_type_financial_example.
  ///
  /// In en, this message translates to:
  /// **'E.g.: checks in process, card acquiring, refunds.'**
  String get accountsReceivable_type_financial_example;

  /// No description provided for @accountsReceivable_type_legal_title.
  ///
  /// In en, this message translates to:
  /// **'Legal'**
  String get accountsReceivable_type_legal_title;

  /// No description provided for @accountsReceivable_type_legal_description.
  ///
  /// In en, this message translates to:
  /// **'Charges related to legal actions, insurance or indemnities.'**
  String get accountsReceivable_type_legal_description;

  /// No description provided for @accountsReceivable_type_legal_example.
  ///
  /// In en, this message translates to:
  /// **'E.g.: enforcement of judgment, claims covered by insurer.'**
  String get accountsReceivable_type_legal_example;

  /// No description provided for @common_see_all.
  ///
  /// In en, this message translates to:
  /// **'See all'**
  String get common_see_all;

  /// No description provided for @member_home_placeholder.
  ///
  /// In en, this message translates to:
  /// **'Member experience'**
  String get member_home_placeholder;

  /// No description provided for @member_home_upcoming_events_title.
  ///
  /// In en, this message translates to:
  /// **'Upcoming events'**
  String get member_home_upcoming_events_title;

  /// No description provided for @member_home_upcoming_events_empty.
  ///
  /// In en, this message translates to:
  /// **'No upcoming events in the next few days.'**
  String get member_home_upcoming_events_empty;

  /// No description provided for @member_contribution_history_title.
  ///
  /// In en, this message translates to:
  /// **'Contribution history'**
  String get member_contribution_history_title;

  /// No description provided for @member_contribution_new_button.
  ///
  /// In en, this message translates to:
  /// **'New contribution'**
  String get member_contribution_new_button;

  /// No description provided for @member_contribution_filter_type_label.
  ///
  /// In en, this message translates to:
  /// **'Type'**
  String get member_contribution_filter_type_label;

  /// No description provided for @member_contribution_filter_type_all.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get member_contribution_filter_type_all;

  /// No description provided for @member_contribution_type_tithe.
  ///
  /// In en, this message translates to:
  /// **'Tithe'**
  String get member_contribution_type_tithe;

  /// No description provided for @member_contribution_type_offering.
  ///
  /// In en, this message translates to:
  /// **'Offering'**
  String get member_contribution_type_offering;

  /// No description provided for @member_contribution_destination_label.
  ///
  /// In en, this message translates to:
  /// **'Contribution destination'**
  String get member_contribution_destination_label;

  /// No description provided for @member_contribution_search_account_hint.
  ///
  /// In en, this message translates to:
  /// **'Search account...'**
  String get member_contribution_search_account_hint;

  /// No description provided for @member_contribution_offering_concept_label.
  ///
  /// In en, this message translates to:
  /// **'Offering'**
  String get member_contribution_offering_concept_label;

  /// No description provided for @member_contribution_search_concept_hint.
  ///
  /// In en, this message translates to:
  /// **'Search concept...'**
  String get member_contribution_search_concept_hint;

  /// No description provided for @member_contribution_value_label.
  ///
  /// In en, this message translates to:
  /// **'Contribution amount'**
  String get member_contribution_value_label;

  /// No description provided for @member_contribution_amount_other.
  ///
  /// In en, this message translates to:
  /// **'Other amount'**
  String get member_contribution_amount_other;

  /// No description provided for @member_contribution_receipt_label.
  ///
  /// In en, this message translates to:
  /// **'Upload the payment receipt'**
  String get member_contribution_receipt_label;

  /// No description provided for @member_contribution_receipt_payment_date_label.
  ///
  /// In en, this message translates to:
  /// **'Payment date'**
  String get member_contribution_receipt_payment_date_label;

  /// No description provided for @member_contribution_receipt_help_text.
  ///
  /// In en, this message translates to:
  /// **'Your church treasury will review this receipt. Attaching it is mandatory.'**
  String get member_contribution_receipt_help_text;

  /// No description provided for @member_contribution_message_label.
  ///
  /// In en, this message translates to:
  /// **'Message (optional)'**
  String get member_contribution_message_label;

  /// No description provided for @member_contribution_continue_button.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get member_contribution_continue_button;

  /// No description provided for @member_contribution_payment_method_question.
  ///
  /// In en, this message translates to:
  /// **'How do you want to record the payment?'**
  String get member_contribution_payment_method_question;

  /// No description provided for @member_contribution_payment_method_boleto_title.
  ///
  /// In en, this message translates to:
  /// **'Generate a boleto to pay later'**
  String get member_contribution_payment_method_boleto_title;

  /// No description provided for @member_contribution_payment_method_manual_title.
  ///
  /// In en, this message translates to:
  /// **'I already contributed, I want to upload the receipt'**
  String get member_contribution_payment_method_manual_title;

  /// No description provided for @member_contribution_payment_method_pix_description.
  ///
  /// In en, this message translates to:
  /// **'Pay now via PIX. Generate the QR code or copy-and-paste code to pay in your banking app.'**
  String get member_contribution_payment_method_pix_description;

  /// No description provided for @member_contribution_payment_method_boleto_description.
  ///
  /// In en, this message translates to:
  /// **'Generate a boleto to pay later through online banking or your app.'**
  String get member_contribution_payment_method_boleto_description;

  /// No description provided for @member_contribution_payment_method_manual_description.
  ///
  /// In en, this message translates to:
  /// **'Deposit, transfer, or use another method, then upload the receipt here.'**
  String get member_contribution_payment_method_manual_description;

  /// No description provided for @member_contribution_history_empty_title.
  ///
  /// In en, this message translates to:
  /// **'You do not have any contributions yet'**
  String get member_contribution_history_empty_title;

  /// No description provided for @member_contribution_history_empty_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Once you make a contribution, it will appear here.'**
  String get member_contribution_history_empty_subtitle;

  /// No description provided for @member_contribution_history_item_default_title.
  ///
  /// In en, this message translates to:
  /// **'Contribution'**
  String get member_contribution_history_item_default_title;

  /// No description provided for @member_contribution_history_item_receipt_submitted.
  ///
  /// In en, this message translates to:
  /// **'Receipt submitted'**
  String get member_contribution_history_item_receipt_submitted;

  /// No description provided for @member_contribution_pix_title.
  ///
  /// In en, this message translates to:
  /// **'Pay with PIX'**
  String get member_contribution_pix_title;

  /// No description provided for @member_contribution_pix_recipient.
  ///
  /// In en, this message translates to:
  /// **'Recipient: {recipient}'**
  String member_contribution_pix_recipient(String recipient);

  /// No description provided for @member_contribution_pix_qr_hint.
  ///
  /// In en, this message translates to:
  /// **'Scan this QR code in your banking app.'**
  String get member_contribution_pix_qr_hint;

  /// No description provided for @member_contribution_pix_code_label.
  ///
  /// In en, this message translates to:
  /// **'PIX copy and paste code'**
  String get member_contribution_pix_code_label;

  /// No description provided for @member_contribution_copy_code.
  ///
  /// In en, this message translates to:
  /// **'Copy code'**
  String get member_contribution_copy_code;

  /// No description provided for @member_contribution_pix_footer.
  ///
  /// In en, this message translates to:
  /// **'After paying, you can track the confirmation in your contribution history.'**
  String get member_contribution_pix_footer;

  /// No description provided for @member_contribution_back_to_home.
  ///
  /// In en, this message translates to:
  /// **'Back to home'**
  String get member_contribution_back_to_home;

  /// No description provided for @member_contribution_pix_copy_success.
  ///
  /// In en, this message translates to:
  /// **'PIX code copied!'**
  String get member_contribution_pix_copy_success;

  /// No description provided for @member_contribution_boleto_title.
  ///
  /// In en, this message translates to:
  /// **'Pay with boleto'**
  String get member_contribution_boleto_title;

  /// No description provided for @member_contribution_boleto_due_date_label.
  ///
  /// In en, this message translates to:
  /// **'Due date:'**
  String get member_contribution_boleto_due_date_label;

  /// No description provided for @member_contribution_boleto_instruction.
  ///
  /// In en, this message translates to:
  /// **'Use the code below to pay in your online banking or app.'**
  String get member_contribution_boleto_instruction;

  /// No description provided for @member_contribution_boleto_line_label.
  ///
  /// In en, this message translates to:
  /// **'Digitable line'**
  String get member_contribution_boleto_line_label;

  /// No description provided for @member_contribution_boleto_download_pdf.
  ///
  /// In en, this message translates to:
  /// **'Download boleto PDF'**
  String get member_contribution_boleto_download_pdf;

  /// No description provided for @member_contribution_boleto_footer.
  ///
  /// In en, this message translates to:
  /// **'After paying, the confirmation will appear in your contribution history. Keep the receipt.'**
  String get member_contribution_boleto_footer;

  /// No description provided for @member_contribution_boleto_copy_success.
  ///
  /// In en, this message translates to:
  /// **'Digitable line copied!'**
  String get member_contribution_boleto_copy_success;

  /// No description provided for @member_contribution_boleto_pdf_error.
  ///
  /// In en, this message translates to:
  /// **'Could not open the PDF'**
  String get member_contribution_boleto_pdf_error;

  /// No description provided for @member_contribution_result_success_title.
  ///
  /// In en, this message translates to:
  /// **'Contribution completed\nsuccessfully!'**
  String get member_contribution_result_success_title;

  /// No description provided for @member_contribution_result_success_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Thank you for your generosity.'**
  String get member_contribution_result_success_subtitle;

  /// No description provided for @member_contribution_result_date.
  ///
  /// In en, this message translates to:
  /// **'Date: {date}'**
  String member_contribution_result_date(String date);

  /// No description provided for @member_contribution_result_info.
  ///
  /// In en, this message translates to:
  /// **'The treasury team will review your receipt.'**
  String get member_contribution_result_info;

  /// No description provided for @member_contribution_view_history.
  ///
  /// In en, this message translates to:
  /// **'View history'**
  String get member_contribution_view_history;

  /// No description provided for @member_contribution_result_error_title.
  ///
  /// In en, this message translates to:
  /// **'We could not process\nthe payment'**
  String get member_contribution_result_error_title;

  /// No description provided for @member_contribution_result_error_message.
  ///
  /// In en, this message translates to:
  /// **'Check the payment details or try another method.'**
  String get member_contribution_result_error_message;

  /// No description provided for @member_contribution_try_again.
  ///
  /// In en, this message translates to:
  /// **'Try again'**
  String get member_contribution_try_again;

  /// No description provided for @member_contribution_form_required_fields_error.
  ///
  /// In en, this message translates to:
  /// **'Please fill in all required fields'**
  String get member_contribution_form_required_fields_error;

  /// No description provided for @member_contribution_form_receipt_required_error.
  ///
  /// In en, this message translates to:
  /// **'The receipt is required.'**
  String get member_contribution_form_receipt_required_error;

  /// No description provided for @member_contribution_form_submission_error.
  ///
  /// In en, this message translates to:
  /// **'Error processing the contribution: {error}'**
  String member_contribution_form_submission_error(String error);

  /// No description provided for @member_contribution_validator_amount_required.
  ///
  /// In en, this message translates to:
  /// **'Enter the amount'**
  String get member_contribution_validator_amount_required;

  /// No description provided for @member_contribution_validator_financial_concept_required.
  ///
  /// In en, this message translates to:
  /// **'Select a financial concept'**
  String get member_contribution_validator_financial_concept_required;

  /// No description provided for @member_contribution_validator_account_required.
  ///
  /// In en, this message translates to:
  /// **'Select the availability account'**
  String get member_contribution_validator_account_required;

  /// No description provided for @member_contribution_validator_month_required.
  ///
  /// In en, this message translates to:
  /// **'Select a month'**
  String get member_contribution_validator_month_required;

  /// No description provided for @member_drawer_greeting.
  ///
  /// In en, this message translates to:
  /// **'Example Member'**
  String get member_drawer_greeting;

  /// No description provided for @member_drawer_view_profile.
  ///
  /// In en, this message translates to:
  /// **'View my profile'**
  String get member_drawer_view_profile;

  /// No description provided for @member_drawer_notifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get member_drawer_notifications;

  /// No description provided for @member_drawer_profile.
  ///
  /// In en, this message translates to:
  /// **'My profile'**
  String get member_drawer_profile;

  /// No description provided for @member_drawer_settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get member_drawer_settings;

  /// No description provided for @member_drawer_legal_section.
  ///
  /// In en, this message translates to:
  /// **'Legal'**
  String get member_drawer_legal_section;

  /// No description provided for @member_drawer_privacy_policy.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get member_drawer_privacy_policy;

  /// No description provided for @member_drawer_sensitive_data.
  ///
  /// In en, this message translates to:
  /// **'Sensitive Data Policy'**
  String get member_drawer_sensitive_data;

  /// No description provided for @member_drawer_terms.
  ///
  /// In en, this message translates to:
  /// **'Terms of Use'**
  String get member_drawer_terms;

  /// No description provided for @member_drawer_logout.
  ///
  /// In en, this message translates to:
  /// **'Log out'**
  String get member_drawer_logout;

  /// No description provided for @member_drawer_version.
  ///
  /// In en, this message translates to:
  /// **'Version {version}'**
  String member_drawer_version(String version);

  /// No description provided for @member_shell_nav_home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get member_shell_nav_home;

  /// No description provided for @member_shell_nav_contribute.
  ///
  /// In en, this message translates to:
  /// **'Contribute'**
  String get member_shell_nav_contribute;

  /// No description provided for @member_shell_nav_commitments.
  ///
  /// In en, this message translates to:
  /// **'Commitments'**
  String get member_shell_nav_commitments;

  /// No description provided for @member_shell_nav_statements.
  ///
  /// In en, this message translates to:
  /// **'Statements'**
  String get member_shell_nav_statements;

  /// No description provided for @member_shell_header_tagline.
  ///
  /// In en, this message translates to:
  /// **'CHURCH'**
  String get member_shell_header_tagline;

  /// No description provided for @member_shell_header_default_church.
  ///
  /// In en, this message translates to:
  /// **'Gloria Finance'**
  String get member_shell_header_default_church;

  /// No description provided for @member_commitments_title.
  ///
  /// In en, this message translates to:
  /// **'My commitments'**
  String get member_commitments_title;

  /// No description provided for @member_commitments_empty_title.
  ///
  /// In en, this message translates to:
  /// **'You don\'t have contribution commitments yet'**
  String get member_commitments_empty_title;

  /// No description provided for @member_commitments_empty_subtitle.
  ///
  /// In en, this message translates to:
  /// **'When the treasury assigns one to you, it will appear here.'**
  String get member_commitments_empty_subtitle;

  /// No description provided for @member_commitments_total_label.
  ///
  /// In en, this message translates to:
  /// **'Total amount'**
  String get member_commitments_total_label;

  /// No description provided for @member_commitments_paid_label.
  ///
  /// In en, this message translates to:
  /// **'Already contributed'**
  String get member_commitments_paid_label;

  /// No description provided for @member_commitments_balance_label.
  ///
  /// In en, this message translates to:
  /// **'Balance'**
  String get member_commitments_balance_label;

  /// No description provided for @member_commitments_progress_label.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get member_commitments_progress_label;

  /// No description provided for @member_commitments_button_view_details.
  ///
  /// In en, this message translates to:
  /// **'View details & pay'**
  String get member_commitments_button_view_details;

  /// No description provided for @member_commitments_status_pending.
  ///
  /// In en, this message translates to:
  /// **'In progress'**
  String get member_commitments_status_pending;

  /// No description provided for @member_commitments_status_paid.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get member_commitments_status_paid;

  /// No description provided for @member_commitments_status_pending_acceptance.
  ///
  /// In en, this message translates to:
  /// **'Pending acceptance'**
  String get member_commitments_status_pending_acceptance;

  /// No description provided for @member_commitments_status_denied.
  ///
  /// In en, this message translates to:
  /// **'Denied'**
  String get member_commitments_status_denied;

  /// No description provided for @member_commitments_detail_title.
  ///
  /// In en, this message translates to:
  /// **'Commitment details'**
  String get member_commitments_detail_title;

  /// No description provided for @member_commitments_detail_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Track your progress and choose how to pay your installments.'**
  String get member_commitments_detail_subtitle;

  /// No description provided for @member_commitments_detail_next_installment.
  ///
  /// In en, this message translates to:
  /// **'Next installment'**
  String get member_commitments_detail_next_installment;

  /// No description provided for @member_profile_personal_data_title.
  ///
  /// In en, this message translates to:
  /// **'Personal data'**
  String get member_profile_personal_data_title;

  /// No description provided for @member_profile_security_title.
  ///
  /// In en, this message translates to:
  /// **'Security'**
  String get member_profile_security_title;

  /// No description provided for @member_profile_notifications_title.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get member_profile_notifications_title;

  /// No description provided for @member_profile_full_name_label.
  ///
  /// In en, this message translates to:
  /// **'Full name'**
  String get member_profile_full_name_label;

  /// No description provided for @member_profile_email_label.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get member_profile_email_label;

  /// No description provided for @member_profile_phone_label.
  ///
  /// In en, this message translates to:
  /// **'Phone'**
  String get member_profile_phone_label;

  /// No description provided for @member_profile_dni_label.
  ///
  /// In en, this message translates to:
  /// **'ID/Tax ID'**
  String get member_profile_dni_label;

  /// No description provided for @member_profile_member_since.
  ///
  /// In en, this message translates to:
  /// **'Member since {date}'**
  String member_profile_member_since(String date);

  /// No description provided for @member_profile_change_password_title.
  ///
  /// In en, this message translates to:
  /// **'Change password'**
  String get member_profile_change_password_title;

  /// No description provided for @member_profile_change_password_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Update your access password'**
  String get member_profile_change_password_subtitle;

  /// No description provided for @member_profile_notifications_settings_title.
  ///
  /// In en, this message translates to:
  /// **'Notification settings'**
  String get member_profile_notifications_settings_title;

  /// No description provided for @member_profile_notifications_settings_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Choose how you want to be notified by the church'**
  String get member_profile_notifications_settings_subtitle;

  /// No description provided for @member_change_password_header_title.
  ///
  /// In en, this message translates to:
  /// **'Keep your account safe'**
  String get member_change_password_header_title;

  /// No description provided for @member_change_password_header_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Use a strong password and do not share your access data.'**
  String get member_change_password_header_subtitle;

  /// No description provided for @member_change_password_current_label.
  ///
  /// In en, this message translates to:
  /// **'Current password'**
  String get member_change_password_current_label;

  /// No description provided for @member_change_password_new_label.
  ///
  /// In en, this message translates to:
  /// **'New password'**
  String get member_change_password_new_label;

  /// No description provided for @member_change_password_confirm_label.
  ///
  /// In en, this message translates to:
  /// **'Confirm new password'**
  String get member_change_password_confirm_label;

  /// No description provided for @member_change_password_rule_length.
  ///
  /// In en, this message translates to:
  /// **'At least 8 characters'**
  String get member_change_password_rule_length;

  /// No description provided for @member_change_password_rule_uppercase.
  ///
  /// In en, this message translates to:
  /// **'1 uppercase letter'**
  String get member_change_password_rule_uppercase;

  /// No description provided for @member_change_password_rule_number.
  ///
  /// In en, this message translates to:
  /// **'1 number'**
  String get member_change_password_rule_number;

  /// No description provided for @member_change_password_error_current.
  ///
  /// In en, this message translates to:
  /// **'Incorrect current password.'**
  String get member_change_password_error_current;

  /// No description provided for @member_change_password_error_match.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match.'**
  String get member_change_password_error_match;

  /// No description provided for @member_change_password_success_title.
  ///
  /// In en, this message translates to:
  /// **'Success!'**
  String get member_change_password_success_title;

  /// No description provided for @member_change_password_success_message.
  ///
  /// In en, this message translates to:
  /// **'Your password has been changed successfully.'**
  String get member_change_password_success_message;

  /// No description provided for @member_change_password_btn_save.
  ///
  /// In en, this message translates to:
  /// **'Save new password'**
  String get member_change_password_btn_save;

  /// No description provided for @member_change_password_btn_cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get member_change_password_btn_cancel;

  /// No description provided for @member_change_password_btn_back.
  ///
  /// In en, this message translates to:
  /// **'Back to profile'**
  String get member_change_password_btn_back;

  /// No description provided for @member_commitments_installments_section_title.
  ///
  /// In en, this message translates to:
  /// **'Installments'**
  String get member_commitments_installments_section_title;

  /// No description provided for @member_commitments_payment_modal_title.
  ///
  /// In en, this message translates to:
  /// **'Register payment'**
  String get member_commitments_payment_modal_title;

  /// No description provided for @member_commitments_payment_title.
  ///
  /// In en, this message translates to:
  /// **'Register payment'**
  String get member_commitments_payment_title;

  /// No description provided for @member_commitments_payment_installment_label.
  ///
  /// In en, this message translates to:
  /// **'Installment'**
  String get member_commitments_payment_installment_label;

  /// No description provided for @member_commitments_payment_account_label.
  ///
  /// In en, this message translates to:
  /// **'Availability account'**
  String get member_commitments_payment_account_label;

  /// No description provided for @member_commitments_payment_amount_label.
  ///
  /// In en, this message translates to:
  /// **'Amount paid'**
  String get member_commitments_payment_amount_label;

  /// No description provided for @member_commitments_payment_paid_at_label.
  ///
  /// In en, this message translates to:
  /// **'Payment date'**
  String get member_commitments_payment_paid_at_label;

  /// No description provided for @member_commitments_payment_voucher_label.
  ///
  /// In en, this message translates to:
  /// **'Payment receipt'**
  String get member_commitments_payment_voucher_label;

  /// No description provided for @member_commitments_payment_observation_label.
  ///
  /// In en, this message translates to:
  /// **'Note (optional)'**
  String get member_commitments_payment_observation_label;

  /// No description provided for @member_commitments_payment_submit.
  ///
  /// In en, this message translates to:
  /// **'Send receipt'**
  String get member_commitments_payment_submit;

  /// No description provided for @member_commitments_payment_success.
  ///
  /// In en, this message translates to:
  /// **'Payment registered! The treasury will review the receipt.'**
  String get member_commitments_payment_success;

  /// No description provided for @member_commitments_payment_required_fields_error.
  ///
  /// In en, this message translates to:
  /// **'Select the installment, enter amount/date, and attach the receipt.'**
  String get member_commitments_payment_required_fields_error;

  /// No description provided for @member_commitments_payment_methods_title.
  ///
  /// In en, this message translates to:
  /// **'How do you want to pay?'**
  String get member_commitments_payment_methods_title;

  /// No description provided for @member_commitments_payment_methods_pix.
  ///
  /// In en, this message translates to:
  /// **'Pay with PIX'**
  String get member_commitments_payment_methods_pix;

  /// No description provided for @member_commitments_payment_methods_boleto.
  ///
  /// In en, this message translates to:
  /// **'Generate boleto'**
  String get member_commitments_payment_methods_boleto;

  /// No description provided for @member_commitments_payment_methods_manual.
  ///
  /// In en, this message translates to:
  /// **'I already paid, send receipt'**
  String get member_commitments_payment_methods_manual;

  /// No description provided for @member_commitments_payment_methods_manual_hint.
  ///
  /// In en, this message translates to:
  /// **'Use this option when you transferred and must send the receipt.'**
  String get member_commitments_payment_methods_manual_hint;

  /// No description provided for @member_commitments_installment_paid_on.
  ///
  /// In en, this message translates to:
  /// **'Paid on: {date}'**
  String member_commitments_installment_paid_on(String date);

  /// No description provided for @member_commitments_installment_status_paid.
  ///
  /// In en, this message translates to:
  /// **'Paid'**
  String get member_commitments_installment_status_paid;

  /// No description provided for @member_commitments_installment_status_pending.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get member_commitments_installment_status_pending;

  /// No description provided for @member_commitments_installment_status_in_review.
  ///
  /// In en, this message translates to:
  /// **'Under review'**
  String get member_commitments_installment_status_in_review;

  /// No description provided for @member_commitments_installment_status_partial.
  ///
  /// In en, this message translates to:
  /// **'Partial payment'**
  String get member_commitments_installment_status_partial;

  /// No description provided for @member_commitments_installment_status_overdue.
  ///
  /// In en, this message translates to:
  /// **'Overdue'**
  String get member_commitments_installment_status_overdue;

  /// No description provided for @member_commitments_action_pay_installment.
  ///
  /// In en, this message translates to:
  /// **'Pay installment'**
  String get member_commitments_action_pay_installment;

  /// No description provided for @member_commitments_action_pay_this_installment.
  ///
  /// In en, this message translates to:
  /// **'Pay this installment'**
  String get member_commitments_action_pay_this_installment;

  /// No description provided for @member_commitments_payment_missing_account.
  ///
  /// In en, this message translates to:
  /// **'Availability account not informed. Please contact your church.'**
  String get member_commitments_payment_missing_account;

  /// No description provided for @member_register_name_label.
  ///
  /// In en, this message translates to:
  /// **'Full name'**
  String get member_register_name_label;

  /// No description provided for @member_register_email_label.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get member_register_email_label;

  /// No description provided for @member_register_phone_label.
  ///
  /// In en, this message translates to:
  /// **'Phone'**
  String get member_register_phone_label;

  /// No description provided for @member_register_dni_label.
  ///
  /// In en, this message translates to:
  /// **'Identity Document'**
  String get member_register_dni_label;

  /// No description provided for @member_register_conversion_date_label.
  ///
  /// In en, this message translates to:
  /// **'Conversion date'**
  String get member_register_conversion_date_label;

  /// No description provided for @member_register_baptism_date_label.
  ///
  /// In en, this message translates to:
  /// **'Baptism date'**
  String get member_register_baptism_date_label;

  /// No description provided for @member_register_birthdate_label.
  ///
  /// In en, this message translates to:
  /// **'Birthdate'**
  String get member_register_birthdate_label;

  /// No description provided for @member_register_active_label.
  ///
  /// In en, this message translates to:
  /// **'Active?'**
  String get member_register_active_label;

  /// No description provided for @member_register_yes.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get member_register_yes;

  /// No description provided for @member_register_no.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get member_register_no;

  /// No description provided for @validation_required.
  ///
  /// In en, this message translates to:
  /// **'Required field'**
  String get validation_required;

  /// No description provided for @validation_invalid_email.
  ///
  /// In en, this message translates to:
  /// **'Invalid email'**
  String get validation_invalid_email;

  /// No description provided for @validation_invalid_phone.
  ///
  /// In en, this message translates to:
  /// **'Invalid phone format'**
  String get validation_invalid_phone;

  /// No description provided for @validation_invalid_cpf.
  ///
  /// In en, this message translates to:
  /// **'Invalid ID document'**
  String get validation_invalid_cpf;

  /// No description provided for @member_list_title.
  ///
  /// In en, this message translates to:
  /// **'Member list'**
  String get member_list_title;

  /// No description provided for @member_list_action_register.
  ///
  /// In en, this message translates to:
  /// **'Register new member'**
  String get member_list_action_register;

  /// No description provided for @member_list_empty.
  ///
  /// In en, this message translates to:
  /// **'No members registered.'**
  String get member_list_empty;

  /// No description provided for @member_list_header_name.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get member_list_header_name;

  /// No description provided for @member_list_header_email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get member_list_header_email;

  /// No description provided for @member_list_header_phone.
  ///
  /// In en, this message translates to:
  /// **'Phone'**
  String get member_list_header_phone;

  /// No description provided for @member_list_header_birthdate.
  ///
  /// In en, this message translates to:
  /// **'Birthdate'**
  String get member_list_header_birthdate;

  /// No description provided for @member_list_header_active.
  ///
  /// In en, this message translates to:
  /// **'Active?'**
  String get member_list_header_active;

  /// No description provided for @member_list_action_edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get member_list_action_edit;

  /// No description provided for @member_list_status_yes.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get member_list_status_yes;

  /// No description provided for @member_list_status_no.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get member_list_status_no;

  /// No description provided for @trends_main_card_revenue_title.
  ///
  /// In en, this message translates to:
  /// **'Gross Revenue'**
  String get trends_main_card_revenue_title;

  /// No description provided for @trends_main_card_revenue_subtitle.
  ///
  /// In en, this message translates to:
  /// **'REVENUE'**
  String get trends_main_card_revenue_subtitle;

  /// No description provided for @trends_main_card_opex_title.
  ///
  /// In en, this message translates to:
  /// **'Operating Expenses'**
  String get trends_main_card_opex_title;

  /// No description provided for @trends_main_card_opex_subtitle.
  ///
  /// In en, this message translates to:
  /// **'EXPENSES'**
  String get trends_main_card_opex_subtitle;

  /// No description provided for @trends_main_card_net_income_title.
  ///
  /// In en, this message translates to:
  /// **'Period Result'**
  String get trends_main_card_net_income_title;

  /// No description provided for @trends_main_card_net_income_subtitle.
  ///
  /// In en, this message translates to:
  /// **'RESULT'**
  String get trends_main_card_net_income_subtitle;

  /// No description provided for @member_settings_title.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get member_settings_title;

  /// No description provided for @member_settings_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Personalize your experience at Glória Finance - Members.'**
  String get member_settings_subtitle;

  /// No description provided for @member_settings_language_title.
  ///
  /// In en, this message translates to:
  /// **'Interface Language'**
  String get member_settings_language_title;

  /// No description provided for @member_settings_language_description.
  ///
  /// In en, this message translates to:
  /// **'Choose the language you prefer to use in the app.'**
  String get member_settings_language_description;

  /// No description provided for @member_settings_language_default_tag.
  ///
  /// In en, this message translates to:
  /// **'Default'**
  String get member_settings_language_default_tag;

  /// No description provided for @member_settings_notifications_title.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get member_settings_notifications_title;

  /// No description provided for @member_settings_notifications_description.
  ///
  /// In en, this message translates to:
  /// **'Choose what you want to receive as alerts.'**
  String get member_settings_notifications_description;

  /// No description provided for @member_settings_notification_church_events_title.
  ///
  /// In en, this message translates to:
  /// **'New Church Events'**
  String get member_settings_notification_church_events_title;

  /// No description provided for @member_settings_notification_church_events_desc.
  ///
  /// In en, this message translates to:
  /// **'Receive reminders for services, conferences, and special activities.'**
  String get member_settings_notification_church_events_desc;

  /// No description provided for @member_settings_notification_payments_title.
  ///
  /// In en, this message translates to:
  /// **'Payment Commitments'**
  String get member_settings_notification_payments_title;

  /// No description provided for @member_settings_notification_payments_desc.
  ///
  /// In en, this message translates to:
  /// **'Alerts about installments and due dates of your commitments.'**
  String get member_settings_notification_payments_desc;

  /// No description provided for @member_settings_notification_contributions_status_title.
  ///
  /// In en, this message translates to:
  /// **'Contribution Status'**
  String get member_settings_notification_contributions_status_title;

  /// No description provided for @member_settings_notification_contributions_status_desc.
  ///
  /// In en, this message translates to:
  /// **'Notifications when a tithe or offering changes status (registered, confirmed, etc.).'**
  String get member_settings_notification_contributions_status_desc;

  /// No description provided for @member_settings_footer_coming_soon.
  ///
  /// In en, this message translates to:
  /// **'Coming soon: more options to personalize your experience.'**
  String get member_settings_footer_coming_soon;

  /// No description provided for @schedule_type_service.
  ///
  /// In en, this message translates to:
  /// **'Service'**
  String get schedule_type_service;

  /// No description provided for @schedule_type_cell.
  ///
  /// In en, this message translates to:
  /// **'Cell'**
  String get schedule_type_cell;

  /// No description provided for @schedule_type_ministry_meeting.
  ///
  /// In en, this message translates to:
  /// **'Ministry meeting'**
  String get schedule_type_ministry_meeting;

  /// No description provided for @schedule_type_regular_event.
  ///
  /// In en, this message translates to:
  /// **'Regular event'**
  String get schedule_type_regular_event;

  /// No description provided for @schedule_type_other.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get schedule_type_other;

  /// No description provided for @schedule_visibility_public.
  ///
  /// In en, this message translates to:
  /// **'Public'**
  String get schedule_visibility_public;

  /// No description provided for @schedule_visibility_internal_leaders.
  ///
  /// In en, this message translates to:
  /// **'Leaders only'**
  String get schedule_visibility_internal_leaders;

  /// No description provided for @schedule_day_sunday.
  ///
  /// In en, this message translates to:
  /// **'Sunday'**
  String get schedule_day_sunday;

  /// No description provided for @schedule_day_monday.
  ///
  /// In en, this message translates to:
  /// **'Monday'**
  String get schedule_day_monday;

  /// No description provided for @schedule_day_tuesday.
  ///
  /// In en, this message translates to:
  /// **'Tuesday'**
  String get schedule_day_tuesday;

  /// No description provided for @schedule_day_wednesday.
  ///
  /// In en, this message translates to:
  /// **'Wednesday'**
  String get schedule_day_wednesday;

  /// No description provided for @schedule_day_thursday.
  ///
  /// In en, this message translates to:
  /// **'Thursday'**
  String get schedule_day_thursday;

  /// No description provided for @schedule_day_friday.
  ///
  /// In en, this message translates to:
  /// **'Friday'**
  String get schedule_day_friday;

  /// No description provided for @schedule_day_saturday.
  ///
  /// In en, this message translates to:
  /// **'Saturday'**
  String get schedule_day_saturday;

  /// No description provided for @schedule_list_title.
  ///
  /// In en, this message translates to:
  /// **'Event schedule'**
  String get schedule_list_title;

  /// No description provided for @schedule_list_new_button.
  ///
  /// In en, this message translates to:
  /// **'New event'**
  String get schedule_list_new_button;

  /// No description provided for @schedule_filters_title.
  ///
  /// In en, this message translates to:
  /// **'Filters'**
  String get schedule_filters_title;

  /// No description provided for @schedule_filters_search.
  ///
  /// In en, this message translates to:
  /// **'Search by title'**
  String get schedule_filters_search;

  /// No description provided for @schedule_filters_type.
  ///
  /// In en, this message translates to:
  /// **'Event type'**
  String get schedule_filters_type;

  /// No description provided for @schedule_filters_visibility.
  ///
  /// In en, this message translates to:
  /// **'Visibility'**
  String get schedule_filters_visibility;

  /// No description provided for @schedule_filters_status.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get schedule_filters_status;

  /// No description provided for @schedule_filters_clear.
  ///
  /// In en, this message translates to:
  /// **'Clear filters'**
  String get schedule_filters_clear;

  /// No description provided for @schedule_status_active.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get schedule_status_active;

  /// No description provided for @schedule_status_inactive.
  ///
  /// In en, this message translates to:
  /// **'Inactive'**
  String get schedule_status_inactive;

  /// No description provided for @schedule_status_all.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get schedule_status_all;

  /// No description provided for @schedule_table_empty.
  ///
  /// In en, this message translates to:
  /// **'No events found'**
  String get schedule_table_empty;

  /// No description provided for @schedule_table_header_title.
  ///
  /// In en, this message translates to:
  /// **'Title'**
  String get schedule_table_header_title;

  /// No description provided for @schedule_table_header_type.
  ///
  /// In en, this message translates to:
  /// **'Type'**
  String get schedule_table_header_type;

  /// No description provided for @schedule_table_header_day.
  ///
  /// In en, this message translates to:
  /// **'Day'**
  String get schedule_table_header_day;

  /// No description provided for @schedule_table_header_time.
  ///
  /// In en, this message translates to:
  /// **'Time'**
  String get schedule_table_header_time;

  /// No description provided for @schedule_table_header_location.
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get schedule_table_header_location;

  /// No description provided for @schedule_table_header_director.
  ///
  /// In en, this message translates to:
  /// **'Leader'**
  String get schedule_table_header_director;

  /// No description provided for @schedule_action_reactivate.
  ///
  /// In en, this message translates to:
  /// **'Reactivate'**
  String get schedule_action_reactivate;

  /// No description provided for @schedule_action_deactivate.
  ///
  /// In en, this message translates to:
  /// **'Deactivate'**
  String get schedule_action_deactivate;

  /// No description provided for @schedule_delete_confirm_title.
  ///
  /// In en, this message translates to:
  /// **'Confirm deactivation'**
  String get schedule_delete_confirm_title;

  /// No description provided for @schedule_delete_confirm_message.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to deactivate this event?'**
  String get schedule_delete_confirm_message;

  /// No description provided for @schedule_reactivate_confirm_title.
  ///
  /// In en, this message translates to:
  /// **'Confirm reactivation'**
  String get schedule_reactivate_confirm_title;

  /// No description provided for @schedule_reactivate_confirm_message.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to reactivate this event?'**
  String get schedule_reactivate_confirm_message;

  /// No description provided for @common_confirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get common_confirm;

  /// No description provided for @schedule_detail_basic_info.
  ///
  /// In en, this message translates to:
  /// **'Basic information'**
  String get schedule_detail_basic_info;

  /// No description provided for @schedule_detail_title.
  ///
  /// In en, this message translates to:
  /// **'Title'**
  String get schedule_detail_title;

  /// No description provided for @schedule_detail_type.
  ///
  /// In en, this message translates to:
  /// **'Event type'**
  String get schedule_detail_type;

  /// No description provided for @schedule_detail_description.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get schedule_detail_description;

  /// No description provided for @schedule_detail_visibility.
  ///
  /// In en, this message translates to:
  /// **'Visibility'**
  String get schedule_detail_visibility;

  /// No description provided for @schedule_detail_schedule_info.
  ///
  /// In en, this message translates to:
  /// **'Schedule information'**
  String get schedule_detail_schedule_info;

  /// No description provided for @schedule_detail_day.
  ///
  /// In en, this message translates to:
  /// **'Day of week'**
  String get schedule_detail_day;

  /// No description provided for @schedule_detail_time.
  ///
  /// In en, this message translates to:
  /// **'Time'**
  String get schedule_detail_time;

  /// No description provided for @schedule_detail_duration.
  ///
  /// In en, this message translates to:
  /// **'Duration'**
  String get schedule_detail_duration;

  /// No description provided for @schedule_detail_minutes.
  ///
  /// In en, this message translates to:
  /// **'minutes'**
  String get schedule_detail_minutes;

  /// No description provided for @schedule_detail_start_date.
  ///
  /// In en, this message translates to:
  /// **'Start date'**
  String get schedule_detail_start_date;

  /// No description provided for @schedule_detail_end_date.
  ///
  /// In en, this message translates to:
  /// **'End date'**
  String get schedule_detail_end_date;

  /// No description provided for @schedule_detail_location_info.
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get schedule_detail_location_info;

  /// No description provided for @schedule_detail_location.
  ///
  /// In en, this message translates to:
  /// **'Location name'**
  String get schedule_detail_location;

  /// No description provided for @schedule_detail_address.
  ///
  /// In en, this message translates to:
  /// **'Address'**
  String get schedule_detail_address;

  /// No description provided for @schedule_detail_responsibility.
  ///
  /// In en, this message translates to:
  /// **'Responsibilities'**
  String get schedule_detail_responsibility;

  /// No description provided for @schedule_detail_director.
  ///
  /// In en, this message translates to:
  /// **'Leader'**
  String get schedule_detail_director;

  /// No description provided for @schedule_detail_preacher.
  ///
  /// In en, this message translates to:
  /// **'Preacher'**
  String get schedule_detail_preacher;

  /// No description provided for @schedule_detail_observations.
  ///
  /// In en, this message translates to:
  /// **'Observations'**
  String get schedule_detail_observations;

  /// No description provided for @schedule_detail_summary.
  ///
  /// In en, this message translates to:
  /// **'Summary'**
  String get schedule_detail_summary;

  /// No description provided for @schedule_detail_when.
  ///
  /// In en, this message translates to:
  /// **'When'**
  String get schedule_detail_when;

  /// No description provided for @schedule_detail_timezone.
  ///
  /// In en, this message translates to:
  /// **'Timezone'**
  String get schedule_detail_timezone;

  /// No description provided for @schedule_detail_start.
  ///
  /// In en, this message translates to:
  /// **'Start'**
  String get schedule_detail_start;

  /// No description provided for @schedule_detail_end.
  ///
  /// In en, this message translates to:
  /// **'End'**
  String get schedule_detail_end;

  /// No description provided for @schedule_detail_no_end_date.
  ///
  /// In en, this message translates to:
  /// **'No end date'**
  String get schedule_detail_no_end_date;

  /// No description provided for @schedule_detail_created_at.
  ///
  /// In en, this message translates to:
  /// **'Created on'**
  String get schedule_detail_created_at;

  /// No description provided for @schedule_form_title_new.
  ///
  /// In en, this message translates to:
  /// **'New event'**
  String get schedule_form_title_new;

  /// No description provided for @schedule_form_title_edit.
  ///
  /// In en, this message translates to:
  /// **'Edit event'**
  String get schedule_form_title_edit;

  /// No description provided for @schedule_form_section_basic.
  ///
  /// In en, this message translates to:
  /// **'Basic information'**
  String get schedule_form_section_basic;

  /// No description provided for @schedule_form_section_location.
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get schedule_form_section_location;

  /// No description provided for @schedule_form_section_recurrence.
  ///
  /// In en, this message translates to:
  /// **'Recurrence'**
  String get schedule_form_section_recurrence;

  /// No description provided for @schedule_form_section_visibility.
  ///
  /// In en, this message translates to:
  /// **'Visibility'**
  String get schedule_form_section_visibility;

  /// No description provided for @schedule_form_section_responsibility.
  ///
  /// In en, this message translates to:
  /// **'Responsible'**
  String get schedule_form_section_responsibility;

  /// No description provided for @schedule_form_field_type.
  ///
  /// In en, this message translates to:
  /// **'Event type'**
  String get schedule_form_field_type;

  /// No description provided for @schedule_form_field_title.
  ///
  /// In en, this message translates to:
  /// **'Title'**
  String get schedule_form_field_title;

  /// No description provided for @schedule_form_field_description.
  ///
  /// In en, this message translates to:
  /// **'Description (optional)'**
  String get schedule_form_field_description;

  /// No description provided for @schedule_form_field_location_name.
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get schedule_form_field_location_name;

  /// No description provided for @schedule_form_field_location_address.
  ///
  /// In en, this message translates to:
  /// **'Address (optional)'**
  String get schedule_form_field_location_address;

  /// No description provided for @schedule_form_field_day_of_week.
  ///
  /// In en, this message translates to:
  /// **'Day of week'**
  String get schedule_form_field_day_of_week;

  /// No description provided for @schedule_form_field_time.
  ///
  /// In en, this message translates to:
  /// **'Time'**
  String get schedule_form_field_time;

  /// No description provided for @schedule_form_field_duration.
  ///
  /// In en, this message translates to:
  /// **'Duration (minutes)'**
  String get schedule_form_field_duration;

  /// No description provided for @schedule_form_field_start_date.
  ///
  /// In en, this message translates to:
  /// **'Start date'**
  String get schedule_form_field_start_date;

  /// No description provided for @schedule_form_field_has_end_date.
  ///
  /// In en, this message translates to:
  /// **'Set end date'**
  String get schedule_form_field_has_end_date;

  /// No description provided for @schedule_form_field_end_date.
  ///
  /// In en, this message translates to:
  /// **'End date'**
  String get schedule_form_field_end_date;

  /// No description provided for @schedule_form_field_visibility.
  ///
  /// In en, this message translates to:
  /// **'Who can see'**
  String get schedule_form_field_visibility;

  /// No description provided for @schedule_form_field_director.
  ///
  /// In en, this message translates to:
  /// **'Leader'**
  String get schedule_form_field_director;

  /// No description provided for @schedule_form_field_preacher.
  ///
  /// In en, this message translates to:
  /// **'Preacher (optional)'**
  String get schedule_form_field_preacher;

  /// No description provided for @schedule_form_field_observations.
  ///
  /// In en, this message translates to:
  /// **'Observations (optional)'**
  String get schedule_form_field_observations;

  /// No description provided for @schedule_form_save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get schedule_form_save;

  /// No description provided for @schedule_form_cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get schedule_form_cancel;

  /// No description provided for @schedule_form_title.
  ///
  /// In en, this message translates to:
  /// **'Title'**
  String get schedule_form_title;

  /// No description provided for @schedule_form_description.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get schedule_form_description;

  /// No description provided for @schedule_form_type.
  ///
  /// In en, this message translates to:
  /// **'Type'**
  String get schedule_form_type;

  /// No description provided for @schedule_form_visibility.
  ///
  /// In en, this message translates to:
  /// **'Visibility'**
  String get schedule_form_visibility;

  /// No description provided for @schedule_form_start_time.
  ///
  /// In en, this message translates to:
  /// **'Start time'**
  String get schedule_form_start_time;

  /// No description provided for @schedule_form_end_time.
  ///
  /// In en, this message translates to:
  /// **'End time'**
  String get schedule_form_end_time;

  /// No description provided for @schedule_form_recurrence.
  ///
  /// In en, this message translates to:
  /// **'Recurrence'**
  String get schedule_form_recurrence;

  /// No description provided for @schedule_form_weekly_recurrence.
  ///
  /// In en, this message translates to:
  /// **'Weekly recurrence'**
  String get schedule_form_weekly_recurrence;

  /// No description provided for @schedule_day_abbr_sunday.
  ///
  /// In en, this message translates to:
  /// **'Sun'**
  String get schedule_day_abbr_sunday;

  /// No description provided for @schedule_day_abbr_monday.
  ///
  /// In en, this message translates to:
  /// **'Mon'**
  String get schedule_day_abbr_monday;

  /// No description provided for @schedule_day_abbr_tuesday.
  ///
  /// In en, this message translates to:
  /// **'Tue'**
  String get schedule_day_abbr_tuesday;

  /// No description provided for @schedule_day_abbr_wednesday.
  ///
  /// In en, this message translates to:
  /// **'Wed'**
  String get schedule_day_abbr_wednesday;

  /// No description provided for @schedule_day_abbr_thursday.
  ///
  /// In en, this message translates to:
  /// **'Thu'**
  String get schedule_day_abbr_thursday;

  /// No description provided for @schedule_day_abbr_friday.
  ///
  /// In en, this message translates to:
  /// **'Fri'**
  String get schedule_day_abbr_friday;

  /// No description provided for @schedule_day_abbr_saturday.
  ///
  /// In en, this message translates to:
  /// **'Sat'**
  String get schedule_day_abbr_saturday;

  /// No description provided for @schedule_form_is_active.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get schedule_form_is_active;

  /// No description provided for @schedule_form_error_required.
  ///
  /// In en, this message translates to:
  /// **'This field is required'**
  String get schedule_form_error_required;

  /// No description provided for @schedule_form_error_type_required.
  ///
  /// In en, this message translates to:
  /// **'Select a type'**
  String get schedule_form_error_type_required;

  /// No description provided for @schedule_form_error_visibility_required.
  ///
  /// In en, this message translates to:
  /// **'Select visibility'**
  String get schedule_form_error_visibility_required;

  /// No description provided for @schedule_form_error_day_required.
  ///
  /// In en, this message translates to:
  /// **'Select day of week'**
  String get schedule_form_error_day_required;

  /// No description provided for @schedule_form_error_invalid_time.
  ///
  /// In en, this message translates to:
  /// **'Invalid format. Use HH:MM'**
  String get schedule_form_error_invalid_time;

  /// No description provided for @schedule_form_error_invalid_number.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid number'**
  String get schedule_form_error_invalid_number;

  /// No description provided for @schedule_form_toast_saved.
  ///
  /// In en, this message translates to:
  /// **'Event saved successfully!'**
  String get schedule_form_toast_saved;

  /// No description provided for @schedule_form_error_title_required.
  ///
  /// In en, this message translates to:
  /// **'Title is required'**
  String get schedule_form_error_title_required;

  /// No description provided for @schedule_form_error_location_name_required.
  ///
  /// In en, this message translates to:
  /// **'Location name is required'**
  String get schedule_form_error_location_name_required;

  /// No description provided for @schedule_form_error_director_required.
  ///
  /// In en, this message translates to:
  /// **'Leader is required'**
  String get schedule_form_error_director_required;

  /// No description provided for @schedule_form_error_duration_invalid.
  ///
  /// In en, this message translates to:
  /// **'Duration must be greater than zero'**
  String get schedule_form_error_duration_invalid;

  /// No description provided for @schedule_form_error_end_date_before_start.
  ///
  /// In en, this message translates to:
  /// **'End date must be after start date'**
  String get schedule_form_error_end_date_before_start;

  /// No description provided for @schedule_form_toast_saved_success.
  ///
  /// In en, this message translates to:
  /// **'Event saved successfully!'**
  String get schedule_form_toast_saved_success;

  /// No description provided for @schedule_form_toast_saved_error.
  ///
  /// In en, this message translates to:
  /// **'Error saving event'**
  String get schedule_form_toast_saved_error;

  /// No description provided for @schedule_recurrence_none.
  ///
  /// In en, this message translates to:
  /// **'No recurrence'**
  String get schedule_recurrence_none;

  /// No description provided for @erp_menu_schedule.
  ///
  /// In en, this message translates to:
  /// **'Schedule'**
  String get erp_menu_schedule;

  /// No description provided for @erp_menu_schedule_events.
  ///
  /// In en, this message translates to:
  /// **'Events and Schedule'**
  String get erp_menu_schedule_events;

  /// No description provided for @schedule_duplicate_title.
  ///
  /// In en, this message translates to:
  /// **'Duplicate event'**
  String get schedule_duplicate_title;

  /// No description provided for @schedule_duplicate_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Create a new event based on: {originalTitle}'**
  String schedule_duplicate_subtitle(String originalTitle);

  /// No description provided for @schedule_duplicate_summary_title.
  ///
  /// In en, this message translates to:
  /// **'Original event summary'**
  String get schedule_duplicate_summary_title;

  /// No description provided for @schedule_duplicate_adjustments_title.
  ///
  /// In en, this message translates to:
  /// **'Adjustments before creating'**
  String get schedule_duplicate_adjustments_title;

  /// No description provided for @schedule_duplicate_open_edit.
  ///
  /// In en, this message translates to:
  /// **'Open full edit after creating'**
  String get schedule_duplicate_open_edit;

  /// No description provided for @schedule_duplicate_action_create.
  ///
  /// In en, this message translates to:
  /// **'Create copy'**
  String get schedule_duplicate_action_create;

  /// No description provided for @schedule_duplicate_toast_success.
  ///
  /// In en, this message translates to:
  /// **'Event duplicated successfully!'**
  String get schedule_duplicate_toast_success;

  /// No description provided for @schedule_duplicate_toast_error.
  ///
  /// In en, this message translates to:
  /// **'Error duplicating event'**
  String get schedule_duplicate_toast_error;

  /// No description provided for @accountsPayable_help_cst_title.
  ///
  /// In en, this message translates to:
  /// **'Tax Situation Code (CST)'**
  String get accountsPayable_help_cst_title;

  /// No description provided for @accountsPayable_help_cst_description.
  ///
  /// In en, this message translates to:
  /// **'CST shows how the tax applies to the operation.'**
  String get accountsPayable_help_cst_description;

  /// No description provided for @accountsPayable_help_cst_00.
  ///
  /// In en, this message translates to:
  /// **'Full taxation (Normal ICMS)'**
  String get accountsPayable_help_cst_00;

  /// No description provided for @accountsPayable_help_cst_10.
  ///
  /// In en, this message translates to:
  /// **'Taxed with ICMS by substitution'**
  String get accountsPayable_help_cst_10;

  /// No description provided for @accountsPayable_help_cst_20.
  ///
  /// In en, this message translates to:
  /// **'With tax base reduction'**
  String get accountsPayable_help_cst_20;

  /// No description provided for @accountsPayable_help_cst_40.
  ///
  /// In en, this message translates to:
  /// **'Exempt or non-taxed'**
  String get accountsPayable_help_cst_40;

  /// No description provided for @accountsPayable_help_cst_60.
  ///
  /// In en, this message translates to:
  /// **'ICMS previously charged via ST'**
  String get accountsPayable_help_cst_60;

  /// No description provided for @accountsPayable_help_cst_90.
  ///
  /// In en, this message translates to:
  /// **'Other specific situations'**
  String get accountsPayable_help_cst_90;

  /// No description provided for @accountsPayable_help_cfop_title.
  ///
  /// In en, this message translates to:
  /// **'Fiscal Operations Code (CFOP)'**
  String get accountsPayable_help_cfop_title;

  /// No description provided for @accountsPayable_help_cfop_description.
  ///
  /// In en, this message translates to:
  /// **'CFOP describes the operation type (purchase, sale, service).'**
  String get accountsPayable_help_cfop_description;

  /// No description provided for @accountsPayable_help_cfop_digit_info.
  ///
  /// In en, this message translates to:
  /// **'First digit indicates origin/destination:'**
  String get accountsPayable_help_cfop_digit_info;

  /// No description provided for @accountsPayable_help_cfop_1xxx.
  ///
  /// In en, this message translates to:
  /// **'In-state entries'**
  String get accountsPayable_help_cfop_1xxx;

  /// No description provided for @accountsPayable_help_cfop_2xxx.
  ///
  /// In en, this message translates to:
  /// **'Out-of-state entries'**
  String get accountsPayable_help_cfop_2xxx;

  /// No description provided for @accountsPayable_help_cfop_5xxx.
  ///
  /// In en, this message translates to:
  /// **'In-state exits'**
  String get accountsPayable_help_cfop_5xxx;

  /// No description provided for @accountsPayable_help_cfop_6xxx.
  ///
  /// In en, this message translates to:
  /// **'Out-of-state exits'**
  String get accountsPayable_help_cfop_6xxx;

  /// No description provided for @accountsPayable_help_cfop_7xxx.
  ///
  /// In en, this message translates to:
  /// **'International operations'**
  String get accountsPayable_help_cfop_7xxx;

  /// No description provided for @accountsPayable_help_cfop_examples_title.
  ///
  /// In en, this message translates to:
  /// **'Useful examples:'**
  String get accountsPayable_help_cfop_examples_title;

  /// No description provided for @accountsPayable_help_cfop_1101.
  ///
  /// In en, this message translates to:
  /// **'Purchase for industrialization'**
  String get accountsPayable_help_cfop_1101;

  /// No description provided for @accountsPayable_help_cfop_1556.
  ///
  /// In en, this message translates to:
  /// **'Purchase for internal use/consumption'**
  String get accountsPayable_help_cfop_1556;

  /// No description provided for @accountsPayable_help_cfop_5405.
  ///
  /// In en, this message translates to:
  /// **'Sale subject to tax substitution'**
  String get accountsPayable_help_cfop_5405;

  /// No description provided for @accountsPayable_help_cfop_6102.
  ///
  /// In en, this message translates to:
  /// **'Sale for commercialization out-of-state'**
  String get accountsPayable_help_cfop_6102;

  /// No description provided for @common_understood.
  ///
  /// In en, this message translates to:
  /// **'Understood'**
  String get common_understood;

  /// No description provided for @bankStatements_link_dialog_title.
  ///
  /// In en, this message translates to:
  /// **'Link Financial Record'**
  String get bankStatements_link_dialog_title;

  /// No description provided for @bankStatements_link_dialog_id_label.
  ///
  /// In en, this message translates to:
  /// **'Financial Record ID'**
  String get bankStatements_link_dialog_id_label;

  /// No description provided for @bankStatements_link_dialog_id_error.
  ///
  /// In en, this message translates to:
  /// **'Please enter the record identifier.'**
  String get bankStatements_link_dialog_id_error;

  /// No description provided for @bankStatements_link_dialog_suggestions_title.
  ///
  /// In en, this message translates to:
  /// **'Automatic Suggestions'**
  String get bankStatements_link_dialog_suggestions_title;

  /// No description provided for @bankStatements_link_dialog_suggestions_error.
  ///
  /// In en, this message translates to:
  /// **'Could not load suggestions. Please try again later.'**
  String get bankStatements_link_dialog_suggestions_error;

  /// No description provided for @bankStatements_link_dialog_suggestions_empty.
  ///
  /// In en, this message translates to:
  /// **'No record matches the amount and date.'**
  String get bankStatements_link_dialog_suggestions_empty;

  /// No description provided for @bankStatements_link_dialog_use_id.
  ///
  /// In en, this message translates to:
  /// **'Use ID'**
  String get bankStatements_link_dialog_use_id;

  /// No description provided for @bankStatements_link_dialog_no_concept.
  ///
  /// In en, this message translates to:
  /// **'No concept'**
  String get bankStatements_link_dialog_no_concept;

  /// No description provided for @bankStatements_link_dialog_saving.
  ///
  /// In en, this message translates to:
  /// **'Saving...'**
  String get bankStatements_link_dialog_saving;

  /// No description provided for @bankStatements_link_dialog_link_button.
  ///
  /// In en, this message translates to:
  /// **'Link'**
  String get bankStatements_link_dialog_link_button;

  /// No description provided for @bankStatements_link_dialog_link_error.
  ///
  /// In en, this message translates to:
  /// **'Could not link. Check the provided identifier.'**
  String get bankStatements_link_dialog_link_error;

  /// No description provided for @tax_form_title_add.
  ///
  /// In en, this message translates to:
  /// **'Add Tax'**
  String get tax_form_title_add;

  /// No description provided for @tax_form_title_edit.
  ///
  /// In en, this message translates to:
  /// **'Edit Tax'**
  String get tax_form_title_edit;

  /// No description provided for @tax_form_type_label.
  ///
  /// In en, this message translates to:
  /// **'Tax Type'**
  String get tax_form_type_label;

  /// No description provided for @tax_form_type_error.
  ///
  /// In en, this message translates to:
  /// **'Enter tax type'**
  String get tax_form_type_error;

  /// No description provided for @tax_form_percentage_label.
  ///
  /// In en, this message translates to:
  /// **'Percentage (%)'**
  String get tax_form_percentage_label;

  /// No description provided for @tax_form_percentage_error.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid percentage'**
  String get tax_form_percentage_error;

  /// No description provided for @tax_form_amount_label.
  ///
  /// In en, this message translates to:
  /// **'Retained Value'**
  String get tax_form_amount_label;

  /// No description provided for @tax_form_amount_error.
  ///
  /// In en, this message translates to:
  /// **'Enter a value greater than zero'**
  String get tax_form_amount_error;

  /// No description provided for @tax_form_status_label.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get tax_form_status_label;

  /// No description provided for @tax_form_status_taxed.
  ///
  /// In en, this message translates to:
  /// **'Taxed'**
  String get tax_form_status_taxed;

  /// No description provided for @tax_form_status_substitution.
  ///
  /// In en, this message translates to:
  /// **'Tax Substitution'**
  String get tax_form_status_substitution;

  /// No description provided for @tax_form_empty_list.
  ///
  /// In en, this message translates to:
  /// **'No taxes added yet.'**
  String get tax_form_empty_list;

  /// No description provided for @common_save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get common_save;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['en', 'es', 'pt'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en': return AppLocalizationsEn();
    case 'es': return AppLocalizationsEs();
    case 'pt': return AppLocalizationsPt();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
