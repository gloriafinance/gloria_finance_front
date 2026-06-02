import 'package:flutter/material.dart';

import '../../models/member_model.dart';
import 'member_detail_support.dart';

class MemberDetailSections extends StatelessWidget {
  final MemberModel member;
  final bool mobile;
  final MemberDetailLabels labels;
  final Widget statusBadge;

  const MemberDetailSections({
    super.key,
    required this.member,
    required this.mobile,
    required this.labels,
    required this.statusBadge,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        memberDetailSectionCard(
          title: labels.personalInfoTitle,
          child: memberDetailInfoGrid(
            mobile: mobile,
            items: [
              MemberDetailInfoItem(label: labels.nameLabel, value: member.name),
              MemberDetailInfoItem(
                label: labels.phoneLabel,
                value: memberDetailOrNotInformed(
                  labels.notInformedLabel,
                  member.phone,
                ),
              ),
              MemberDetailInfoItem(
                label: labels.emailLabel,
                value: memberDetailOrNotInformed(
                  labels.notInformedLabel,
                  member.email,
                ),
              ),
              MemberDetailInfoItem(
                label: labels.dniLabel,
                value: memberDetailOrNotInformed(
                  labels.notInformedLabel,
                  member.dni,
                ),
              ),
              MemberDetailInfoItem(
                label: labels.birthdateLabel,
                value: memberDetailFormatDate(
                  labels.notInformedLabel,
                  member.birthdate,
                ),
              ),
              MemberDetailInfoItem(
                label: labels.conversionDateLabel,
                value: memberDetailFormatDate(
                  labels.notInformedLabel,
                  member.conversionDate,
                ),
              ),
              MemberDetailInfoItem(
                label: labels.baptismDateLabel,
                value: memberDetailFormatDate(
                  labels.notInformedLabel,
                  member.baptismDate,
                ),
              ),
              MemberDetailInfoItem(
                label: labels.genderLabel,
                value: memberDetailOrNotInformed(
                  labels.notInformedLabel,
                  member.gender,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        memberDetailSectionCard(
          title: labels.addressTitle,
          child: memberDetailInfoGrid(
            mobile: mobile,
            items: [
              MemberDetailInfoItem(
                label: labels.addressFieldLabel,
                value: memberDetailOrNotInformed(
                  labels.notInformedLabel,
                  member.address,
                ),
                fullWidth: true,
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        memberDetailSectionCard(
          title: labels.registrationTitle,
          child: memberDetailInfoGrid(
            mobile: mobile,
            items: [
              MemberDetailInfoItem(
                label: labels.createdAtLabel,
                value: memberDetailFormatDate(
                  labels.notInformedLabel,
                  member.createdAt,
                ),
              ),
              MemberDetailInfoItem(
                label: labels.churchLabel,
                value: memberDetailOrNotInformed(
                  labels.notInformedLabel,
                  member.church?.name,
                ),
              ),
              MemberDetailInfoItem(
                label: labels.statusLabel,
                value: '',
                badge: statusBadge,
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        memberDetailSectionCard(
          title: labels.lgpdTitle,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                spacing: 12,
                runSpacing: 12,
                children: [
                  memberDetailStatusBadge(
                    label:
                        (member.lgpdConsent?.accepted ?? false)
                            ? labels.lgpdYesLabel
                            : labels.lgpdNoLabel,
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
                        ? labels.lgpdAcceptedMessage(
                          memberDetailFormatDate(
                            labels.notInformedLabel,
                            member.lgpdConsent?.acceptedAt,
                          ),
                        )
                        : labels.lgpdNotInformedLabel,
                  ),
                ],
              ),
              if ((member.lgpdConsent?.source ?? '').isNotEmpty) ...[
                const SizedBox(height: 14),
                memberDetailInfoGrid(
                  mobile: mobile,
                  items: [
                    MemberDetailInfoItem(
                      label: labels.lgpdSourceLabel,
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
