import 'package:flutter/material.dart';
import 'package:gloria_finance/core/theme/app_color.dart';
import 'package:gloria_finance/core/theme/app_fonts.dart';
import 'package:gloria_finance/core/utils/app_localizations_ext.dart';
import 'package:gloria_finance/features/erp/settings/financial_concept/models/financial_concept_model.dart';
import 'package:gloria_finance/features/erp/settings/financial_concept/pages/financial_concept_list/widgets/financial_concept_pix_dialog.dart';
import 'package:gloria_finance/features/erp/settings/financial_concept/store/financial_concept_store.dart';

enum _FinancialConceptAction { edit, pix }

class FinancialConceptActionsMenu extends StatefulWidget {
  final FinancialConceptModel concept;
  final FinancialConceptStore store;
  final VoidCallback onEdit;
  final bool showPixAction;

  const FinancialConceptActionsMenu({
    super.key,
    required this.concept,
    required this.store,
    required this.onEdit,
    required this.showPixAction,
  });

  @override
  State<FinancialConceptActionsMenu> createState() =>
      _FinancialConceptActionsMenuState();
}

class _FinancialConceptActionsMenuState
    extends State<FinancialConceptActionsMenu> {
  final GlobalKey _buttonKey = GlobalKey();

  bool get _isCreatingPix =>
      widget.store.state.creatingPixForConceptId ==
      widget.concept.financialConceptId;

  Future<void> _showMenu() async {
    final buttonObject = _buttonKey.currentContext?.findRenderObject();
    final overlayObject = Overlay.of(context).context.findRenderObject();

    if (buttonObject is! RenderBox || overlayObject is! RenderBox) {
      return;
    }

    final buttonRect = Rect.fromPoints(
      buttonObject.localToGlobal(Offset.zero, ancestor: overlayObject),
      buttonObject.localToGlobal(
        buttonObject.size.bottomRight(Offset.zero),
        ancestor: overlayObject,
      ),
    );
    final pixIsConfigured = widget.concept.pix != null;
    final selection = await showMenu<_FinancialConceptAction>(
      context: context,
      position: RelativeRect.fromRect(
        buttonRect,
        Offset.zero & overlayObject.size,
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      items: [
        PopupMenuItem<_FinancialConceptAction>(
          value: _FinancialConceptAction.edit,
          child: _FinancialConceptMenuItem(
            icon: Icons.edit_outlined,
            label: context.l10n.settings_financial_concept_action_edit,
          ),
        ),
        if (widget.showPixAction)
          PopupMenuItem<_FinancialConceptAction>(
            value: _FinancialConceptAction.pix,
            child: _FinancialConceptMenuItem(
              icon: Icons.qr_code_2_outlined,
              label:
                  pixIsConfigured
                      ? context.l10n.settings_financial_concept_pix_view_action
                      : context
                          .l10n
                          .settings_financial_concept_pix_create_action,
              highlighted: true,
            ),
          ),
      ],
    );

    if (!mounted || selection == null) return;

    switch (selection) {
      case _FinancialConceptAction.edit:
        widget.onEdit();
        break;
      case _FinancialConceptAction.pix:
        await _handlePixAction();
        break;
    }
  }

  Future<void> _handlePixAction() async {
    final pix = widget.concept.pix;
    if (pix != null) {
      await FinancialConceptPixDialog.show(
        context,
        conceptName: widget.concept.name,
        copyPaste: pix.copyPaste,
        encodedImage: pix.encodedImage,
      );
      return;
    }

    try {
      final createdPix = await widget.store.createStaticPix(
        widget.concept.financialConceptId,
      );
      if (!mounted) return;
      await FinancialConceptPixDialog.show(
        context,
        conceptName: widget.concept.name,
        copyPaste: createdPix.copyPaste,
        encodedImage: createdPix.encodedImage,
      );
      if (!mounted) return;
      await widget.store.searchFinancialConcepts();
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            context.l10n.settings_financial_concept_pix_creation_error,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      key: _buttonKey,
      onPressed: _isCreatingPix ? null : _showMenu,
      style: OutlinedButton.styleFrom(
        side: const BorderSide(color: AppColors.blue),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        minimumSize: const Size(44, 38),
        padding: const EdgeInsets.symmetric(horizontal: 8),
      ),
      child:
          _isCreatingPix
              ? const SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: AppColors.blue,
                ),
              )
              : const Icon(Icons.more_horiz, color: AppColors.blue),
    );
  }
}

class _FinancialConceptMenuItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool highlighted;

  const _FinancialConceptMenuItem({
    required this.icon,
    required this.label,
    this.highlighted = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 190,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      decoration:
          highlighted
              ? BoxDecoration(
                color: AppColors.purple.withValues(alpha: 0.10),
                borderRadius: BorderRadius.circular(8),
              )
              : null,
      child: Row(
        children: [
          Icon(icon, color: highlighted ? AppColors.purple : AppColors.blue),
          const SizedBox(width: 12),
          Text(
            label,
            style: TextStyle(
              fontFamily: AppFonts.fontSubTitle,
              fontSize: 14,
              color: highlighted ? AppColors.purple : Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}
