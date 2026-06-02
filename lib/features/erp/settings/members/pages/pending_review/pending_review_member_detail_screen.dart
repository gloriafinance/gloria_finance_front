import 'package:flutter/material.dart';
import 'package:gloria_finance/core/layout/view_detail_widgets.dart';
import 'package:gloria_finance/core/theme/app_color.dart';
import 'package:gloria_finance/core/theme/app_fonts.dart';
import 'package:gloria_finance/core/toast.dart';
import 'package:gloria_finance/core/utils/index.dart';
import 'package:gloria_finance/core/widgets/button_acton_table.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'package:gloria_finance/l10n/app_localizations.dart';

import '../../models/member_model.dart';
import '../../models/member_status.dart';
import '../../store/pending_review_member_detail_store.dart';

class PendingReviewMemberDetailScreen extends StatelessWidget {
  final String memberId;

  const PendingReviewMemberDetailScreen({super.key, required this.memberId});

  @override
  Widget build(BuildContext context) {
    Toast.init(context);

    return ChangeNotifierProvider(
      create:
          (_) => PendingReviewMemberDetailStore(memberId: memberId)..load(),
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

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _header(context, l10n),
        const SizedBox(height: 24),
        if (state.loading)
          const Center(child: CircularProgressIndicator())
        else if (state.member == null)
          Padding(
            padding: const EdgeInsets.only(top: 32),
            child: Center(
              child: Text(state.error ?? l10n.member_pending_review_not_found),
            ),
          )
        else
          _detailCard(context, store, state.member!, l10n),
      ],
    );
  }

  Widget _header(BuildContext context, AppLocalizations l10n) {
    return Row(
      children: [
        GestureDetector(
          onTap: () => context.go('/members/pending-review'),
          child: const Icon(Icons.arrow_back_ios, color: AppColors.purple),
        ),
        Expanded(
          child: Text(
            l10n.member_pending_review_detail_title,
            textAlign: TextAlign.left,
            style: const TextStyle(
              fontFamily: AppFonts.fontTitle,
              fontSize: 24,
              color: Colors.black,
            ),
          ),
        ),
      ],
    );
  }

  Widget _detailCard(
    BuildContext context,
    PendingReviewMemberDetailStore store,
    MemberModel member,
    AppLocalizations l10n,
  ) {
    final mobile = isMobile(context);

    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildTitle(l10n.member_pending_review_detail_card_title),
            const Divider(),
            if (_photoUrl(member) != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 24),
                child: Center(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      _photoUrl(member)!,
                      height: 220,
                      width: 220,
                      fit: BoxFit.cover,
                      errorBuilder:
                          (_, _, _) => Container(
                            height: 220,
                            width: 220,
                            color: AppColors.greyLight,
                            alignment: Alignment.center,
                            child: const Icon(
                              Icons.person_outline,
                              size: 56,
                              color: Colors.black45,
                            ),
                          ),
                    ),
                  ),
                ),
              ),
            buildSectionTitle(l10n.member_pending_review_section_personal),
            const SizedBox(height: 12),
            buildDetailRow(mobile, l10n.member_list_header_name, member.name),
            buildDetailRow(
              mobile,
              l10n.member_list_header_email,
              _orDash(member.email),
            ),
            buildDetailRow(
              mobile,
              l10n.member_list_header_phone,
              _orDash(member.phone),
            ),
            buildDetailRow(
              mobile,
              l10n.member_register_dni_label,
              _orDash(member.dni),
            ),
            buildDetailRow(
              mobile,
              l10n.member_register_birthdate_label,
              _formatDate(member.birthdate),
            ),
            buildDetailRow(
              mobile,
              l10n.member_register_conversion_date_label,
              _formatDate(member.conversionDate),
            ),
            buildDetailRow(
              mobile,
              l10n.member_register_baptism_date_label,
              _formatDate(member.baptismDate),
            ),
            buildDetailRow(
              mobile,
              l10n.member_pending_review_field_gender,
              _orDash(member.gender),
            ),
            const SizedBox(height: 24),
            buildSectionTitle(l10n.member_pending_review_section_registration),
            const SizedBox(height: 12),
            buildDetailRow(
              mobile,
              l10n.member_pending_review_header_created_at,
              _formatDate(member.createdAt),
            ),
            buildDetailRow(
              mobile,
              l10n.member_list_header_status,
              _statusLabel(member.status, l10n),
              statusColor: _statusColor(member.status),
            ),
            buildDetailRow(
              mobile,
              l10n.member_registration_link_church_label,
              _orDash(member.church?.name),
            ),
            buildDetailRow(
              mobile,
              l10n.member_pending_review_field_address,
              _orDash(member.address),
            ),
            buildDetailRow(
              mobile,
              l10n.member_pending_review_field_lgpd,
              _lgpdLabel(member, l10n),
            ),
            if (member.lgpdConsent?.acceptedAt != null)
              buildDetailRow(
                mobile,
                l10n.member_pending_review_field_lgpd_accepted_at,
                _formatDate(member.lgpdConsent?.acceptedAt),
              ),
            const SizedBox(height: 32),
            _actions(context, store, member, l10n),
          ],
        ),
      ),
    );
  }

  Widget _actions(
    BuildContext context,
    PendingReviewMemberDetailStore store,
    MemberModel member,
    AppLocalizations l10n,
  ) {
    final busy = store.state.saving;

    if (busy) {
      return const Center(child: CircularProgressIndicator());
    }

    return Row(
      mainAxisAlignment:
          isMobile(context) ? MainAxisAlignment.center : MainAxisAlignment.end,
      children: [
        ButtonActionTable(
          color: AppColors.green,
          text: l10n.member_pending_review_action_approve,
          onPressed: () => _approve(context, store, member, l10n),
          icon: Icons.check,
        ),
        ButtonActionTable(
          color: Colors.red,
          text: l10n.member_pending_review_action_reject,
          onPressed: () => _reject(context, store, member, l10n),
          icon: Icons.delete_outline,
        ),
      ],
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

  String _orDash(String? value) {
    if (value == null || value.trim().isEmpty) {
      return '-';
    }
    return value;
  }

  String _formatDate(String? value) {
    if (value == null || value.isEmpty) {
      return '-';
    }
    return convertDateFormatToDDMMYYYY(value);
  }

  Color _statusColor(MemberStatus status) {
    return switch (status) {
      MemberStatus.approved => Colors.green,
      MemberStatus.inactive => Colors.red,
      MemberStatus.pendingReview => Colors.orange,
    };
  }

  String _statusLabel(MemberStatus status, AppLocalizations l10n) {
    return switch (status) {
      MemberStatus.approved => l10n.member_list_status_approved,
      MemberStatus.inactive => l10n.member_list_status_inactive,
      MemberStatus.pendingReview => l10n.member_list_status_pending_review,
    };
  }

  String _lgpdLabel(MemberModel member, AppLocalizations l10n) {
    final accepted = member.lgpdConsent?.accepted ?? false;
    return accepted
        ? l10n.member_pending_review_lgpd_yes
        : l10n.member_pending_review_lgpd_no;
  }

  String? _photoUrl(MemberModel member) {
    final value = member.profilePhoto;
    if (value == null || value.isEmpty) {
      return null;
    }

    final uri = Uri.tryParse(value);
    if (uri == null || !uri.hasScheme || uri.host.isEmpty) {
      return null;
    }

    return value;
  }
}
