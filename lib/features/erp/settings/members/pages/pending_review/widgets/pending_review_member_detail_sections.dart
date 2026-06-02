import 'package:flutter/material.dart';
import 'package:gloria_finance/l10n/app_localizations.dart';

import '../../../models/member_model.dart';
import 'pending_review_member_detail_support.dart';

class PendingReviewMemberDetailSections extends StatelessWidget {
  final MemberModel member;
  final bool mobile;

  const PendingReviewMemberDetailSections({
    super.key,
    required this.member,
    required this.mobile,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        pendingReviewSectionCard(
          title: l10n.member_pending_review_section_personal,
          child: pendingReviewInfoGrid(
            mobile: mobile,
            items: [
              PendingReviewInfoItem(
                label: l10n.member_list_header_name,
                value: member.name,
              ),
              PendingReviewInfoItem(
                label: l10n.member_list_header_phone,
                value: pendingReviewOrNotInformed(l10n, member.phone),
              ),
              PendingReviewInfoItem(
                label: l10n.member_list_header_email,
                value: pendingReviewOrNotInformed(l10n, member.email),
              ),
              PendingReviewInfoItem(
                label: l10n.member_register_dni_label,
                value: pendingReviewOrNotInformed(l10n, member.dni),
              ),
              PendingReviewInfoItem(
                label: l10n.member_register_birthdate_label,
                value: pendingReviewFormatDate(l10n, member.birthdate),
              ),
              PendingReviewInfoItem(
                label: l10n.member_pending_review_field_gender,
                value: pendingReviewOrNotInformed(l10n, member.gender),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        pendingReviewSectionCard(
          title: l10n.member_pending_review_field_address,
          child: pendingReviewInfoGrid(
            mobile: mobile,
            items: [
              PendingReviewInfoItem(
                label: l10n.member_pending_review_field_address,
                value: pendingReviewAddressValue(l10n, member.address),
                fullWidth: true,
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        pendingReviewSectionCard(
          title: l10n.member_pending_review_section_registration,
          child: pendingReviewInfoGrid(
            mobile: mobile,
            items: [
              PendingReviewInfoItem(
                label: l10n.member_pending_review_header_created_at,
                value: pendingReviewFormatDate(l10n, member.createdAt),
              ),
              PendingReviewInfoItem(
                label: l10n.member_registration_link_church_label,
                value: pendingReviewOrNotInformed(l10n, member.church?.name),
              ),
              PendingReviewInfoItem(
                label: l10n.member_list_header_status,
                value: l10n.member_list_status_pending_review,
                badge: pendingReviewStatusBadge(
                  label: l10n.member_list_status_pending_review,
                  background: const Color(0xFFFFF1D6),
                  foreground: const Color(0xFF9A6700),
                ),
              ),
              PendingReviewInfoItem(
                label: l10n.member_register_conversion_date_label,
                value: pendingReviewFormatDate(l10n, member.conversionDate),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        pendingReviewSectionCard(
          title: l10n.member_pending_review_lgpd_section_title,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                spacing: 12,
                runSpacing: 12,
                children: [
                  pendingReviewStatusBadge(
                    label: pendingReviewLgpdLabel(l10n, member),
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
                        ? l10n.member_pending_review_lgpd_accepted_message(
                          pendingReviewFormatDate(
                            l10n,
                            member.lgpdConsent?.acceptedAt,
                          ),
                        )
                        : l10n.member_pending_review_lgpd_not_informed,
                  ),
                ],
              ),
              if ((member.lgpdConsent?.source ?? '').isNotEmpty) ...[
                const SizedBox(height: 14),
                pendingReviewInfoGrid(
                  mobile: mobile,
                  items: [
                    PendingReviewInfoItem(
                      label: l10n.member_pending_review_lgpd_source_label,
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
}
