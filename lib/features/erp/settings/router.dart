import 'package:gloria_finance/core/theme/transition_custom.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'availability_accounts/pages/availability_accounts/availability_accounts_screen.dart';
import 'availability_accounts/pages/edit_availability_account/edit_availability_account_screen.dart';
import 'availability_accounts/pages/list_availability_accounts/availability_accounts_list_screen.dart';
import 'availability_accounts/models/availability_account_model.dart';
import 'banks/models/bank_model.dart';
import 'banks/pages/bank_form/bank_form_screen.dart';
import 'banks/pages/bank_list/bank_list_screen.dart';
import 'banks/store/bank_store.dart';
import 'cost_center/models/cost_center_model.dart';
import 'cost_center/pages/cost_center_form/cost_center_form_screen.dart';
import 'cost_center/pages/cost_center_list/cost_center_list_screen.dart';
import 'cost_center/store/cost_center_list_store.dart';
import 'financial_concept/models/financial_concept_model.dart';
import 'financial_concept/pages/financial_concept_list/financial_concept_list_screen.dart';
import 'financial_concept/pages/form_financial_concept/financial_concept_form_screen.dart';
import 'financial_months/pages/financial_month_list_screen.dart';
import 'members/models/member_model.dart';
import 'members/pages/add_members/add_member_screen.dart';
import 'members/pages/members_list/members_screen.dart';
import 'members/pages/pending_review/pending_review_member_detail_screen.dart';
import 'members/pages/pending_review/pending_review_members_screen.dart';
import 'members/pages/view_member/view_member_screen.dart';
import 'rbac/pages/role_permission_screen.dart';
import 'rbac/pages/user_access_screen.dart';

import 'pages/integrations/whatsapp/whatsapp_callback_screen.dart';
import 'church/pages/church_profile_screen.dart';

settingsRouter() {
  return <RouteBase>[
    GoRoute(
      path: '/members',
      pageBuilder: (context, state) {
        return transitionCustom(MembersScreen());
      },
    ),
    GoRoute(
      path: '/rbac/roles',
      pageBuilder: (context, state) {
        return transitionCustom(const RolePermissionScreen());
      },
    ),
    GoRoute(
      path: '/rbac/users',
      pageBuilder: (context, state) {
        return transitionCustom(const UserAccessScreen());
      },
    ),
    GoRoute(
      path: '/member/add',
      pageBuilder: (context, state) {
        return transitionCustom(AddMemberScreen());
      },
    ),
    GoRoute(
      path: '/member/edit/:memberId',
      pageBuilder: (context, state) {
        MemberModel member;
        member = state.extra as MemberModel;

        return transitionCustom(AddMemberScreen(member: member));
      },
    ),
    GoRoute(
      path: '/member/view/:memberId',
      pageBuilder: (context, state) {
        final memberId = state.pathParameters['memberId']!;
        final initialMember =
            state.extra is MemberModel ? state.extra as MemberModel : null;
        return transitionCustom(
          ViewMemberScreen(memberId: memberId, initialMember: initialMember),
        );
      },
    ),
    GoRoute(
      path: '/members/pending-review',
      pageBuilder: (context, state) {
        return transitionCustom(const PendingReviewMembersScreen());
      },
    ),
    GoRoute(
      path: '/members/pending-review/:memberId',
      pageBuilder: (context, state) {
        final memberId = state.pathParameters['memberId']!;
        return transitionCustom(
          PendingReviewMemberDetailScreen(memberId: memberId),
        );
      },
    ),
    GoRoute(
      path: '/availability-accounts',
      pageBuilder: (context, state) {
        return transitionCustom(AvailabilityAccountsListScreen());
      },
    ),
    GoRoute(
      path: '/availability-accounts/add',
      pageBuilder: (context, state) {
        return transitionCustom(AvailabilityAccountsScreen());
      },
    ),
    GoRoute(
      path: '/availability-accounts/edit/:availabilityAccountId',
      pageBuilder: (context, state) {
        final accountId = state.pathParameters['availabilityAccountId']!;
        final initialAccount =
            state.extra is AvailabilityAccountModel
                ? state.extra as AvailabilityAccountModel
                : null;
        return transitionCustom(
          EditAvailabilityAccountScreen(
            availabilityAccountId: accountId,
            initialAccount: initialAccount,
          ),
        );
      },
    ),
    GoRoute(
      path: '/financial-concepts',
      pageBuilder: (context, state) {
        return transitionCustom(const FinancialConceptListScreen());
      },
    ),
    GoRoute(
      path: '/financial-concepts/add',
      pageBuilder: (context, state) {
        return transitionCustom(const FinancialConceptFormScreen());
      },
    ),
    GoRoute(
      path: '/financial-concepts/edit/:financialConceptId',
      pageBuilder: (context, state) {
        final concept =
            state.extra is FinancialConceptModel
                ? state.extra as FinancialConceptModel
                : null;
        return transitionCustom(FinancialConceptFormScreen(concept: concept));
      },
    ),
    GoRoute(
      path: '/banks',
      pageBuilder: (context, state) {
        return transitionCustom(const BankListScreen());
      },
    ),
    GoRoute(
      path: '/banks/add',
      pageBuilder: (context, state) {
        return transitionCustom(const BankFormScreen());
      },
    ),
    GoRoute(
      path: '/banks/edit/:bankId',
      pageBuilder: (context, state) {
        BankModel? bank;
        if (state.extra is BankModel) {
          bank = state.extra as BankModel;
        } else {
          final bankId = state.pathParameters['bankId'];
          if (bankId != null) {
            final store = context.read<BankStore>();
            bank = store.findByBankId(bankId);
          }
        }

        return transitionCustom(BankFormScreen(bank: bank));
      },
    ),
    GoRoute(
      path: '/cost-center',
      pageBuilder: (context, state) {
        return transitionCustom(const CostCenterListScreen());
      },
    ),
    GoRoute(
      path: '/cost-center/add',
      pageBuilder: (context, state) {
        return transitionCustom(const CostCenterFormScreen());
      },
    ),
    GoRoute(
      path: '/cost-center/edit/:costCenterId',
      pageBuilder: (context, state) {
        CostCenterModel? costCenter;
        if (state.extra is CostCenterModel) {
          costCenter = state.extra as CostCenterModel;
        } else {
          final id = state.pathParameters['costCenterId'];
          if (id != null) {
            final store = context.read<CostCenterListStore>();
            costCenter = store.findByCostCenterId(id);
          }
        }

        return transitionCustom(CostCenterFormScreen(costCenter: costCenter));
      },
    ),
    GoRoute(
      path: '/financial-months',
      pageBuilder: (context, state) {
        return transitionCustom(const FinancialMonthListScreen());
      },
    ),

    GoRoute(
      path: '/integrations/whatsapp/callback',
      pageBuilder: (context, state) {
        return transitionCustom(
          WhatsappCallbackScreen(queryParameters: state.uri.queryParameters),
        );
      },
    ),
    GoRoute(
      path: '/church-profile',
      pageBuilder: (context, state) {
        if (state.uri.queryParameters['code'] != null) {
          return transitionCustom(
            WhatsappCallbackScreen(queryParameters: state.uri.queryParameters),
          );
        }
        return transitionCustom(const ChurchProfileScreen());
      },
    ),
  ];
}
