// lib/store_manager.dart
import 'package:gloria_finance/core/layout/state/navigator_member_state.dart';
import 'package:gloria_finance/core/layout/state/sidebar_state.dart';
import 'package:gloria_finance/features/auth/pages/login/store/auth_session_store.dart';

import 'locale_store.dart';

import '../features/erp/settings/availability_accounts/pages/list_availability_accounts/store/availability_accounts_list_store.dart';
import '../features/erp/settings/banks/store/bank_store.dart';
import '../features/erp/settings/cost_center/store/cost_center_list_store.dart';
import '../features/erp/settings/financial_concept/store/financial_concept_store.dart';
import '../features/erp/settings/members/store/member_all_store.dart';
import '../features/member_experience/notifications/push_notification_manager.dart';
import '../features/erp/trends/store/trend_store.dart';

class StoreManager {
  static final StoreManager _instance = StoreManager._internal();

  factory StoreManager() => _instance;

  StoreManager._internal();

  final localeStore = LocaleStore();
  final pushNotificationManager = PushNotificationManager();
  late final authSessionStore = AuthSessionStore(
    localeStore: localeStore,
    pushNotificationManager: pushNotificationManager,
  );
  final financialConceptStore = FinancialConceptStore();
  final bankStore = BankStore();
  final navigatorMemberNotifier = NavigatorMemberNotifier();
  final availabilityAccountsListStore = AvailabilityAccountsListStore();
  final costCenterListStore = CostCenterListStore();
  final memberAllStore = MemberAllStore();
  final sidebarNotifier = SidebarNotifier();
  final trendStore = TrendStore();

  bool isMemberExperience = false;
}
