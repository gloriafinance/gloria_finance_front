// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get month_january => 'January';

  @override
  String get month_february => 'February';

  @override
  String get month_march => 'March';

  @override
  String get month_april => 'April';

  @override
  String get month_may => 'May';

  @override
  String get month_june => 'June';

  @override
  String get month_july => 'July';

  @override
  String get month_august => 'August';

  @override
  String get month_september => 'September';

  @override
  String get month_october => 'October';

  @override
  String get month_november => 'November';

  @override
  String get month_december => 'December';

  @override
  String get common_filters => 'Filters';

  @override
  String get common_filters_upper => 'FILTERS';

  @override
  String get common_all_banks => 'All banks';

  @override
  String get common_all_status => 'All statuses';

  @override
  String get common_all_months => 'All months';

  @override
  String get common_all_years => 'All years';

  @override
  String get common_bank => 'Bank';

  @override
  String get common_status => 'Status';

  @override
  String get common_start_date => 'Start date';

  @override
  String get common_end_date => 'End date';

  @override
  String get common_month => 'Month';

  @override
  String get common_year => 'Year';

  @override
  String get common_clear_filters => 'Clear filters';

  @override
  String get common_loading => 'Loading...';

  @override
  String get common_apply_filters => 'Apply filters';

  @override
  String get common_load_more => 'Load more';

  @override
  String get common_no_results_found => 'No results found';

  @override
  String get common_search_hint => 'Search...';

  @override
  String get common_actions => 'Actions';

  @override
  String get common_edit => 'Edit';

  @override
  String get auth_login_email_label => 'Email';

  @override
  String get auth_login_password_label => 'Password';

  @override
  String get auth_login_forgot_password => 'Forgot your password?';

  @override
  String get auth_login_submit => 'Sign in';

  @override
  String get auth_login_error_invalid_email => 'Enter a valid email address';

  @override
  String get auth_login_error_required_password => 'Enter your password';

  @override
  String get auth_error_generic => 'An internal system error occurred, please contact your system administrator';

  @override
  String get auth_recovery_request_title => 'Enter the email associated with your account and we will send you a temporary password.';

  @override
  String get auth_recovery_request_loading => 'Requesting temporary password';

  @override
  String get auth_recovery_request_submit => 'Send';

  @override
  String get auth_recovery_request_email_required => 'Email is required';

  @override
  String get auth_recovery_change_title => 'Set a new password';

  @override
  String get auth_recovery_change_description => 'Create a new password. Make sure it is different from previous ones for security';

  @override
  String get auth_recovery_old_password_label => 'Current password';

  @override
  String get auth_recovery_new_password_label => 'New password';

  @override
  String get auth_recovery_change_error_old_password_required => 'Enter your current password';

  @override
  String get auth_recovery_change_error_new_password_required => 'Enter a new password';

  @override
  String get auth_recovery_change_error_min_length => 'The password must be at least 8 characters long';

  @override
  String get auth_recovery_change_error_lowercase => 'The password must contain at least one lowercase letter';

  @override
  String get auth_recovery_change_error_uppercase => 'The password must contain at least one uppercase letter';

  @override
  String get auth_recovery_change_error_number => 'The password must contain at least one number';

  @override
  String get auth_recovery_success_title => 'Check your email';

  @override
  String auth_recovery_success_body(String email) {
    return 'We sent a temporary password to $email. If you do not see it, check your spam folder. If you have already received it, click the button below.';
  }

  @override
  String get auth_recovery_success_continue => 'Continue';

  @override
  String get auth_recovery_success_resend => 'Haven\'t received the email yet? Resend email';

  @override
  String get auth_recovery_success_resend_ok => 'Email resent successfully';

  @override
  String get auth_recovery_success_resend_error => 'Error while resending email';

  @override
  String get auth_recovery_back_to_login => 'Back to login';

  @override
  String get auth_policies_title => 'Before continuing, please review and accept Glória Finance policies';

  @override
  String get auth_policies_info_title => 'Important information:';

  @override
  String get auth_policies_info_body => '• The church and Glória Finance process personal and sensitive data in order for the system to work.\n\n• In accordance with the Brazilian General Data Protection Law (LGPD), you must accept the policies below to continue using the platform.\n\n• Click the links to read the full text before accepting.';

  @override
  String get auth_policies_privacy => 'Privacy Policy';

  @override
  String get auth_policies_sensitive => 'Sensitive Data Processing Policy';

  @override
  String get auth_policies_accept_and_continue => 'Accept and continue';

  @override
  String auth_policies_link_error(String url) {
    return 'Could not open link: $url';
  }

  @override
  String get auth_policies_checkbox_prefix => 'I have read and agree with the ';

  @override
  String get auth_layout_version_loading => 'Loading...';

  @override
  String auth_layout_footer(int year) {
    return '© $year Jaspesoft CNPJ 43.716.343/0001-60 ';
  }

  @override
  String get erp_menu_settings => 'Financial Settings';

  @override
  String get erp_menu_settings_security => 'Security Settings';

  @override
  String get erp_menu_settings_users_access => 'Users and access';

  @override
  String get erp_menu_settings_roles_permissions => 'Roles and permissions';

  @override
  String get erp_menu_settings_members => 'Members';

  @override
  String get erp_menu_settings_financial_periods => 'Financial periods';

  @override
  String get erp_menu_settings_availability_accounts => 'Availability accounts';

  @override
  String get erp_menu_settings_banks => 'Banks';

  @override
  String get erp_menu_settings_cost_centers => 'Cost centers';

  @override
  String get erp_menu_settings_suppliers => 'Suppliers';

  @override
  String get erp_menu_settings_financial_concepts => 'Financial concepts';

  @override
  String get erp_menu_finance => 'Finance';

  @override
  String get erp_menu_finance_contributions => 'Contributions';

  @override
  String get erp_menu_finance_records => 'Financial records';

  @override
  String get erp_menu_finance_bank_reconciliation => 'Bank reconciliation';

  @override
  String get erp_menu_finance_accounts_receivable => 'Accounts receivable';

  @override
  String get erp_menu_finance_accounts_payable => 'Accounts payable';

  @override
  String get erp_menu_finance_purchases => 'Purchases';

  @override
  String get erp_menu_assets => 'Assets';

  @override
  String get erp_menu_assets_items => 'Asset items';

  @override
  String get erp_menu_reports => 'Reports';

  @override
  String get erp_menu_reports_monthly_tithes => 'Monthly tithes';

  @override
  String get erp_menu_reports_income_statement => 'Income statement';

  @override
  String get erp_menu_reports_dre => 'DRE';

  @override
  String get common_cancel => 'Cancel';

  @override
  String get common_retry => 'Reload';

  @override
  String get common_processing => 'Processing...';

  @override
  String get patrimony_assets_list_title => 'Assets';

  @override
  String get patrimony_assets_list_new => 'Register asset';

  @override
  String get patrimony_assets_filter_category => 'Category';

  @override
  String get patrimony_assets_table_error_loading => 'Could not load assets. Please try again.';

  @override
  String get patrimony_assets_table_empty => 'No assets found for the selected filters.';

  @override
  String get patrimony_assets_table_header_code => 'Code';

  @override
  String get patrimony_assets_table_header_name => 'Name';

  @override
  String get patrimony_assets_table_header_category => 'Category';

  @override
  String get patrimony_assets_table_header_value => 'Value';

  @override
  String get patrimony_assets_table_header_acquisition => 'Acquisition';

  @override
  String get patrimony_assets_table_header_location => 'Location';

  @override
  String get patrimony_inventory_import_file_label => 'Filled CSV file';

  @override
  String patrimony_inventory_import_file_size(int size) {
    return 'Size: $size KB';
  }

  @override
  String get patrimony_inventory_import_description_title => 'Upload the completed physical checklist to update the assets.';

  @override
  String get patrimony_inventory_import_description_body => 'Make sure the columns \"Asset ID\", \"Inventory code\" and \"Inventory quantity\" are filled in. Optional fields such as status and notes will also be processed when provided.';

  @override
  String get patrimony_inventory_import_button_loading => 'Importing...';

  @override
  String get patrimony_inventory_import_button_submit => 'Import checklist';

  @override
  String get patrimony_inventory_import_error_no_file => 'Select the exported file before importing.';

  @override
  String get patrimony_inventory_import_error_read_file => 'Could not read the selected file.';

  @override
  String get patrimony_inventory_import_error_generic => 'Could not import the checklist. Please try again.';

  @override
  String get patrimony_asset_detail_tab_details => 'Details';

  @override
  String get patrimony_asset_detail_tab_history => 'History';

  @override
  String get patrimony_asset_detail_category => 'Category';

  @override
  String get patrimony_asset_detail_quantity => 'Quantity';

  @override
  String get patrimony_asset_detail_acquisition_date => 'Acquisition date';

  @override
  String get patrimony_asset_detail_location => 'Location';

  @override
  String get patrimony_asset_detail_responsible => 'Responsible';

  @override
  String get patrimony_asset_detail_pending_documents => 'Pending documents';

  @override
  String get patrimony_asset_detail_notes => 'Notes';

  @override
  String patrimony_asset_detail_quantity_badge(int quantity) {
    return 'Qty: $quantity';
  }

  @override
  String patrimony_asset_detail_updated_at(String date) {
    return 'Updated at $date';
  }

  @override
  String get patrimony_asset_detail_inventory_register => 'Register inventory';

  @override
  String get patrimony_asset_detail_inventory_update => 'Update inventory';

  @override
  String get patrimony_asset_detail_inventory_modal_title => 'Register physical inventory';

  @override
  String get patrimony_asset_detail_inventory_success => 'Inventory registered successfully.';

  @override
  String get patrimony_asset_detail_disposal_register => 'Register disposal';

  @override
  String get patrimony_asset_detail_disposal_modal_title => 'Register disposal';

  @override
  String get patrimony_asset_detail_disposal_success => 'Disposal registered';

  @override
  String get patrimony_asset_detail_disposal_error => 'Error while registering disposal';

  @override
  String get patrimony_asset_detail_disposal_status => 'Status';

  @override
  String get patrimony_asset_detail_disposal_reason => 'Reason';

  @override
  String get patrimony_asset_detail_disposal_date => 'Disposal date';

  @override
  String get patrimony_asset_detail_disposal_performed_by => 'Registered by';

  @override
  String get patrimony_asset_detail_disposal_value => 'Disposal value';

  @override
  String get patrimony_asset_detail_inventory_result => 'Result';

  @override
  String get patrimony_asset_detail_inventory_checked_at => 'Check date';

  @override
  String get patrimony_asset_detail_inventory_checked_by => 'Checked by';

  @override
  String get patrimony_asset_detail_inventory_title => 'Physical inventory';

  @override
  String get patrimony_asset_detail_attachments_empty => 'No attachments available.';

  @override
  String get patrimony_asset_detail_attachments_title => 'Attachments';

  @override
  String get patrimony_asset_detail_attachment_view_pdf => 'View PDF';

  @override
  String get patrimony_asset_detail_attachment_open => 'Open';

  @override
  String get patrimony_asset_detail_history_empty => 'No change history.';

  @override
  String get patrimony_asset_detail_history_title => 'Movement history';

  @override
  String get patrimony_asset_detail_history_changes_title => 'Registered changes';

  @override
  String get patrimony_asset_detail_yes => 'Yes';

  @override
  String get patrimony_asset_detail_no => 'No';

  @override
  String get erp_header_change_password => 'Change password';

  @override
  String get erp_header_logout => 'Logout';

  @override
  String get auth_policies_submit_error_null => 'Could not register your acceptance. Please try again.';

  @override
  String get auth_policies_submit_error_generic => 'An error occurred while registering your acceptance. Please try again.';

  @override
  String get auth_recovery_step_title_request => 'Send temporary password';

  @override
  String get auth_recovery_step_title_confirm => 'Confirm receipt of temporary password';

  @override
  String get auth_recovery_step_title_new_password => 'Set new password';

  @override
  String get erp_home_welcome_member => 'Welcome to Church Finance!\\n\\n';

  @override
  String get erp_home_no_availability_accounts => 'No availability accounts found';

  @override
  String get erp_home_availability_summary_title => 'Availability accounts summary';

  @override
  String get erp_home_availability_swipe_hint => 'Swipe to see all accounts';

  @override
  String get erp_home_header_title => 'Dashboard';

  @override
  String get settings_banks_title => 'Banks';

  @override
  String get settings_banks_new_bank => 'New bank';

  @override
  String get settings_banks_form_title_create => 'New bank';

  @override
  String get settings_banks_form_title_edit => 'Edit bank';

  @override
  String get settings_banks_field_name => 'Name';

  @override
  String get settings_banks_field_holder_name => 'Account holder name';

  @override
  String get settings_banks_field_document_id => 'Document ID';

  @override
  String get settings_banks_field_tag => 'Tag';

  @override
  String get settings_banks_field_account_type => 'Account type';

  @override
  String get settings_banks_field_pix_key => 'PIX key';

  @override
  String get settings_banks_field_bank_code => 'Bank code';

  @override
  String get settings_banks_field_agency => 'Branch';

  @override
  String get settings_banks_field_account => 'Account';

  @override
  String get settings_banks_field_active => 'Active';

  @override
  String get settings_banks_error_required => 'Required field';

  @override
  String get settings_banks_error_invalid_number => 'Enter a valid number';

  @override
  String get settings_banks_error_select_account_type => 'Select an account type';

  @override
  String get settings_banks_save => 'Save';

  @override
  String get settings_banks_toast_saved => 'Record saved successfully';

  @override
  String get settings_availability_list_title => 'Accounts list';

  @override
  String get settings_availability_new_account => 'Availability account';

  @override
  String get settings_availability_form_title => 'Register availability account';

  @override
  String get settings_availability_save => 'Save';

  @override
  String get settings_availability_toast_saved => 'Record saved successfully';

  @override
  String get settings_availability_table_header_name => 'Account name';

  @override
  String get settings_availability_table_header_type => 'Account type';

  @override
  String get settings_availability_table_header_balance => 'Balance';

  @override
  String get settings_availability_table_header_status => 'Status';

  @override
  String settings_availability_view_title(String id) {
    return 'Availability account #$id';
  }

  @override
  String get settings_availability_field_name => 'Name';

  @override
  String get settings_availability_field_balance => 'Balance';

  @override
  String get settings_availability_field_type => 'Type';

  @override
  String get settings_availability_field_active => 'Active';

  @override
  String get settings_availability_field_bank => 'Bank';

  @override
  String get settings_availability_field_currency => 'Currency';

  @override
  String get settings_availability_bank_details_title => 'Bank details';

  @override
  String get settings_availability_account_type_bank => 'Bank';

  @override
  String get settings_availability_account_type_cash => 'Cash';

  @override
  String get settings_availability_account_type_wallet => 'Digital wallet';

  @override
  String get settings_availability_account_type_investment => 'Investment';

  @override
  String get settings_cost_center_title => 'Cost centers';

  @override
  String get settings_cost_center_new => 'New cost center';

  @override
  String get settings_cost_center_field_code => 'Code';

  @override
  String get settings_cost_center_field_name => 'Name';

  @override
  String get settings_cost_center_field_category => 'Category';

  @override
  String get settings_cost_center_field_responsible => 'Responsible';

  @override
  String get settings_cost_center_field_description => 'Description';

  @override
  String get settings_cost_center_field_active => 'Active';

  @override
  String get settings_cost_center_category_special_project => 'Special projects';

  @override
  String get settings_cost_center_category_ministries => 'Ministries';

  @override
  String get settings_cost_center_category_operations => 'Operations';

  @override
  String get settings_cost_center_error_required => 'Required field';

  @override
  String get settings_cost_center_error_select_category => 'Select a category';

  @override
  String get settings_cost_center_error_select_responsible => 'Select a responsible member';

  @override
  String settings_cost_center_help_code(int maxLength) {
    return 'Use an easy-to-remember code with up to $maxLength characters.';
  }

  @override
  String get settings_cost_center_help_description => 'Describe briefly how this cost center will be used.';

  @override
  String get settings_cost_center_save => 'Save';

  @override
  String get settings_cost_center_update => 'Update';

  @override
  String get settings_cost_center_toast_saved => 'Record saved successfully';

  @override
  String get settings_cost_center_toast_updated => 'Record updated successfully';

  @override
  String get settings_financial_concept_title => 'Financial concepts';

  @override
  String get settings_financial_concept_new => 'New concept';

  @override
  String get settings_financial_concept_filter_all => 'All';

  @override
  String get settings_financial_concept_filter_by_type => 'Filter by type';

  @override
  String get settings_financial_concept_field_name => 'Name';

  @override
  String get settings_financial_concept_field_description => 'Description';

  @override
  String get settings_financial_concept_field_type => 'Concept type';

  @override
  String get settings_financial_concept_field_statement_category => 'Statement category';

  @override
  String get settings_financial_concept_field_active => 'Active';

  @override
  String get settings_financial_concept_indicators_title => 'Accounting indicators';

  @override
  String get settings_financial_concept_indicator_cash_flow => 'Impacts cash flow';

  @override
  String get settings_financial_concept_indicator_result => 'Impacts result (P&L)';

  @override
  String get settings_financial_concept_indicator_balance => 'Impacts balance sheet';

  @override
  String get settings_financial_concept_indicator_operational => 'Recurring operational event';

  @override
  String get settings_financial_concept_error_required => 'Required field';

  @override
  String get settings_financial_concept_error_select_type => 'Select a type';

  @override
  String get settings_financial_concept_error_select_category => 'Select a category';

  @override
  String get settings_financial_concept_help_statement_categories => 'Understand the categories';

  @override
  String get settings_financial_concept_help_indicators => 'Understand the indicators';

  @override
  String get settings_financial_concept_save => 'Save';

  @override
  String get settings_financial_concept_toast_saved => 'Record saved successfully';

  @override
  String get settings_financial_concept_help_statement_title => 'Statement categories';

  @override
  String get settings_financial_concept_help_indicator_intro => 'These indicators determine how the concept will be reflected in financial reports. They can be adjusted as needed for specific cases.';

  @override
  String get settings_financial_concept_help_indicator_cash_flow_title => 'Impacts cash flow';

  @override
  String get settings_financial_concept_help_indicator_cash_flow_desc => 'Check when the entry changes the available balance after payment or receipt.';

  @override
  String get settings_financial_concept_help_indicator_result_title => 'Impacts result (P&L)';

  @override
  String get settings_financial_concept_help_indicator_result_desc => 'Use when the amount should be part of the income statement, affecting profit or loss.';

  @override
  String get settings_financial_concept_help_indicator_balance_title => 'Impacts balance sheet';

  @override
  String get settings_financial_concept_help_indicator_balance_desc => 'Select for events that create or settle assets and liabilities directly in the balance sheet.';

  @override
  String get settings_financial_concept_help_indicator_operational_title => 'Recurring operational event';

  @override
  String get settings_financial_concept_help_indicator_operational_desc => 'Enable for routine commitments in the church\'s day-to-day operations, related to core activities.';

  @override
  String get settings_financial_concept_help_understood => 'Got it';

  @override
  String get bankStatements_empty_title => 'No statements imported yet.';

  @override
  String get bankStatements_empty_subtitle => 'Import a CSV file to start bank reconciliation.';

  @override
  String get bankStatements_header_date => 'Date';

  @override
  String get bankStatements_header_bank => 'Bank';

  @override
  String get bankStatements_header_description => 'Description';

  @override
  String get bankStatements_header_amount => 'Amount';

  @override
  String get bankStatements_header_direction => 'Direction';

  @override
  String get bankStatements_header_status => 'Status';

  @override
  String get bankStatements_action_details => 'Details';

  @override
  String get bankStatements_action_retry => 'Retry';

  @override
  String get bankStatements_action_link => 'Link';

  @override
  String get bankStatements_action_linking => 'Linking...';

  @override
  String get bankStatements_toast_auto_reconciled => 'Statement reconciled automatically.';

  @override
  String get bankStatements_toast_no_match => 'No matching transaction found.';

  @override
  String get bankStatements_details_title => 'Bank statement details';

  @override
  String get bankStatements_toast_link_success => 'Statement linked successfully.';

  @override
  String get settings_financial_months_empty => 'No financial months found.';

  @override
  String get settings_financial_months_header_month => 'Month';

  @override
  String get settings_financial_months_header_year => 'Year';

  @override
  String get settings_financial_months_header_status => 'Status';

  @override
  String get settings_financial_months_action_reopen => 'Reopen';

  @override
  String get settings_financial_months_action_close => 'Close';

  @override
  String get settings_financial_months_modal_close_title => 'Close month';

  @override
  String get settings_financial_months_modal_reopen_title => 'Reopen month';

  @override
  String get accountsReceivable_list_title => 'Accounts receivable list';

  @override
  String get accountsReceivable_list_title_mobile => 'Accounts receivable';

  @override
  String get accountsReceivable_list_new => 'Register account receivable';

  @override
  String get accountsReceivable_table_empty => 'No accounts receivable to show';

  @override
  String get accountsReceivable_table_header_debtor => 'Debtor';

  @override
  String get accountsReceivable_table_header_description => 'Description';

  @override
  String get accountsReceivable_table_header_type => 'Type';

  @override
  String get accountsReceivable_table_header_installments => 'No. of installments';

  @override
  String get accountsReceivable_table_header_received => 'Received';

  @override
  String get accountsReceivable_table_header_pending => 'Pending';

  @override
  String get accountsReceivable_table_header_total => 'Total receivable';

  @override
  String get accountsReceivable_table_header_status => 'Status';

  @override
  String get accountsReceivable_table_action_view => 'View';

  @override
  String get accountsReceivable_register_title => 'Register account receivable';

  @override
  String get accountsReceivable_view_title => 'Account receivable detail';

  @override
  String get accountsReceivable_form_field_financial_concept => 'Financial concept';

  @override
  String get accountsReceivable_form_field_debtor_dni => 'Debtor tax ID';

  @override
  String get accountsReceivable_form_field_debtor_phone => 'Debtor phone';

  @override
  String get accountsReceivable_form_field_debtor_name => 'Debtor name';

  @override
  String get accountsReceivable_form_field_debtor_email => 'Debtor email';

  @override
  String get accountsReceivable_form_field_debtor_address => 'Debtor address';

  @override
  String get accountsReceivable_form_field_member => 'Select member';

  @override
  String get accountsReceivable_form_field_single_due_date => 'Due date';

  @override
  String get accountsReceivable_form_field_automatic_installments => 'Number of installments';

  @override
  String get accountsReceivable_form_field_automatic_amount => 'Amount per installment';

  @override
  String get accountsReceivable_form_error_member_required => 'Select a member';

  @override
  String get accountsReceivable_form_error_description_required => 'Description is required';

  @override
  String get accountsReceivable_form_error_financial_concept_required => 'Select a financial concept';

  @override
  String get accountsReceivable_form_error_debtor_name_required => 'Debtor name is required';

  @override
  String get accountsReceivable_form_error_debtor_dni_required => 'Debtor identifier is required';

  @override
  String get accountsReceivable_form_error_debtor_phone_required => 'Debtor phone is required';

  @override
  String get accountsReceivable_form_error_debtor_email_required => 'Debtor email is required';

  @override
  String get accountsReceivable_form_error_total_amount_required => 'Enter the total amount';

  @override
  String get accountsReceivable_form_error_single_due_date_required => 'Enter the due date';

  @override
  String get accountsReceivable_form_error_installments_required => 'Generate the installments to continue';

  @override
  String get accountsReceivable_form_error_installments_invalid => 'Fill in amount and due date for each installment';

  @override
  String get accountsReceivable_form_error_automatic_installments_required => 'Enter the number of installments';

  @override
  String get accountsReceivable_form_error_automatic_amount_required => 'Enter the amount per installment';

  @override
  String get accountsReceivable_form_error_automatic_first_due_date_required => 'Enter the date of the first installment';

  @override
  String get accountsReceivable_form_error_installments_count_mismatch => 'The number of generated installments must match the total informed';

  @override
  String get accountsReceivable_form_debtor_type_title => 'Debtor type';

  @override
  String get accountsReceivable_form_debtor_type_member => 'Church member';

  @override
  String get accountsReceivable_form_debtor_type_external => 'External';

  @override
  String get accountsReceivable_form_installments_single_empty_message => 'Enter the amount and due date to see the summary.';

  @override
  String get accountsReceivable_form_installments_automatic_empty_message => 'Enter the data and click \"Generate installments\" to see the schedule.';

  @override
  String get accountsReceivable_form_installments_summary_title => 'Installments summary';

  @override
  String accountsReceivable_form_installment_item_title(int index) {
    return 'Installment $index';
  }

  @override
  String accountsReceivable_form_installment_item_due_date(String date) {
    return 'Due date: $date';
  }

  @override
  String accountsReceivable_form_installments_summary_total(String amount) {
    return 'Total: $amount';
  }

  @override
  String get accountsReceivable_form_save => 'Save';

  @override
  String get accountsReceivable_form_toast_saved_success => 'Account receivable registered successfully';

  @override
  String get accountsReceivable_form_toast_saved_error => 'Error while registering account receivable';

  @override
  String get accountsReceivable_view_debtor_section => 'Debtor information';

  @override
  String get accountsReceivable_view_debtor_name => 'Name';

  @override
  String get accountsReceivable_view_debtor_dni => 'Tax ID';

  @override
  String get accountsReceivable_view_debtor_type => 'Debtor type';

  @override
  String get accountsReceivable_view_installments_title => 'Installments list';

  @override
  String get accountsReceivable_view_register_payment => 'Register payment';

  @override
  String get accountsReceivable_view_general_section => 'General information';

  @override
  String get accountsReceivable_view_general_created => 'Created';

  @override
  String get accountsReceivable_view_general_updated => 'Updated';

  @override
  String get accountsReceivable_view_general_description => 'Description';

  @override
  String get accountsReceivable_view_general_type => 'Type';

  @override
  String get accountsReceivable_view_general_total => 'Total amount';

  @override
  String get accountsReceivable_view_general_paid => 'Amount paid';

  @override
  String get accountsReceivable_view_general_pending => 'Amount pending';

  @override
  String get accountsReceivable_payment_total_label => 'Total amount to be paid';

  @override
  String get accountsReceivable_payment_submit => 'Submit payment';

  @override
  String get accountsReceivable_payment_receipt_label => 'Transfer receipt';

  @override
  String get accountsReceivable_payment_availability_account_label => 'Availability account';

  @override
  String get accountsReceivable_payment_amount_label => 'Payment amount';

  @override
  String get accountsReceivable_payment_toast_success => 'Payment registered successfully';

  @override
  String get accountsReceivable_payment_error_amount_required => 'Enter the payment amount';

  @override
  String get accountsReceivable_payment_error_availability_account_required => 'Select an availability account';

  @override
  String get accountsReceivable_form_field_automatic_first_due_date => 'First installment date';

  @override
  String get accountsReceivable_form_generate_installments => 'Generate installments';

  @override
  String get accountsReceivable_form_error_generate_installments_fill_data => 'Fill in the data to generate the installments.';

  @override
  String get accountsReceivable_form_toast_generate_installments_success => 'Installments generated automatically.';

  @override
  String get accountsPayable_list_title => 'Accounts payable';

  @override
  String get accountsPayable_list_new => 'Register accounts payable';

  @override
  String get accountsPayable_table_empty => 'No accounts payable to show';

  @override
  String get accountsPayable_table_header_supplier => 'Supplier';

  @override
  String get accountsPayable_table_header_description => 'Description';

  @override
  String get accountsPayable_table_header_installments => 'No. of installments';

  @override
  String get accountsPayable_table_header_paid => 'Paid';

  @override
  String get accountsPayable_table_header_pending => 'Pending';

  @override
  String get accountsPayable_table_header_total => 'Total payable';

  @override
  String get accountsPayable_table_header_status => 'Status';

  @override
  String get accountsPayable_table_action_view => 'View';

  @override
  String get accountsPayable_register_title => 'Register account payable';

  @override
  String get accountsPayable_view_title => 'Accounts payable detail';

  @override
  String get accountsPayable_view_installments_title => 'Installments list';

  @override
  String get accountsPayable_view_register_payment => 'Register payment';

  @override
  String get accountsPayable_view_provider_section => 'Supplier information';

  @override
  String get accountsPayable_view_provider_name => 'Name';

  @override
  String get accountsPayable_view_provider_dni => 'Tax ID';

  @override
  String get accountsPayable_view_provider_phone => 'Phone';

  @override
  String get accountsPayable_view_provider_email => 'Email';

  @override
  String get accountsPayable_view_provider_type => 'Supplier type';

  @override
  String get accountsPayable_view_general_section => 'General information';

  @override
  String get accountsPayable_view_general_created => 'Created';

  @override
  String get accountsPayable_view_general_updated => 'Updated';

  @override
  String get accountsPayable_view_general_description => 'Description';

  @override
  String get accountsPayable_view_general_total => 'Total amount';

  @override
  String get accountsPayable_view_general_paid => 'Amount paid';

  @override
  String get accountsPayable_view_general_pending => 'Amount pending';

  @override
  String get accountsPayable_payment_total_label => 'Total amount to be paid';

  @override
  String get accountsPayable_payment_submit => 'Submit payment';

  @override
  String get accountsPayable_payment_receipt_label => 'Transfer receipt';

  @override
  String get accountsPayable_payment_cost_center_label => 'Cost center';

  @override
  String get accountsPayable_payment_availability_account_label => 'Availability account';

  @override
  String get accountsPayable_payment_amount_label => 'Payment amount';

  @override
  String get accountsPayable_payment_toast_success => 'Payment registered successfully';

  @override
  String get accountsPayable_form_section_basic_title => 'Basic information';

  @override
  String get accountsPayable_form_section_basic_subtitle => 'Choose the supplier and describe the account payable.';

  @override
  String get accountsPayable_form_section_document_title => 'Fiscal document';

  @override
  String get accountsPayable_form_section_document_subtitle => 'Provide the fiscal document associated with the payment.';

  @override
  String get accountsPayable_form_section_tax_title => 'Invoice taxation';

  @override
  String get accountsPayable_form_section_tax_subtitle => 'Classify the invoice and enter the highlighted taxes.';

  @override
  String get accountsPayable_form_section_payment_title => 'Payment configuration';

  @override
  String get accountsPayable_form_section_payment_subtitle => 'Define how this account will be settled and review the installments schedule.';

  @override
  String get accountsPayable_form_field_supplier => 'Supplier';

  @override
  String get accountsPayable_form_field_description => 'Description';

  @override
  String get accountsPayable_form_field_document_type => 'Document type';

  @override
  String get accountsPayable_form_field_document_number => 'Document number';

  @override
  String get accountsPayable_form_field_document_date => 'Document date';

  @override
  String get accountsPayable_form_field_tax_exempt_switch => 'Invoice exempt from taxes';

  @override
  String get accountsPayable_form_field_tax_exemption_reason => 'Exemption reason';

  @override
  String get accountsPayable_form_field_tax_observation => 'Observations';

  @override
  String get accountsPayable_form_field_tax_cst => 'CST code';

  @override
  String get accountsPayable_form_field_tax_cfop => 'CFOP';

  @override
  String get accountsPayable_form_section_payment_mode_help_cst => 'Quick help about CST';

  @override
  String get accountsPayable_form_section_payment_mode_help_cfop => 'Quick help about CFOP';

  @override
  String get accountsPayable_form_error_supplier_required => 'Supplier is required';

  @override
  String get accountsPayable_form_error_description_required => 'Description is required';

  @override
  String get accountsPayable_form_error_document_type_required => 'Select the document type';

  @override
  String get accountsPayable_form_error_document_number_required => 'Enter the document number';

  @override
  String get accountsPayable_form_error_document_date_required => 'Enter the document date';

  @override
  String get accountsPayable_form_error_total_amount_required => 'Enter an amount greater than zero';

  @override
  String get accountsPayable_form_error_single_due_date_required => 'Enter the due date';

  @override
  String get accountsPayable_form_error_installments_required => 'Generate or add at least one installment';

  @override
  String get accountsPayable_form_error_installments_contents => 'Fill in amount and due date for each installment';

  @override
  String get accountsPayable_form_error_automatic_installments_required => 'Enter the number of installments';

  @override
  String get accountsPayable_form_error_automatic_amount_required => 'Enter the amount per installment';

  @override
  String get accountsPayable_form_error_automatic_first_due_date_required => 'Enter the date of the first installment';

  @override
  String get accountsPayable_form_error_installments_count_mismatch => 'The number of generated installments must match the total informed';

  @override
  String get accountsPayable_form_error_taxes_required => 'Add withheld taxes when the invoice is not exempt';

  @override
  String get accountsPayable_form_error_taxes_invalid => 'Enter type, percentage and amount for each tax';

  @override
  String get accountsPayable_form_error_tax_exemption_reason_required => 'Enter the invoice exemption reason';

  @override
  String get accountsPayable_form_error_installments_add_one => 'Add at least one installment';

  @override
  String get accountsPayable_form_error_tax_exempt_must_not_have_taxes => 'Exempt invoices must not have withheld taxes';

  @override
  String get accountsPayable_form_error_tax_status_mismatch => 'Update the tax status according to the highlighted taxes';

  @override
  String get accountsPayable_form_installments_single_empty_message => 'Enter the amount and due date to see the summary.';

  @override
  String get accountsPayable_form_installments_automatic_empty_message => 'Enter the data and click \"Generate installments\" to see the schedule.';

  @override
  String get accountsPayable_form_field_total_amount => 'Total amount';

  @override
  String get accountsPayable_form_field_single_due_date => 'Due date';

  @override
  String get accountsPayable_form_field_automatic_installments => 'Number of installments';

  @override
  String get accountsPayable_form_field_automatic_amount => 'Amount per installment';

  @override
  String get accountsPayable_form_field_automatic_first_due_date => 'First installment date';

  @override
  String get accountsPayable_form_generate_installments => 'Generate installments';

  @override
  String get accountsPayable_form_error_generate_installments_fill_data => 'Fill in the data to generate the installments.';

  @override
  String get accountsPayable_form_toast_generate_installments_success => 'Installments generated successfully.';

  @override
  String get accountsPayable_form_installments_summary_title => 'Installments summary';

  @override
  String accountsPayable_form_installment_item_title(int index) {
    return 'Installment $index';
  }

  @override
  String accountsPayable_form_installment_item_due_date(String date) {
    return 'Due date: $date';
  }

  @override
  String accountsPayable_form_installments_summary_total(String amount) {
    return 'Total: $amount';
  }

  @override
  String get accountsPayable_form_toast_saved_success => 'Account payable registered successfully';

  @override
  String get accountsPayable_form_toast_saved_error => 'Error while registering account payable';

  @override
  String get accountsPayable_form_save => 'Save';

  @override
  String get reports_income_download_pdf => 'Download PDF';

  @override
  String get reports_income_download_success => 'PDF downloaded successfully';

  @override
  String get reports_income_download_error => 'Could not download the PDF';

  @override
  String get reports_income_download_error_generic => 'Error while downloading the PDF';

  @override
  String get reports_income_statement_monthly_title => 'Monthly financial report';

  @override
  String get reports_income_summary_net_revenue_title => 'Net revenue';

  @override
  String get reports_income_summary_net_revenue_desc => 'Income from regular activities.';

  @override
  String get reports_income_summary_operating_expenses_title => 'Operating expenses';

  @override
  String get reports_income_summary_operating_expenses_desc => 'Costs required to keep the church running.';

  @override
  String get reports_income_summary_operating_income_title => 'Operating income';

  @override
  String get reports_income_summary_operating_income_desc => 'Revenue minus operating expenses.';

  @override
  String get reports_income_summary_net_income_title => 'Net result';

  @override
  String get reports_income_summary_net_income_desc => 'Final balance after extraordinary items.';

  @override
  String get reports_income_category_revenue_title => 'Revenue';

  @override
  String get reports_income_category_revenue_desc => 'Operating income and recurring donations.';

  @override
  String get reports_income_category_cogs_title => 'Direct costs';

  @override
  String get reports_income_category_cogs_desc => 'Direct costs to deliver services or projects.';

  @override
  String get reports_income_category_opex_title => 'Operating expenses';

  @override
  String get reports_income_category_opex_desc => 'Expenses needed to keep the church active.';

  @override
  String get reports_income_category_capex_title => 'Capital investments';

  @override
  String get reports_income_category_capex_desc => 'Long-term capital investments and spending.';

  @override
  String get reports_income_category_other_title => 'Other income/expenses';

  @override
  String get reports_income_category_other_desc => 'Extraordinary income or expenses.';

  @override
  String get reports_income_category_ministry_transfers_title => 'Ministry transfers and contributions';

  @override
  String get reports_income_category_ministry_transfers_desc => 'Transfers to ministries or leadership departments.';

  @override
  String get reports_income_category_unknown_title => 'Category';

  @override
  String get reports_income_category_help_revenue_body => 'This shows money the church received during the period, such as tithes, offerings, and donations.\n\nIn simple terms: money coming in.\n\nExample: monthly member contributions.';

  @override
  String get reports_income_category_help_cogs_body => 'These are costs directly tied to a specific activity, project, or event.\n\nIn simple terms: without this expense, that activity cannot happen.\n\nExample: buying materials for a social outreach event.';

  @override
  String get reports_income_category_help_opex_body => 'These are day-to-day costs required to run the church.\n\nIn simple terms: regular operating costs.\n\nExample: utilities, internet, cleaning, and administrative team costs.';

  @override
  String get reports_income_category_help_ministry_transfers_body => 'These are amounts allocated to ministries, departments, or internal work areas.\n\nIn simple terms: money going out to support internal ministry work.\n\nExample: monthly allocation to children ministry or music ministry.';

  @override
  String get reports_income_category_help_capex_body => 'These are expenses to buy or improve long-term assets.\n\nIn simple terms: long-term investment, not routine day-to-day spending.\n\nExample: renovation, projector purchase, or sound system upgrade.';

  @override
  String get reports_income_category_help_other_body => 'This includes occasional movements outside the main routine that do not fit other categories.\n\nIn simple terms: one-off cases.\n\nExample: sale of old equipment or an insurance reimbursement.';

  @override
  String get reports_income_category_help_unknown_body => 'This line represents a transaction without detailed category classification.\n\nIn simple terms: there is financial movement, but the exact category was not identified.';

  @override
  String get reports_dre_download_pdf => 'Download PDF';

  @override
  String get reports_dre_download_success => 'PDF downloaded successfully';

  @override
  String get reports_dre_download_error => 'Could not download the PDF';

  @override
  String get reports_dre_download_error_generic => 'Error while downloading the PDF';

  @override
  String get reports_income_breakdown_title => 'Income and expenses by category';

  @override
  String get reports_income_breakdown_empty => 'No income and expense data for the selected period.';

  @override
  String get reports_income_breakdown_header_category => 'Category';

  @override
  String get reports_income_breakdown_header_income => 'Income';

  @override
  String get reports_income_breakdown_header_expenses => 'Expenses';

  @override
  String get reports_income_breakdown_header_balance => 'Balance';

  @override
  String get reports_income_view_mode_cards => 'Cards';

  @override
  String get reports_income_view_mode_table => 'Table';

  @override
  String reports_income_currency_badge(String symbols, String count) {
    return 'Currencies: $symbols ($count)';
  }

  @override
  String get reports_income_multi_currency_disclaimer => 'Values are shown by currency. Totals are not summed across currencies.';

  @override
  String get reports_income_empty_selected_period => 'No data for the selected period.';

  @override
  String get reports_income_cashflow_title => 'Cash flow by availability account';

  @override
  String reports_income_cashflow_summary(String income, String expenses, String total) {
    return 'Total income: $income | Total expenses: $expenses | Consolidated balance: $total';
  }

  @override
  String get reports_income_cashflow_empty => 'No availability account movements in this period.';

  @override
  String get reports_income_cashflow_header_account => 'Account';

  @override
  String get reports_income_cashflow_header_income => 'Income';

  @override
  String get reports_income_cashflow_header_expenses => 'Expenses';

  @override
  String get reports_income_cashflow_header_balance => 'Period balance';

  @override
  String get reports_income_cost_centers_title => 'Cost center usage';

  @override
  String reports_income_cost_centers_total_applied(String total) {
    return 'Total applied: $total';
  }

  @override
  String get reports_income_cost_centers_empty => 'No cost centers with movements in this period.';

  @override
  String get reports_income_cost_centers_header_name => 'Cost center';

  @override
  String get reports_income_cost_centers_header_total => 'Total applied';

  @override
  String get reports_income_cost_centers_header_last_move => 'Last movement';

  @override
  String get trends_header_title => 'Composition of income, expenses and result';

  @override
  String trends_header_comparison(String currentMonthYear, String previousMonthYear) {
    return 'Comparison: $currentMonthYear vs $previousMonthYear';
  }

  @override
  String get trends_list_revenue => 'Revenue';

  @override
  String get trends_list_opex => 'Operating expenses';

  @override
  String get trends_list_transfers => 'Ministry transfers';

  @override
  String get trends_list_capex => 'Investments';

  @override
  String get trends_list_net_income => 'Net result';

  @override
  String get trends_summary_revenue => 'Revenue';

  @override
  String get trends_summary_opex => 'Operating';

  @override
  String get trends_summary_transfers => 'Transfers';

  @override
  String get trends_summary_capex => 'Investments';

  @override
  String get trends_summary_net_income => 'Result';

  @override
  String get reports_dre_screen_title => 'DRE - Statement of Income for the Year';

  @override
  String get reports_dre_header_title => 'Statement of Income for the Year';

  @override
  String get reports_dre_header_subtitle => 'Understand how your church received and used resources in the period';

  @override
  String get reports_dre_footer_note => 'Note: This report considers only confirmed and reconciled entries that affect the accounting result.';

  @override
  String get reports_dre_summary_by_currency_title => 'Summary by currency';

  @override
  String get reports_dre_primary_currency_badge => 'Primary currency';

  @override
  String reports_dre_summary_chip_gross_revenue(String value) {
    return 'Gross revenue: $value';
  }

  @override
  String reports_dre_summary_chip_net_result(String value) {
    return 'Net result: $value';
  }

  @override
  String reports_dre_section_title_by_symbol(String symbol) {
    return '$symbol - Period indicators';
  }

  @override
  String get reports_dre_section_subtitle => 'Summary of the result in this currency.';

  @override
  String get reports_dre_main_indicators_title => 'Key indicators';

  @override
  String get reports_dre_card_gross_revenue_title => 'Gross revenue';

  @override
  String get reports_dre_card_gross_revenue_description => 'Total tithes, offerings and donations received';

  @override
  String get reports_dre_card_operational_result_title => 'Operating result';

  @override
  String get reports_dre_card_operational_result_description => 'Gross result minus operating expenses';

  @override
  String get reports_dre_card_net_result_title => 'Net result';

  @override
  String get reports_dre_card_net_result_description => 'Final result for the period (surplus or deficit)';

  @override
  String get reports_dre_detail_section_title => 'Detail';

  @override
  String get reports_dre_detail_by_category => 'Detail by category';

  @override
  String get reports_dre_toggle_hide_zero => 'Hide zero-value rows';

  @override
  String get reports_dre_group_revenue => 'Revenue';

  @override
  String get reports_dre_group_costs => 'Costs';

  @override
  String get reports_dre_group_results => 'Result';

  @override
  String get reports_dre_item_net_revenue_title => 'Net revenue';

  @override
  String get reports_dre_item_net_revenue_description => 'Gross revenue minus returns and adjustments';

  @override
  String get reports_dre_item_direct_costs_title => 'Direct costs';

  @override
  String get reports_dre_item_direct_costs_description => 'Event costs, materials and specific activities';

  @override
  String get reports_dre_item_gross_profit_title => 'Gross profit';

  @override
  String get reports_dre_item_gross_profit_description => 'Net revenue minus direct costs';

  @override
  String get reports_dre_item_operational_expenses_title => 'Operating expenses';

  @override
  String get reports_dre_item_operational_expenses_description => 'Day-to-day expenses: electricity, water, salaries, cleaning';

  @override
  String get reports_dre_item_ministry_transfers_title => 'Ministry transfers';

  @override
  String get reports_dre_item_ministry_transfers_description => 'Transfers to ministries, missions or to the board';

  @override
  String get reports_dre_item_capex_title => 'CAPEX investments';

  @override
  String get reports_dre_item_capex_description => 'Acquisition or improvement of assets and infrastructure';

  @override
  String get reports_dre_item_extraordinary_title => 'Extraordinary results';

  @override
  String get reports_dre_item_extraordinary_description => 'Occasional income or expenses outside the routine';

  @override
  String reports_dre_help_dialog_title(String title) {
    return 'Help: $title';
  }

  @override
  String get reports_dre_help_what_means => 'What does it mean?';

  @override
  String get reports_dre_help_example => 'Example';

  @override
  String get reports_dre_help_understood => 'Understood';

  @override
  String get reports_dre_help_gross_revenue_meaning => 'Total incoming resources in the period, such as tithes, offerings, and donations.';

  @override
  String get reports_dre_help_gross_revenue_example => 'If the church received 5,000 this month, this line shows 5,000.';

  @override
  String get reports_dre_help_net_revenue_meaning => 'Gross revenue after returns and adjustments. In many cases it matches gross revenue.';

  @override
  String get reports_dre_help_net_revenue_example => 'Without returns, net revenue = gross revenue.';

  @override
  String get reports_dre_help_direct_costs_meaning => 'Costs directly tied to specific activities or projects.';

  @override
  String get reports_dre_help_direct_costs_example => 'Buying materials for a social outreach event.';

  @override
  String get reports_dre_help_gross_profit_meaning => 'Amount left after subtracting direct costs from net revenue.';

  @override
  String get reports_dre_help_gross_profit_example => 'Net revenue 10,000 and direct costs 2,000 result in 8,000.';

  @override
  String get reports_dre_help_operational_expenses_meaning => 'Day-to-day costs needed to keep church operations running.';

  @override
  String get reports_dre_help_operational_expenses_example => 'Utilities, cleaning, and administrative team costs.';

  @override
  String get reports_dre_help_ministry_transfers_meaning => 'Amounts transferred to ministries, missions, or specific fronts.';

  @override
  String get reports_dre_help_ministry_transfers_example => 'Monthly allocation to children or music ministry.';

  @override
  String get reports_dre_help_capex_meaning => 'Investments in long-term assets and infrastructure.';

  @override
  String get reports_dre_help_capex_example => 'Buying audio equipment or structural renovation.';

  @override
  String get reports_dre_help_extraordinary_meaning => 'Income or expenses outside normal routine.';

  @override
  String get reports_dre_help_extraordinary_example => 'Sale of old equipment or a reimbursement.';

  @override
  String get reports_dre_help_operational_result_meaning => 'Result from normal operations after direct costs, operating expenses, and transfers.';

  @override
  String get reports_dre_help_operational_result_example => 'Shows whether operations closed with surplus or deficit.';

  @override
  String get reports_dre_help_net_result_meaning => 'Final result for the period after all DRE components.';

  @override
  String get reports_dre_help_net_result_example => 'Positive means surplus; negative means deficit.';

  @override
  String reports_dre_currency_badge(String symbols, String count) {
    return 'Currencies: $symbols ($count)';
  }

  @override
  String get reports_dre_multi_currency_disclaimer => 'Values are shown per currency. Totals are not summed across currencies.';

  @override
  String get reports_dre_empty_selected_period => 'No data for the selected period.';

  @override
  String get reports_monthly_tithes_title => 'Monthly tithes report';

  @override
  String get reports_monthly_tithes_empty => 'No monthly tithes to show';

  @override
  String get reports_monthly_tithes_header_date => 'Date';

  @override
  String get reports_monthly_tithes_header_amount => 'Amount';

  @override
  String get reports_monthly_tithes_header_account => 'Availability account';

  @override
  String get reports_monthly_tithes_header_account_type => 'Account type';

  @override
  String get reports_monthly_tithes_total_title => 'Tithes total';

  @override
  String get reports_monthly_tithes_section_title => 'Monthly tithes report';

  @override
  String reports_monthly_tithes_currency_badge(String symbols, String count) {
    return 'Currencies: $symbols ($count)';
  }

  @override
  String get reports_monthly_tithes_multi_currency_disclaimer => 'Values are shown per currency. Totals are not summed across currencies.';

  @override
  String get reports_monthly_tithes_empty_selected_period => 'No data for the selected period.';

  @override
  String get reports_monthly_tithes_tithes_of_tithes => 'Tithes of tithes';

  @override
  String get finance_records_filter_concept_type => 'Concept type';

  @override
  String get finance_records_filter_concept => 'Concept';

  @override
  String get finance_records_filter_availability_account => 'Availability account';

  @override
  String get finance_records_table_empty => 'No financial records to show';

  @override
  String get finance_records_table_header_date => 'Date';

  @override
  String get finance_records_table_header_amount => 'Amount';

  @override
  String get finance_records_table_header_type => 'Movement type';

  @override
  String get finance_records_table_header_concept => 'Concept';

  @override
  String get finance_records_table_header_availability_account => 'Availability account';

  @override
  String get finance_records_table_header_status => 'Status';

  @override
  String get finance_records_table_action_void => 'Void';

  @override
  String get finance_records_table_confirm_void => 'Do you want to void this financial movement?';

  @override
  String get finance_records_table_modal_title => 'Financial movement';

  @override
  String get finance_records_form_title => 'Financial record';

  @override
  String get finance_records_form_field_description => 'Description';

  @override
  String get finance_records_form_field_date => 'Date';

  @override
  String get finance_records_form_field_receipt => 'Bank movement receipt';

  @override
  String get finance_records_form_field_cost_center => 'Cost center';

  @override
  String get finance_records_form_save => 'Save';

  @override
  String get finance_records_form_toast_purchase_in_construction => 'Purchase records are under construction';

  @override
  String get finance_records_form_toast_saved_success => 'Record saved successfully';

  @override
  String get common_view => 'View';

  @override
  String get contributions_status_processed => 'Processed';

  @override
  String get contributions_status_pending_verification => 'Pending verification';

  @override
  String get contributions_status_rejected => 'Rejected';

  @override
  String get contributions_list_title => 'Contributions list';

  @override
  String get contributions_list_new => 'Register contribution';

  @override
  String get contributions_table_empty => 'No contributions found';

  @override
  String get contributions_table_header_member => 'Name';

  @override
  String get contributions_table_header_amount => 'Amount';

  @override
  String get contributions_table_header_type => 'Contribution type';

  @override
  String get contributions_table_header_status => 'Status';

  @override
  String get contributions_table_header_date => 'Date';

  @override
  String contributions_table_modal_title(String id) {
    return 'Contribution #$id';
  }

  @override
  String get contributions_view_field_amount => 'Amount';

  @override
  String get contributions_view_field_status => 'Status';

  @override
  String get contributions_view_field_date => 'Date';

  @override
  String get contributions_view_field_account => 'Account';

  @override
  String get contributions_view_section_member => 'Member';

  @override
  String get contributions_view_section_financial_concept => 'Financial concept';

  @override
  String get contributions_view_section_receipt => 'Transfer receipt';

  @override
  String get contributions_view_action_approve => 'Approve';

  @override
  String get contributions_view_action_reject => 'Reject';

  @override
  String get accountsReceivable_form_section_payment_title => 'Payment configuration';

  @override
  String get accountsReceivable_form_section_payment_subtitle => 'Define how this receivable will be charged and review the installments schedule.';

  @override
  String get accountsReceivable_form_field_type => 'Account type';

  @override
  String get accountsReceivable_type_help_title => 'How to classify the account type';

  @override
  String get accountsReceivable_type_help_intro => 'Choose the type that best describes the origin of the receivable amount.';

  @override
  String get accountsReceivable_type_contribution_title => 'Contribution';

  @override
  String get accountsReceivable_type_contribution_description => 'Voluntary commitments made by members or groups.';

  @override
  String get accountsReceivable_type_contribution_example => 'E.g.: missions campaigns, recurring offerings, special donations.';

  @override
  String get accountsReceivable_type_service_title => 'Service';

  @override
  String get accountsReceivable_type_service_description => 'Charges for activities or services provided by the church.';

  @override
  String get accountsReceivable_type_service_example => 'E.g.: music courses, conferences, event catering rental.';

  @override
  String get accountsReceivable_type_interinstitutional_title => 'Interinstitutional';

  @override
  String get accountsReceivable_type_interinstitutional_description => 'Amounts arising from partnerships with other institutions.';

  @override
  String get accountsReceivable_type_interinstitutional_example => 'E.g.: support for joint events, agreements with another church.';

  @override
  String get accountsReceivable_type_rental_title => 'Rental';

  @override
  String get accountsReceivable_type_rental_description => 'Paid use of spaces, vehicles or equipment.';

  @override
  String get accountsReceivable_type_rental_example => 'E.g.: auditorium rental, instruments or chair rental.';

  @override
  String get accountsReceivable_type_loan_title => 'Loan';

  @override
  String get accountsReceivable_type_loan_description => 'Resources granted by the church that must be repaid.';

  @override
  String get accountsReceivable_type_loan_example => 'E.g.: advances to ministries, temporary financial support.';

  @override
  String get accountsReceivable_type_financial_title => 'Financial';

  @override
  String get accountsReceivable_type_financial_description => 'Bank movements that are still pending settlement.';

  @override
  String get accountsReceivable_type_financial_example => 'E.g.: checks in process, card acquiring, refunds.';

  @override
  String get accountsReceivable_type_legal_title => 'Legal';

  @override
  String get accountsReceivable_type_legal_description => 'Charges related to legal actions, insurance or indemnities.';

  @override
  String get accountsReceivable_type_legal_example => 'E.g.: enforcement of judgment, claims covered by insurer.';

  @override
  String get common_see_all => 'See all';

  @override
  String get member_home_placeholder => 'Member experience';

  @override
  String get member_home_generosity_title => 'My generosity journey';

  @override
  String get member_home_generosity_year_label => 'Contributed this year';

  @override
  String get member_home_generosity_month_label => 'Contributed this month';

  @override
  String get member_home_generosity_commitments_label => 'Commitments in progress';

  @override
  String get member_home_generosity_commitments_hint => 'Tap to view details';

  @override
  String get member_home_upcoming_events_title => 'Upcoming events';

  @override
  String get member_home_upcoming_events_empty => 'No upcoming events in the next few days.';

  @override
  String get member_schedule_detail_information_title => 'Information';

  @override
  String get member_schedule_detail_details_title => 'Details';

  @override
  String get member_schedule_detail_optional_label => '(optional)';

  @override
  String get member_schedule_detail_no_extra_info => 'No additional details available.';

  @override
  String get member_contribution_history_title => 'Contribution history';

  @override
  String get member_contribution_new_button => 'New contribution';

  @override
  String get member_contribution_filter_type_label => 'Type';

  @override
  String get member_contribution_filter_type_all => 'All';

  @override
  String get member_contribution_type_tithe => 'Tithe';

  @override
  String get member_contribution_type_offering => 'Offering';

  @override
  String get member_contribution_destination_label => 'Contribution destination';

  @override
  String get member_contribution_search_account_hint => 'Search account...';

  @override
  String get member_contribution_offering_concept_label => 'Offering';

  @override
  String get member_contribution_search_concept_hint => 'Search concept...';

  @override
  String get member_contribution_value_label => 'Contribution amount';

  @override
  String get member_contribution_amount_other => 'Other amount';

  @override
  String get member_contribution_receipt_label => 'Upload the payment receipt';

  @override
  String get member_contribution_receipt_payment_date_label => 'Payment date';

  @override
  String get member_contribution_receipt_help_text => 'Your church treasury will review this receipt. Attaching it is mandatory.';

  @override
  String get member_contribution_message_label => 'Message (optional)';

  @override
  String get member_contribution_continue_button => 'Continue';

  @override
  String get member_contribution_payment_method_question => 'How do you want to record the payment?';

  @override
  String get member_contribution_payment_method_boleto_title => 'Generate a boleto to pay later';

  @override
  String get member_contribution_payment_method_manual_title => 'I already contributed, I want to upload the receipt';

  @override
  String get member_contribution_payment_method_pix_description => 'Pay now via PIX. Generate the QR code or copy-and-paste code to pay in your banking app.';

  @override
  String get member_contribution_payment_method_boleto_description => 'Generate a boleto to pay later through online banking or your app.';

  @override
  String get member_contribution_payment_method_manual_description => 'Deposit, transfer, or use another method, then upload the receipt here.';

  @override
  String get member_contribution_history_empty_title => 'You do not have any contributions yet';

  @override
  String get member_contribution_history_empty_subtitle => 'Once you make a contribution, it will appear here.';

  @override
  String get member_contribution_history_item_default_title => 'Contribution';

  @override
  String get member_contribution_history_item_receipt_submitted => 'Receipt submitted';

  @override
  String get member_contribution_pix_title => 'Pay with PIX';

  @override
  String member_contribution_pix_recipient(String recipient) {
    return 'Recipient: $recipient';
  }

  @override
  String get member_contribution_pix_qr_hint => 'Scan this QR code in your banking app.';

  @override
  String get member_contribution_pix_code_label => 'PIX copy and paste code';

  @override
  String get member_contribution_copy_code => 'Copy code';

  @override
  String get member_contribution_pix_footer => 'After paying, you can track the confirmation in your contribution history.';

  @override
  String get member_contribution_back_to_home => 'Back to home';

  @override
  String get member_contribution_pix_copy_success => 'PIX code copied!';

  @override
  String get member_contribution_boleto_title => 'Pay with boleto';

  @override
  String get member_contribution_boleto_due_date_label => 'Due date:';

  @override
  String get member_contribution_boleto_instruction => 'Use the code below to pay in your online banking or app.';

  @override
  String get member_contribution_boleto_line_label => 'Digitable line';

  @override
  String get member_contribution_boleto_download_pdf => 'Download boleto PDF';

  @override
  String get member_contribution_boleto_footer => 'After paying, the confirmation will appear in your contribution history. Keep the receipt.';

  @override
  String get member_contribution_boleto_copy_success => 'Digitable line copied!';

  @override
  String get member_contribution_boleto_pdf_error => 'Could not open the PDF';

  @override
  String get member_contribution_result_success_title => 'Contribution completed\nsuccessfully!';

  @override
  String get member_contribution_result_success_subtitle => 'Thank you for your generosity.';

  @override
  String member_contribution_result_date(String date) {
    return 'Date: $date';
  }

  @override
  String get member_contribution_result_info => 'The treasury team will review your receipt.';

  @override
  String get member_contribution_view_history => 'View history';

  @override
  String get member_contribution_result_error_title => 'We could not process\nthe payment';

  @override
  String get member_contribution_result_error_message => 'Check the payment details or try another method.';

  @override
  String get member_contribution_try_again => 'Try again';

  @override
  String get member_contribution_form_required_fields_error => 'Please fill in all required fields';

  @override
  String get member_contribution_form_receipt_required_error => 'The receipt is required.';

  @override
  String member_contribution_form_submission_error(String error) {
    return 'Error processing the contribution: $error';
  }

  @override
  String get member_contribution_validator_amount_required => 'Enter the amount';

  @override
  String get member_contribution_validator_financial_concept_required => 'Select a financial concept';

  @override
  String get member_contribution_validator_account_required => 'Select the availability account';

  @override
  String get member_contribution_validator_month_required => 'Select a month';

  @override
  String get member_drawer_greeting => 'Example Member';

  @override
  String get member_drawer_view_profile => 'View my profile';

  @override
  String get member_drawer_notifications => 'Notifications';

  @override
  String get member_drawer_profile => 'My profile';

  @override
  String get member_drawer_settings => 'Settings';

  @override
  String get member_drawer_legal_section => 'Legal';

  @override
  String get member_drawer_privacy_policy => 'Privacy Policy';

  @override
  String get member_drawer_sensitive_data => 'Sensitive Data Policy';

  @override
  String get member_drawer_terms => 'Terms of Use';

  @override
  String get member_drawer_logout => 'Log out';

  @override
  String member_drawer_version(String version) {
    return 'Version $version';
  }

  @override
  String get member_shell_nav_home => 'Home';

  @override
  String get member_shell_nav_contribute => 'Contribute';

  @override
  String get member_shell_nav_commitments => 'Commitments';

  @override
  String get member_shell_nav_statements => 'Statements';

  @override
  String get member_shell_header_tagline => 'CHURCH';

  @override
  String get member_shell_header_default_church => 'Gloria Finance';

  @override
  String get member_commitments_title => 'My commitments';

  @override
  String get member_commitments_empty_title => 'You don\'t have contribution commitments yet';

  @override
  String get member_commitments_empty_subtitle => 'When the treasury assigns one to you, it will appear here.';

  @override
  String get member_commitments_total_label => 'Total amount';

  @override
  String get member_commitments_paid_label => 'Already contributed';

  @override
  String get member_commitments_balance_label => 'Balance';

  @override
  String get member_commitments_progress_label => 'Completed';

  @override
  String get member_commitments_button_view_details => 'View details & pay';

  @override
  String get member_commitments_status_pending => 'In progress';

  @override
  String get member_commitments_status_paid => 'Completed';

  @override
  String get member_commitments_status_pending_acceptance => 'Pending acceptance';

  @override
  String get member_commitments_status_denied => 'Denied';

  @override
  String get member_commitments_detail_title => 'Commitment details';

  @override
  String get member_commitments_detail_subtitle => 'Track your progress and choose how to pay your installments.';

  @override
  String get member_commitments_detail_next_installment => 'Next installment';

  @override
  String get member_profile_personal_data_title => 'Personal data';

  @override
  String get member_profile_security_title => 'Security';

  @override
  String get member_profile_notifications_title => 'Notifications';

  @override
  String get member_profile_full_name_label => 'Full name';

  @override
  String get member_profile_email_label => 'Email';

  @override
  String get member_profile_phone_label => 'Phone';

  @override
  String get member_profile_dni_label => 'ID/Tax ID';

  @override
  String member_profile_member_since(String date) {
    return 'Member since $date';
  }

  @override
  String get member_profile_change_password_title => 'Change password';

  @override
  String get member_profile_change_password_subtitle => 'Update your access password';

  @override
  String get member_profile_notifications_settings_title => 'Notification settings';

  @override
  String get member_profile_notifications_settings_subtitle => 'Choose how you want to be notified by the church';

  @override
  String get member_change_password_header_title => 'Keep your account safe';

  @override
  String get member_change_password_header_subtitle => 'Use a strong password and do not share your access data.';

  @override
  String get member_change_password_current_label => 'Current password';

  @override
  String get member_change_password_new_label => 'New password';

  @override
  String get member_change_password_confirm_label => 'Confirm new password';

  @override
  String get member_change_password_rule_length => 'At least 8 characters';

  @override
  String get member_change_password_rule_uppercase => '1 uppercase letter';

  @override
  String get member_change_password_rule_number => '1 number';

  @override
  String get member_change_password_error_current => 'Incorrect current password.';

  @override
  String get member_change_password_error_match => 'Passwords do not match.';

  @override
  String get member_change_password_success_title => 'Success!';

  @override
  String get member_change_password_success_message => 'Your password has been changed successfully.';

  @override
  String get member_change_password_btn_save => 'Save new password';

  @override
  String get member_change_password_btn_cancel => 'Cancel';

  @override
  String get member_change_password_btn_back => 'Back to profile';

  @override
  String get member_commitments_installments_section_title => 'Installments';

  @override
  String get member_commitments_payment_modal_title => 'Register payment';

  @override
  String get member_commitments_payment_title => 'Register payment';

  @override
  String get member_commitments_payment_installment_label => 'Installment';

  @override
  String get member_commitments_payment_account_label => 'Availability account';

  @override
  String get member_commitments_payment_amount_label => 'Amount paid';

  @override
  String get member_commitments_payment_paid_at_label => 'Payment date';

  @override
  String get member_commitments_payment_voucher_label => 'Payment receipt';

  @override
  String get member_commitments_payment_observation_label => 'Note (optional)';

  @override
  String get member_commitments_payment_submit => 'Send receipt';

  @override
  String get member_commitments_payment_success => 'Payment registered! The treasury will review the receipt.';

  @override
  String get member_commitments_payment_required_fields_error => 'Select the installment, enter amount/date, and attach the receipt.';

  @override
  String get member_commitments_payment_methods_title => 'How do you want to pay?';

  @override
  String get member_commitments_payment_methods_pix => 'Pay with PIX';

  @override
  String get member_commitments_payment_methods_boleto => 'Generate boleto';

  @override
  String get member_commitments_payment_methods_manual => 'I already paid, send receipt';

  @override
  String get member_commitments_payment_methods_manual_hint => 'Use this option when you transferred and must send the receipt.';

  @override
  String member_commitments_installment_paid_on(String date) {
    return 'Paid on: $date';
  }

  @override
  String get member_commitments_installment_status_paid => 'Paid';

  @override
  String get member_commitments_installment_status_pending => 'Pending';

  @override
  String get member_commitments_installment_status_in_review => 'Under review';

  @override
  String get member_commitments_installment_status_partial => 'Partial payment';

  @override
  String get member_commitments_installment_status_overdue => 'Overdue';

  @override
  String get member_commitments_action_pay_installment => 'Pay installment';

  @override
  String get member_commitments_action_pay_this_installment => 'Pay this installment';

  @override
  String get member_commitments_payment_missing_account => 'Availability account not informed. Please contact your church.';

  @override
  String get member_register_name_label => 'Full name';

  @override
  String get member_register_email_label => 'Email';

  @override
  String get member_register_phone_label => 'Phone';

  @override
  String get member_register_dni_label => 'Identity Document';

  @override
  String get member_register_conversion_date_label => 'Conversion date';

  @override
  String get member_register_baptism_date_label => 'Baptism date';

  @override
  String get member_register_birthdate_label => 'Birthdate';

  @override
  String get member_register_active_label => 'Active?';

  @override
  String get member_register_yes => 'Yes';

  @override
  String get member_register_no => 'No';

  @override
  String get validation_required => 'Required field';

  @override
  String get validation_invalid_email => 'Invalid email';

  @override
  String get validation_invalid_phone => 'Invalid phone format';

  @override
  String get validation_invalid_cpf => 'Invalid ID document';

  @override
  String get member_list_title => 'Member list';

  @override
  String get member_list_action_register => 'Register new member';

  @override
  String get member_list_empty => 'No members registered.';

  @override
  String get member_list_header_name => 'Name';

  @override
  String get member_list_header_email => 'Email';

  @override
  String get member_list_header_phone => 'Phone';

  @override
  String get member_list_header_birthdate => 'Birthdate';

  @override
  String get member_list_header_active => 'Active?';

  @override
  String get member_list_action_edit => 'Edit';

  @override
  String get member_list_status_yes => 'Yes';

  @override
  String get member_list_status_no => 'No';

  @override
  String get trends_main_card_revenue_title => 'Gross Revenue';

  @override
  String get trends_main_card_revenue_subtitle => 'REVENUE';

  @override
  String get trends_main_card_opex_title => 'Operating Expenses';

  @override
  String get trends_main_card_opex_subtitle => 'EXPENSES';

  @override
  String get trends_main_card_net_income_title => 'Period Result';

  @override
  String get trends_main_card_net_income_subtitle => 'RESULT';

  @override
  String get member_settings_title => 'Settings';

  @override
  String get member_settings_subtitle => 'Personalize your experience at Glória Finance - Members.';

  @override
  String get member_settings_language_title => 'Interface Language';

  @override
  String get member_settings_language_description => 'Choose the language you prefer to use in the app.';

  @override
  String get member_settings_language_default_tag => 'Default';

  @override
  String get member_settings_notifications_title => 'Notifications';

  @override
  String get member_settings_notifications_description => 'Choose what you want to receive as alerts.';

  @override
  String get member_settings_notification_church_events_title => 'New Church Events';

  @override
  String get member_settings_notification_church_events_desc => 'Receive reminders for services, conferences, and special activities.';

  @override
  String get member_settings_notification_payments_title => 'Payment Commitments';

  @override
  String get member_settings_notification_payments_desc => 'Alerts about installments and due dates of your commitments.';

  @override
  String get member_settings_notification_contributions_status_title => 'Contribution Status';

  @override
  String get member_settings_notification_contributions_status_desc => 'Notifications when a tithe or offering changes status (registered, confirmed, etc.).';

  @override
  String get member_settings_footer_coming_soon => 'Coming soon: more options to personalize your experience.';

  @override
  String get schedule_type_service => 'Service';

  @override
  String get schedule_type_cell => 'Cell';

  @override
  String get schedule_type_ministry_meeting => 'Ministry meeting';

  @override
  String get schedule_type_regular_event => 'Regular event';

  @override
  String get schedule_type_other => 'Other';

  @override
  String get schedule_visibility_public => 'Public';

  @override
  String get schedule_visibility_internal_leaders => 'Leaders only';

  @override
  String get schedule_day_sunday => 'Sunday';

  @override
  String get schedule_day_monday => 'Monday';

  @override
  String get schedule_day_tuesday => 'Tuesday';

  @override
  String get schedule_day_wednesday => 'Wednesday';

  @override
  String get schedule_day_thursday => 'Thursday';

  @override
  String get schedule_day_friday => 'Friday';

  @override
  String get schedule_day_saturday => 'Saturday';

  @override
  String get schedule_list_title => 'Event schedule';

  @override
  String get schedule_list_new_button => 'New event';

  @override
  String get schedule_filters_title => 'Filters';

  @override
  String get schedule_filters_search => 'Search by title';

  @override
  String get schedule_filters_type => 'Event type';

  @override
  String get schedule_filters_visibility => 'Visibility';

  @override
  String get schedule_filters_status => 'Status';

  @override
  String get schedule_filters_clear => 'Clear filters';

  @override
  String get schedule_status_active => 'Active';

  @override
  String get schedule_status_inactive => 'Inactive';

  @override
  String get schedule_status_all => 'All';

  @override
  String get schedule_table_empty => 'No events found';

  @override
  String get schedule_table_header_title => 'Title';

  @override
  String get schedule_table_header_type => 'Type';

  @override
  String get schedule_table_header_day => 'Day';

  @override
  String get schedule_table_header_time => 'Time';

  @override
  String get schedule_table_header_location => 'Location';

  @override
  String get schedule_table_header_director => 'Leader';

  @override
  String get schedule_action_reactivate => 'Reactivate';

  @override
  String get schedule_action_deactivate => 'Deactivate';

  @override
  String get schedule_delete_confirm_title => 'Confirm deactivation';

  @override
  String get schedule_delete_confirm_message => 'Are you sure you want to deactivate this event?';

  @override
  String get schedule_reactivate_confirm_title => 'Confirm reactivation';

  @override
  String get schedule_reactivate_confirm_message => 'Are you sure you want to reactivate this event?';

  @override
  String get common_confirm => 'Confirm';

  @override
  String get schedule_detail_basic_info => 'Basic information';

  @override
  String get schedule_detail_title => 'Title';

  @override
  String get schedule_detail_type => 'Event type';

  @override
  String get schedule_detail_description => 'Description';

  @override
  String get schedule_detail_visibility => 'Visibility';

  @override
  String get schedule_detail_schedule_info => 'Schedule information';

  @override
  String get schedule_detail_day => 'Day of week';

  @override
  String get schedule_detail_time => 'Time';

  @override
  String get schedule_detail_duration => 'Duration';

  @override
  String get schedule_detail_minutes => 'minutes';

  @override
  String get schedule_detail_start_date => 'Start date';

  @override
  String get schedule_detail_end_date => 'End date';

  @override
  String get schedule_detail_location_info => 'Location';

  @override
  String get schedule_detail_location => 'Location name';

  @override
  String get schedule_detail_address => 'Address';

  @override
  String get schedule_detail_responsibility => 'Responsibilities';

  @override
  String get schedule_detail_director => 'Leader';

  @override
  String get schedule_detail_preacher => 'Preacher';

  @override
  String get schedule_detail_observations => 'Observations';

  @override
  String get schedule_detail_summary => 'Summary';

  @override
  String get schedule_detail_when => 'When';

  @override
  String get schedule_detail_timezone => 'Timezone';

  @override
  String get schedule_detail_start => 'Start';

  @override
  String get schedule_detail_end => 'End';

  @override
  String get schedule_detail_no_end_date => 'No end date';

  @override
  String get schedule_detail_created_at => 'Created on';

  @override
  String get schedule_form_title_new => 'New event';

  @override
  String get schedule_form_title_edit => 'Edit event';

  @override
  String get schedule_form_section_basic => 'Basic information';

  @override
  String get schedule_form_section_location => 'Location';

  @override
  String get schedule_form_section_recurrence => 'Recurrence';

  @override
  String get schedule_form_section_visibility => 'Visibility';

  @override
  String get schedule_form_section_responsibility => 'Responsible';

  @override
  String get schedule_form_field_type => 'Event type';

  @override
  String get schedule_form_field_title => 'Title';

  @override
  String get schedule_form_field_description => 'Description (optional)';

  @override
  String get schedule_form_field_location_name => 'Location';

  @override
  String get schedule_form_field_location_address => 'Address (optional)';

  @override
  String get schedule_form_field_day_of_week => 'Day of week';

  @override
  String get schedule_form_field_time => 'Time';

  @override
  String get schedule_form_field_duration => 'Duration (minutes)';

  @override
  String get schedule_form_field_start_date => 'Start date';

  @override
  String get schedule_form_field_has_end_date => 'Set end date';

  @override
  String get schedule_form_field_end_date => 'End date';

  @override
  String get schedule_form_field_visibility => 'Who can see';

  @override
  String get schedule_form_field_director => 'Leader';

  @override
  String get schedule_form_field_preacher => 'Preacher (optional)';

  @override
  String get schedule_form_field_observations => 'Observations (optional)';

  @override
  String get schedule_form_save => 'Save';

  @override
  String get schedule_form_cancel => 'Cancel';

  @override
  String get schedule_form_title => 'Title';

  @override
  String get schedule_form_description => 'Description';

  @override
  String get schedule_form_type => 'Type';

  @override
  String get schedule_form_visibility => 'Visibility';

  @override
  String get schedule_form_start_time => 'Start time';

  @override
  String get schedule_form_end_time => 'End time';

  @override
  String get schedule_form_recurrence => 'Recurrence';

  @override
  String get schedule_form_weekly_recurrence => 'Weekly recurrence';

  @override
  String get schedule_day_abbr_sunday => 'Sun';

  @override
  String get schedule_day_abbr_monday => 'Mon';

  @override
  String get schedule_day_abbr_tuesday => 'Tue';

  @override
  String get schedule_day_abbr_wednesday => 'Wed';

  @override
  String get schedule_day_abbr_thursday => 'Thu';

  @override
  String get schedule_day_abbr_friday => 'Fri';

  @override
  String get schedule_day_abbr_saturday => 'Sat';

  @override
  String get schedule_form_is_active => 'Active';

  @override
  String get schedule_form_error_required => 'This field is required';

  @override
  String get schedule_form_error_type_required => 'Select a type';

  @override
  String get schedule_form_error_visibility_required => 'Select visibility';

  @override
  String get schedule_form_error_day_required => 'Select day of week';

  @override
  String get schedule_form_error_invalid_time => 'Invalid format. Use HH:MM';

  @override
  String get schedule_form_error_invalid_number => 'Enter a valid number';

  @override
  String get schedule_form_toast_saved => 'Event saved successfully!';

  @override
  String get schedule_form_error_title_required => 'Title is required';

  @override
  String get schedule_form_error_location_name_required => 'Location name is required';

  @override
  String get schedule_form_error_director_required => 'Leader is required';

  @override
  String get schedule_form_error_duration_invalid => 'Duration must be greater than zero';

  @override
  String get schedule_form_error_end_date_before_start => 'End date must be after start date';

  @override
  String get schedule_form_toast_saved_success => 'Event saved successfully!';

  @override
  String get schedule_form_toast_saved_error => 'Error saving event';

  @override
  String get schedule_recurrence_none => 'No recurrence';

  @override
  String get erp_menu_schedule => 'Schedule';

  @override
  String get erp_menu_schedule_events => 'Events and Schedule';

  @override
  String get schedule_duplicate_title => 'Duplicate event';

  @override
  String schedule_duplicate_subtitle(String originalTitle) {
    return 'Create a new event based on: $originalTitle';
  }

  @override
  String get schedule_duplicate_summary_title => 'Original event summary';

  @override
  String get schedule_duplicate_adjustments_title => 'Adjustments before creating';

  @override
  String get schedule_duplicate_open_edit => 'Open full edit after creating';

  @override
  String get schedule_duplicate_action_create => 'Create copy';

  @override
  String get schedule_duplicate_toast_success => 'Event duplicated successfully!';

  @override
  String get schedule_duplicate_toast_error => 'Error duplicating event';

  @override
  String get accountsPayable_help_cst_title => 'Tax Situation Code (CST)';

  @override
  String get accountsPayable_help_cst_description => 'CST shows how the tax applies to the operation.';

  @override
  String get accountsPayable_help_cst_00 => 'Full taxation (Normal ICMS)';

  @override
  String get accountsPayable_help_cst_10 => 'Taxed with ICMS by substitution';

  @override
  String get accountsPayable_help_cst_20 => 'With tax base reduction';

  @override
  String get accountsPayable_help_cst_40 => 'Exempt or non-taxed';

  @override
  String get accountsPayable_help_cst_60 => 'ICMS previously charged via ST';

  @override
  String get accountsPayable_help_cst_90 => 'Other specific situations';

  @override
  String get accountsPayable_help_cfop_title => 'Fiscal Operations Code (CFOP)';

  @override
  String get accountsPayable_help_cfop_description => 'CFOP describes the operation type (purchase, sale, service).';

  @override
  String get accountsPayable_help_cfop_digit_info => 'First digit indicates origin/destination:';

  @override
  String get accountsPayable_help_cfop_1xxx => 'In-state entries';

  @override
  String get accountsPayable_help_cfop_2xxx => 'Out-of-state entries';

  @override
  String get accountsPayable_help_cfop_5xxx => 'In-state exits';

  @override
  String get accountsPayable_help_cfop_6xxx => 'Out-of-state exits';

  @override
  String get accountsPayable_help_cfop_7xxx => 'International operations';

  @override
  String get accountsPayable_help_cfop_examples_title => 'Useful examples:';

  @override
  String get accountsPayable_help_cfop_1101 => 'Purchase for industrialization';

  @override
  String get accountsPayable_help_cfop_1556 => 'Purchase for internal use/consumption';

  @override
  String get accountsPayable_help_cfop_5405 => 'Sale subject to tax substitution';

  @override
  String get accountsPayable_help_cfop_6102 => 'Sale for commercialization out-of-state';

  @override
  String get common_understood => 'Understood';

  @override
  String get bankStatements_link_dialog_title => 'Link Financial Record';

  @override
  String get bankStatements_link_dialog_id_label => 'Financial Record ID';

  @override
  String get bankStatements_link_dialog_id_error => 'Please enter the record identifier.';

  @override
  String get bankStatements_link_dialog_suggestions_title => 'Automatic Suggestions';

  @override
  String get bankStatements_link_dialog_suggestions_error => 'Could not load suggestions. Please try again later.';

  @override
  String get bankStatements_link_dialog_suggestions_empty => 'No record matches the amount and date.';

  @override
  String get bankStatements_link_dialog_use_id => 'Use ID';

  @override
  String get bankStatements_link_dialog_no_concept => 'No concept';

  @override
  String get bankStatements_link_dialog_saving => 'Saving...';

  @override
  String get bankStatements_link_dialog_link_button => 'Link';

  @override
  String get bankStatements_link_dialog_link_error => 'Could not link. Check the provided identifier.';

  @override
  String get tax_form_title_add => 'Add Tax';

  @override
  String get tax_form_title_edit => 'Edit Tax';

  @override
  String get tax_form_type_label => 'Tax Type';

  @override
  String get tax_form_type_error => 'Enter tax type';

  @override
  String get tax_form_percentage_label => 'Percentage (%)';

  @override
  String get tax_form_percentage_error => 'Enter a valid percentage';

  @override
  String get tax_form_amount_label => 'Retained Value';

  @override
  String get tax_form_amount_error => 'Enter a value greater than zero';

  @override
  String get tax_form_status_label => 'Status';

  @override
  String get tax_form_status_taxed => 'Taxed';

  @override
  String get tax_form_status_substitution => 'Tax Substitution';

  @override
  String get tax_form_empty_list => 'No taxes added yet.';

  @override
  String get common_save => 'Save';
}
