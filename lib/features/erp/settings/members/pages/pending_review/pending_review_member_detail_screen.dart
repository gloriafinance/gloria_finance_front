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
              _header(context, l10n, mobile),
              const SizedBox(height: 24),
              if (state.loading)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 64),
                  child: Center(child: CircularProgressIndicator()),
                )
              else if (state.member == null)
                _errorState(state.error ?? l10n.member_pending_review_not_found)
              else
                _reviewCard(context, store, state.member!, l10n, mobile),
            ],
          ),
        ),
      ),
    );
  }

  Widget _header(
    BuildContext context,
    AppLocalizations l10n,
    bool mobile,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: 12,
          runSpacing: 12,
          children: [
            InkWell(
              onTap: () => context.go('/members/pending-review'),
              borderRadius: BorderRadius.circular(999),
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(999),
                  border: Border.all(color: AppColors.greyMiddle),
                ),
                child: const Icon(
                  Icons.arrow_back_ios_new,
                  size: 18,
                  color: AppColors.purple,
                ),
              ),
            ),
            Text(
              l10n.member_pending_review_detail_title,
              style: TextStyle(
                fontFamily: AppFonts.fontTitle,
                fontSize: mobile ? 26 : 30,
                color: AppColors.black,
              ),
            ),
            _statusBadge(
              label: l10n.member_list_status_pending_review,
              background: const Color(0xFFFFF1D6),
              foreground: const Color(0xFF9A6700),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Text(
          'Confira os dados enviados pelo membro antes de aprovar ou rejeitar o cadastro.',
          style: const TextStyle(
            fontFamily: AppFonts.fontSubTitle,
            fontSize: 15,
            color: AppColors.grey,
          ),
        ),
      ],
    );
  }

  Widget _reviewCard(
    BuildContext context,
    PendingReviewMemberDetailStore store,
    MemberModel member,
    AppLocalizations l10n,
    bool mobile,
  ) {
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
            mobile
                ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _identityPanel(member, l10n, mobile),
                    const SizedBox(height: 20),
                    _detailsPanel(member, l10n, mobile),
                  ],
                )
                : Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 320,
                      child: _identityPanel(member, l10n, mobile),
                    ),
                    const SizedBox(width: 28),
                    Expanded(child: _detailsPanel(member, l10n, mobile)),
                  ],
                ),
            const SizedBox(height: 24),
            const Divider(height: 1, color: Color(0xFFE5E7EB)),
            const SizedBox(height: 20),
            _actions(context, store, member, l10n, mobile),
          ],
        ),
      ),
    );
  }

  Widget _identityPanel(
    MemberModel member,
    AppLocalizations l10n,
    bool mobile,
  ) {
    final photoUrl = _photoUrl(member);
    final photoSize = mobile ? 140.0 : 190.0;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFFAFAFB),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Column(
        crossAxisAlignment:
            mobile ? CrossAxisAlignment.center : CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: photoSize,
              height: photoSize,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                color: AppColors.greyLight,
              ),
              clipBehavior: Clip.antiAlias,
              child:
                  photoUrl != null
                      ? Image.network(
                        photoUrl,
                        fit: BoxFit.cover,
                        errorBuilder:
                            (_, _, _) => _photoPlaceholder(photoSize, mobile),
                      )
                      : _photoPlaceholder(photoSize, mobile),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            member.name,
            textAlign: mobile ? TextAlign.center : TextAlign.left,
            style: const TextStyle(
              fontFamily: AppFonts.fontTitle,
              fontSize: 24,
              color: AppColors.black,
            ),
          ),
          const SizedBox(height: 8),
          _identityLine(member.phone, Icons.phone_outlined, mobile),
          if (member.email.trim().isNotEmpty) ...[
            const SizedBox(height: 8),
            _identityLine(member.email, Icons.mail_outline, mobile),
          ],
          const SizedBox(height: 18),
          Align(
            alignment: mobile ? Alignment.center : Alignment.centerLeft,
            child: _statusBadge(
              label: l10n.member_list_status_pending_review,
              background: const Color(0xFFFFF1D6),
              foreground: const Color(0xFF9A6700),
            ),
          ),
        ],
      ),
    );
  }

  Widget _detailsPanel(
    MemberModel member,
    AppLocalizations l10n,
    bool mobile,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionCard(
          title: l10n.member_pending_review_section_personal,
          child: _infoGrid(
            mobile: mobile,
            items: [
              _InfoItem(
                label: l10n.member_list_header_name,
                value: member.name,
              ),
              _InfoItem(
                label: l10n.member_list_header_phone,
                value: _orNotInformed(member.phone),
              ),
              _InfoItem(
                label: l10n.member_list_header_email,
                value: _orNotInformed(member.email),
              ),
              _InfoItem(
                label: l10n.member_register_dni_label,
                value: _orNotInformed(member.dni),
              ),
              _InfoItem(
                label: l10n.member_register_birthdate_label,
                value: _formatDate(member.birthdate),
              ),
              _InfoItem(
                label: l10n.member_pending_review_field_gender,
                value: _orNotInformed(member.gender),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        _sectionCard(
          title: l10n.member_pending_review_field_address,
          child: _infoGrid(
            mobile: mobile,
            items: [
              _InfoItem(
                label: l10n.member_pending_review_field_address,
                value: _addressValue(member.address),
                fullWidth: true,
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        _sectionCard(
          title: l10n.member_pending_review_section_registration,
          child: _infoGrid(
            mobile: mobile,
            items: [
              _InfoItem(
                label: l10n.member_pending_review_header_created_at,
                value: _formatDate(member.createdAt),
              ),
              _InfoItem(
                label: l10n.member_registration_link_church_label,
                value: _orNotInformed(member.church?.name),
              ),
              _InfoItem(
                label: l10n.member_list_header_status,
                value: l10n.member_list_status_pending_review,
                badge: _statusBadge(
                  label: l10n.member_list_status_pending_review,
                  background: const Color(0xFFFFF1D6),
                  foreground: const Color(0xFF9A6700),
                ),
              ),
              _InfoItem(
                label: l10n.member_register_conversion_date_label,
                value: _formatDate(member.conversionDate),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        _sectionCard(
          title: 'Consentimento LGPD',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                spacing: 12,
                runSpacing: 12,
                children: [
                  _statusBadge(
                    label: _lgpdLabel(member, l10n),
                    background:
                        (member.lgpdConsent?.accepted ?? false)
                            ? const Color(0xFFE8F8EF)
                            : const Color(0xFFFEECEC),
                    foreground:
                        (member.lgpdConsent?.accepted ?? false)
                            ? const Color(0xFF0D7A43)
                            : const Color(0xFFB42318),
                  ),
                  Text(
                    (member.lgpdConsent?.acceptedAt != null)
                        ? 'Consentimento aceito em ${_formatDate(member.lgpdConsent?.acceptedAt)}'
                        : 'Consentimento não informado',
                    style: const TextStyle(
                      fontFamily: AppFonts.fontSubTitle,
                      fontSize: 14,
                      color: AppColors.black,
                    ),
                  ),
                ],
              ),
              if ((member.lgpdConsent?.source ?? '').isNotEmpty) ...[
                const SizedBox(height: 14),
                _infoGrid(
                  mobile: mobile,
                  items: [
                    _InfoItem(
                      label: 'Origem',
                      value: member.lgpdConsent!.source!,
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  Widget _sectionCard({required String title, required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFFFAFAFB),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontFamily: AppFonts.fontTitle,
              fontSize: 18,
              color: AppColors.purple,
            ),
          ),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }

  Widget _infoGrid({required bool mobile, required List<_InfoItem> items}) {
    if (mobile) {
      return Column(
        children:
            items
                .map(
                  (item) => Padding(
                    padding: const EdgeInsets.only(bottom: 14),
                    child: _infoTile(item),
                  ),
                )
                .toList(),
      );
    }

    final rows = <Widget>[];
    for (var i = 0; i < items.length; i += 2) {
      final left = items[i];
      final right = i + 1 < items.length ? items[i + 1] : null;

      if (left.fullWidth) {
        rows.add(Padding(
          padding: const EdgeInsets.only(bottom: 14),
          child: _infoTile(left),
        ));
        continue;
      }

      if (right != null && right.fullWidth) {
        rows.add(Padding(
          padding: const EdgeInsets.only(bottom: 14),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: _infoTile(left)),
            ],
          ),
        ));
        rows.add(Padding(
          padding: const EdgeInsets.only(bottom: 14),
          child: _infoTile(right),
        ));
        continue;
      }

      rows.add(
        Padding(
          padding: const EdgeInsets.only(bottom: 14),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: _infoTile(left)),
              const SizedBox(width: 16),
              Expanded(child: right != null ? _infoTile(right) : const SizedBox()),
            ],
          ),
        ),
      );
    }

    return Column(children: rows);
  }

  Widget _infoTile(_InfoItem item) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          item.label,
          style: const TextStyle(
            fontFamily: AppFonts.fontSubTitle,
            fontSize: 12,
            color: AppColors.grey,
          ),
        ),
        const SizedBox(height: 6),
        item.badge ??
            Text(
              item.value,
              style: const TextStyle(
                fontFamily: AppFonts.fontTitle,
                fontSize: 15,
                color: AppColors.black,
              ),
            ),
      ],
    );
  }

  Widget _actions(
    BuildContext context,
    PendingReviewMemberDetailStore store,
    MemberModel member,
    AppLocalizations l10n,
    bool mobile,
  ) {
    final busy = store.state.saving;

    if (busy) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 20),
        child: Center(child: CircularProgressIndicator()),
      );
    }

    if (mobile) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _rejectButton(context, store, member, l10n),
          const SizedBox(height: 12),
          _approveButton(context, store, member, l10n),
        ],
      );
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        SizedBox(
          width: 220,
          child: _rejectButton(context, store, member, l10n),
        ),
        const SizedBox(width: 12),
        SizedBox(
          width: 220,
          child: _approveButton(context, store, member, l10n),
        ),
      ],
    );
  }

  Widget _approveButton(
    BuildContext context,
    PendingReviewMemberDetailStore store,
    MemberModel member,
    AppLocalizations l10n,
  ) {
    return CustomButton(
      text: l10n.member_pending_review_action_approve,
      backgroundColor: AppColors.green,
      textColor: Colors.white,
      icon: Icons.check,
      onPressed: () => _approve(context, store, member, l10n),
    );
  }

  Widget _rejectButton(
    BuildContext context,
    PendingReviewMemberDetailStore store,
    MemberModel member,
    AppLocalizations l10n,
  ) {
    return CustomButton(
      text: l10n.member_pending_review_action_reject,
      backgroundColor: Colors.red,
      textColor: Colors.red,
      typeButton: CustomButton.outline,
      icon: Icons.delete_outline,
      onPressed: () => _reject(context, store, member, l10n),
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

  Widget _photoPlaceholder(double size, bool mobile) {
    return Container(
      color: AppColors.greyLight,
      alignment: Alignment.center,
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.person_outline, size: size * 0.34, color: Colors.black45),
          const SizedBox(height: 10),
          Text(
            'Foto nao disponivel',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: AppFonts.fontSubTitle,
              fontSize: mobile ? 12 : 13,
              color: Colors.black54,
            ),
          ),
        ],
      ),
    );
  }

  Widget _identityLine(String value, IconData icon, bool mobile) {
    return Row(
      mainAxisAlignment:
          mobile ? MainAxisAlignment.center : MainAxisAlignment.start,
      children: [
        Icon(icon, size: 16, color: AppColors.grey),
        const SizedBox(width: 8),
        Flexible(
          child: Text(
            value,
            textAlign: mobile ? TextAlign.center : TextAlign.left,
            style: const TextStyle(
              fontFamily: AppFonts.fontSubTitle,
              fontSize: 14,
              color: AppColors.black,
            ),
          ),
        ),
      ],
    );
  }

  Widget _statusBadge({
    required String label,
    required Color background,
    required Color foreground,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontFamily: AppFonts.fontTitle,
          fontSize: 12,
          color: foreground,
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

  String _formatDate(String? value) {
    final parsed = parseIsoDate(value);
    if (parsed == null) {
      return 'Nao informado';
    }
    return formatDateToDDMMYYYY(parsed.toLocal());
  }

  String _orNotInformed(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Nao informado';
    }
    return value;
  }

  String _addressValue(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Nao informado';
    }
    return value;
  }

  String _lgpdLabel(MemberModel member, AppLocalizations l10n) {
    final accepted = member.lgpdConsent?.accepted ?? false;
    return accepted ? l10n.member_pending_review_lgpd_yes : 'Nao aceito';
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

class _InfoItem {
  final String label;
  final String value;
  final bool fullWidth;
  final Widget? badge;

  const _InfoItem({
    required this.label,
    required this.value,
    this.fullWidth = false,
    this.badge,
  });
}
