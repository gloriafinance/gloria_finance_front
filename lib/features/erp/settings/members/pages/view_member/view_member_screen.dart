import 'package:flutter/material.dart';
import 'package:gloria_finance/core/theme/app_color.dart';
import 'package:gloria_finance/core/theme/app_fonts.dart';
import 'package:gloria_finance/core/toast.dart';
import 'package:gloria_finance/core/utils/index.dart';
import 'package:gloria_finance/core/widgets/custom_button.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'package:gloria_finance/l10n/app_localizations.dart';

import '../../models/member_model.dart';
import '../../store/member_detail_store.dart';
import '../../widgets/detail/member_detail_layout.dart';
import '../../widgets/detail/member_detail_support.dart';
import '../../widgets/member_delete_confirmation_dialog.dart';
import 'widgets/view_member_actions.dart';
import 'widgets/view_member_header.dart';

class ViewMemberScreen extends StatelessWidget {
  final String memberId;
  final MemberModel? initialMember;

  const ViewMemberScreen({
    super.key,
    required this.memberId,
    this.initialMember,
  });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create:
          (_) => MemberDetailStore(
            memberId: memberId,
            initialMember: initialMember,
          )..load(),
      child: const _ViewMemberView(),
    );
  }
}

class _ViewMemberView extends StatelessWidget {
  const _ViewMemberView();

  @override
  Widget build(BuildContext context) {
    Toast.init(context);

    final store = context.watch<MemberDetailStore>();
    final state = store.state;
    final l10n = AppLocalizations.of(context)!;
    final mobile = isMobile(context);
    final member = state.member;

    final statusBadge =
        member != null
            ? memberStatusBadgeFor(
              status: member.status,
              activeLabel: l10n.member_view_status_active,
              inactiveLabel: l10n.member_view_status_inactive,
              pendingReviewLabel: l10n.member_view_status_pending_review,
            )
            : null;

    return Container(
      width: double.infinity,
      color: const Color(0xFFF5F5F7),
      padding: EdgeInsets.symmetric(
        horizontal: mobile ? 12 : 24,
        vertical: mobile ? 12 : 24,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1160),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ViewMemberHeader(mobile: mobile, statusBadge: statusBadge),
              const SizedBox(height: 24),
              if (state.loading)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 64),
                  child: Center(child: CircularProgressIndicator()),
                )
              else if (state.error != null)
                _errorState(
                  context,
                  l10n,
                  state.error ?? l10n.member_view_load_error,
                  onRetry: store.load,
                )
              else if (member != null)
                _detailCard(
                  context,
                  store,
                  state.deleting,
                  member,
                  mobile,
                  l10n,
                  statusBadge!,
                )
              else
                const SizedBox.shrink(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _detailCard(
    BuildContext context,
    MemberDetailStore store,
    bool deleting,
    MemberModel member,
    bool mobile,
    AppLocalizations l10n,
    Widget statusBadge,
  ) {
    final labels = _viewLabels(l10n);

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
            color: Color.fromRGBO(17, 24, 39, 0.08),
            blurRadius: 24,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(mobile ? 20 : 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            MemberDetailLayout(
              member: member,
              mobile: mobile,
              labels: labels,
              statusBadge: statusBadge,
            ),
            const SizedBox(height: 24),
            const Divider(height: 1, color: Color(0xFFE5E7EB)),
            const SizedBox(height: 20),
            ViewMemberActions(
              mobile: mobile,
              deleting: deleting,
              onBack: () => context.go('/members'),
              onEdit:
                  () => context.go(
                    '/member/edit/${member.memberId}',
                    extra: member,
                  ),
              onDelete: () => _delete(context, store, member, l10n),
            ),
          ],
        ),
      ),
    );
  }

  MemberDetailLabels _viewLabels(AppLocalizations l10n) {
    return MemberDetailLabels(
      personalInfoTitle: l10n.member_view_personal_info,
      addressTitle: l10n.member_view_address,
      registrationTitle: l10n.member_view_registration_info,
      lgpdTitle: l10n.member_view_lgpd,
      notInformedLabel: l10n.member_view_not_informed,
      photoUnavailableLabel: l10n.member_view_photo_not_available,
      nameLabel: l10n.member_list_header_name,
      phoneLabel: l10n.member_list_header_phone,
      emailLabel: l10n.member_list_header_email,
      dniLabel: l10n.member_register_dni_label,
      birthdateLabel: l10n.member_register_birthdate_label,
      genderLabel: l10n.member_pending_review_field_gender,
      conversionDateLabel: l10n.member_register_conversion_date_label,
      baptismDateLabel: l10n.member_register_baptism_date_label,
      createdAtLabel: l10n.member_pending_review_header_created_at,
      churchLabel: l10n.member_registration_link_church_label,
      statusLabel: l10n.member_list_header_status,
      addressFieldLabel: l10n.member_view_address,
      lgpdYesLabel: l10n.member_pending_review_lgpd_yes,
      lgpdNoLabel: l10n.member_pending_review_lgpd_no,
      lgpdNotInformedLabel: l10n.member_pending_review_lgpd_not_informed,
      lgpdSourceLabel: l10n.member_pending_review_lgpd_source_label,
      lgpdAcceptedMessage: l10n.member_pending_review_lgpd_accepted_message,
    );
  }

  Future<void> _delete(
    BuildContext context,
    MemberDetailStore store,
    MemberModel member,
    AppLocalizations l10n,
  ) async {
    final confirmed = await showMemberDeleteConfirmationDialog(
      context,
      memberName: member.name,
    );
    if (confirmed != true || !context.mounted) return;

    final success = await store.delete();
    if (!context.mounted) return;

    if (success) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.member_delete_success)));
      context.go('/members');
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(store.state.error ?? l10n.member_delete_error)),
    );
  }

  Widget _errorState(
    BuildContext context,
    AppLocalizations l10n,
    String message, {
    required Future<void> Function() onRetry,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: const BoxDecoration(
              color: Color(0xFFFEECEC),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.error_outline,
              color: Color(0xFFB42318),
              size: 32,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontFamily: AppFonts.fontSubTitle,
              fontSize: 15,
              color: AppColors.black,
            ),
          ),
          const SizedBox(height: 20),
          CustomButton(
            text: l10n.common_retry,
            backgroundColor: AppColors.purple,
            textColor: Colors.white,
            icon: Icons.refresh,
            onPressed: onRetry,
          ),
        ],
      ),
    );
  }
}
