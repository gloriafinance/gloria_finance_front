import 'package:flutter/material.dart';
import 'package:gloria_finance/core/theme/app_color.dart';
import 'package:gloria_finance/core/widgets/form_controls.dart';
import 'package:gloria_finance/l10n/app_localizations.dart';

import 'church_profile_card.dart';

class ChurchProfileGeneralInfoCard extends StatelessWidget {
  final String name;
  final String openerDate;
  final String status;
  final String email;
  final ValueChanged<String> onNameChanged;
  final ValueChanged<String> onEmailChanged;
  final ValueChanged<String> onStatusChanged;
  final VoidCallback onDateTap;

  const ChurchProfileGeneralInfoCard({
    super.key,
    required this.name,
    required this.openerDate,
    required this.status,
    required this.email,
    required this.onNameChanged,
    required this.onEmailChanged,
    required this.onStatusChanged,
    required this.onDateTap,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return ChurchProfileCard(
      title: l10n.settings_church_profile_general_info,
      icon: Icons.info,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Input(
            label: l10n.settings_church_profile_name,
            initialValue: name,
            onChanged: onNameChanged,
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: Input(
                  label: l10n.settings_church_profile_opening_date,
                  initialValue: openerDate,
                  onChanged: (value) {},
                  readOnly: true,
                  iconRight: const Icon(
                    Icons.calendar_today,
                    color: AppColors.purple,
                  ),
                  onTap: onDateTap,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Dropdown(
                  label: l10n.settings_church_profile_status,
                  items: [
                    l10n.settings_church_profile_status_active,
                    l10n.settings_church_profile_status_inactive,
                  ], // TODO: connect to proper Status Enum/Values
                  initialValue:
                      status == 'ACTIVE'
                          ? l10n.settings_church_profile_status_active
                          : l10n.settings_church_profile_status_inactive,
                  onChanged: (value) {
                    onStatusChanged(
                      value == l10n.settings_church_profile_status_active
                          ? 'ACTIVE'
                          : 'INACTIVE',
                    );
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Input(
            label: l10n.settings_church_profile_email,
            initialValue: email,
            onChanged: onEmailChanged,
            keyboardType: TextInputType.emailAddress,
          ),
        ],
      ),
    );
  }
}
