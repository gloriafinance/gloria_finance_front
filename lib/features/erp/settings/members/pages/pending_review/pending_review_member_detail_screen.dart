import 'package:flutter/material.dart';
import 'package:gloria_finance/core/theme/app_color.dart';
import 'package:gloria_finance/core/theme/app_fonts.dart';
import 'package:gloria_finance/core/toast.dart';
import 'package:gloria_finance/core/utils/index.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'package:gloria_finance/l10n/app_localizations.dart';

import '../../models/member_model.dart';
import '../../store/pending_review_member_detail_store.dart';
import '../../widgets/detail/member_detail_layout.dart';
import '../../widgets/detail/member_detail_support.dart';
import 'widgets/pending_review_member_detail_actions.dart';
import 'widgets/pending_review_member_detail_header.dart';

class PendingReviewMemberDetailScreen extends StatelessWidget {
  final String memberId;

  const PendingReviewMemberDetailScreen({super.key, required this.memberId});

  @override
  Widget build(BuildContext context) {
    Toast.init(context);

    return ChangeNotifierProvider(
      create: (_) => PendingReviewMemberDetailStore(memberId: memberId)..load(),
      child: const _PendingReviewMemberDetailView(),
    );
  }
}

class _PendingReviewMemberDetailView extends StatelessWidget {
  const _PendingReviewMemberDetailView();

  @override
  Widget build(BuildContext context) {
    final store = context.watch<PendingReviewMemberDetailStore>();
    final state = store.state;
    final l10n = AppLocalizations.of(context)!;
    final mobile = isMobile(context);

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
              PendingReviewMemberDetailHeader(mobile: mobile),
              const SizedBox(height: 24),
              if (state.loading)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 64),
                  child: Center(child: CircularProgressIndicator()),
                )
              else if (state.member == null)
                _errorState(state.error ?? l10n.member_pending_review_not_found)
              else
                _reviewCard(context, store, state.member!, mobile, l10n),
            ],
          ),
        ),
      ),
    );
  }

  Widget _reviewCard(
    BuildContext context,
    PendingReviewMemberDetailStore store,
    MemberModel member,
    bool mobile,
    AppLocalizations l10n,
  ) {
    final labels = _pendingReviewLabels(l10n);
    final statusBadge = memberDetailStatusBadge(
      label: l10n.member_list_status_pending_review,
      background: const Color(0xFFFFF1D6),
      foreground: const Color(0xFF9A6700),
    );

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
            PendingReviewMemberDetailActions(
              mobile: mobile,
              saving: store.state.saving,
              onApprove: () => _approve(context, store, member, l10n),
              onReject: () => _reject(context, store, member, l10n),
            ),
          ],
        ),
      ),
    );
  }

  MemberDetailLabels _pendingReviewLabels(AppLocalizations l10n) {
    return MemberDetailLabels(
      personalInfoTitle: l10n.member_pending_review_section_personal,
      addressTitle: l10n.member_pending_review_field_address,
      registrationTitle: l10n.member_pending_review_section_registration,
      lgpdTitle: l10n.member_pending_review_lgpd_section_title,
      notInformedLabel: l10n.member_pending_review_not_informed,
      photoUnavailableLabel: l10n.member_pending_review_photo_unavailable,
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
      addressFieldLabel: l10n.member_pending_review_field_address,
      lgpdYesLabel: l10n.member_pending_review_lgpd_yes,
      lgpdNoLabel: l10n.member_pending_review_lgpd_no,
      lgpdNotInformedLabel: l10n.member_pending_review_lgpd_not_informed,
      lgpdSourceLabel: l10n.member_pending_review_lgpd_source_label,
      lgpdAcceptedMessage: l10n.member_pending_review_lgpd_accepted_message,
    );
  }

  Widget _errorState(String message) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Text(
        message,
        style: const TextStyle(
          fontFamily: AppFonts.fontSubTitle,
          fontSize: 15,
          color: AppColors.black,
        ),
      ),
    );
  }

  Future<void> _approve(
    BuildContext context,
    PendingReviewMemberDetailStore store,
    MemberModel member,
    AppLocalizations l10n,
  ) async {
    final confirmed = await _confirm(
      context,
      title: l10n.member_pending_review_approve_confirm_title,
      message: l10n.member_pending_review_approve_confirm_message(member.name),
      confirmText: l10n.member_pending_review_action_approve,
    );

    if (confirmed != true) return;

    final success = await store.approve();
    if (!context.mounted) return;
    if (!success) {
      Toast.showMessage(
        store.state.error ?? l10n.app_error_unexpected_retry,
        ToastType.error,
      );
      return;
    }

    Toast.showMessage(
      l10n.member_pending_review_approve_success,
      ToastType.success,
    );
    context.go('/members/pending-review');
  }

  Future<void> _reject(
    BuildContext context,
    PendingReviewMemberDetailStore store,
    MemberModel member,
    AppLocalizations l10n,
  ) async {
    final confirmed = await _confirm(
      context,
      title: l10n.member_pending_review_reject_confirm_title,
      message: l10n.member_pending_review_reject_confirm_message(member.name),
      confirmText: l10n.member_pending_review_action_reject,
    );

    if (confirmed != true) return;

    final success = await store.reject();
    if (!context.mounted) return;
    if (!success) {
      Toast.showMessage(
        store.state.error ?? l10n.app_error_unexpected_retry,
        ToastType.error,
      );
      return;
    }

    Toast.showMessage(
      l10n.member_pending_review_reject_success,
      ToastType.success,
    );
    context.go('/members/pending-review');
  }

  Future<bool?> _confirm(
    BuildContext context, {
    required String title,
    required String message,
    required String confirmText,
  }) {
    final l10n = AppLocalizations.of(context)!;
    return showDialog<bool>(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text(title),
            content: Text(message),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: Text(l10n.common_cancel),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                child: Text(confirmText),
              ),
            ],
          ),
    );
  }
}
