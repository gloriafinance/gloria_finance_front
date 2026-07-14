import 'package:flutter/material.dart';
import 'package:gloria_finance/core/theme/app_color.dart';
import 'package:gloria_finance/core/widgets/custom_button.dart';
import 'package:gloria_finance/l10n/app_localizations.dart';

class ViewMemberActions extends StatelessWidget {
  final bool mobile;
  final bool deleting;
  final VoidCallback onBack;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const ViewMemberActions({
    super.key,
    required this.mobile,
    this.deleting = false,
    required this.onBack,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    if (deleting) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 20),
        child: Center(child: CircularProgressIndicator()),
      );
    }

    if (mobile) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _backButton(l10n),
          const SizedBox(height: 12),
          _editButton(l10n),
          const SizedBox(height: 12),
          _deleteButton(l10n),
        ],
      );
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        SizedBox(width: 180, child: _backButton(l10n)),
        const SizedBox(width: 12),
        SizedBox(width: 180, child: _editButton(l10n)),
        const SizedBox(width: 12),
        SizedBox(width: 180, child: _deleteButton(l10n)),
      ],
    );
  }

  Widget _backButton(AppLocalizations l10n) {
    return CustomButton(
      text: l10n.member_view_back,
      backgroundColor: AppColors.grey,
      textColor: AppColors.grey,
      typeButton: CustomButton.outline,
      icon: Icons.arrow_back_outlined,
      onPressed: onBack,
    );
  }

  Widget _editButton(AppLocalizations l10n) {
    return CustomButton(
      text: l10n.member_view_edit,
      backgroundColor: AppColors.blue,
      textColor: Colors.white,
      icon: Icons.edit_outlined,
      onPressed: onEdit,
    );
  }

  Widget _deleteButton(AppLocalizations l10n) {
    return CustomButton(
      text: l10n.member_delete_action,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      icon: Icons.delete_outline,
      onPressed: onDelete,
    );
  }
}
