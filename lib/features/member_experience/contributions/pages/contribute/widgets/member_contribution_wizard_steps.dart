import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:gloria_finance/core/theme/app_color.dart';
import 'package:gloria_finance/core/theme/app_fonts.dart';
import 'package:gloria_finance/core/utils/app_localizations_ext.dart';
import 'package:gloria_finance/core/utils/currency_formatter.dart';
import 'package:gloria_finance/core/utils/date_formatter.dart';
import 'package:gloria_finance/core/widgets/form_controls.dart';
import 'package:gloria_finance/features/erp/settings/financial_concept/models/financial_concept_model.dart';
import 'package:gloria_finance/features/member_experience/contributions/models/member_contribution_models.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

const _cardBorder = Color(0xFFE8E5EF);
const _mutedPurple = Color(0xFF6A48A0);
const _softPurple = Color(0xFFF0EAFB);

String formatContributionAmount(double? amount) {
  if (amount == null) return 'R\$ 0';
  return NumberFormat.currency(
    locale: 'pt_BR',
    symbol: 'R\$ ',
    decimalDigits: 0,
  ).format(amount);
}

class ContributionStepProgress extends StatelessWidget {
  final int currentStep;
  final int totalSteps;

  const ContributionStepProgress({
    super.key,
    required this.currentStep,
    required this.totalSteps,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          context.l10n.member_contribution_step_label(currentStep, totalSteps),
          style: const TextStyle(
            fontFamily: AppFonts.fontTitle,
            fontSize: 15,
            color: AppColors.purple,
          ),
        ),
        const SizedBox(height: 14),
        Row(
          children: List.generate(totalSteps, (index) {
            final isActive = index + 1 == currentStep;
            final isCompleted = index + 1 < currentStep;
            return Expanded(
              child: Container(
                height: 7,
                margin: EdgeInsets.only(right: index == totalSteps - 1 ? 0 : 8),
                decoration: BoxDecoration(
                  color:
                      isActive || isCompleted
                          ? AppColors.purple
                          : Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            );
          }),
        ),
      ],
    );
  }
}

class ContributionStepHeader extends StatelessWidget {
  final String title;
  final String subtitle;

  const ContributionStepHeader({
    super.key,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          title,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontFamily: AppFonts.fontTitle,
            fontSize: 24,
            height: 1.18,
            color: AppColors.purple,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          subtitle,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontFamily: AppFonts.fontSubTitle,
            fontSize: 14,
            height: 1.3,
            color: _mutedPurple,
          ),
        ),
      ],
    );
  }
}

class SelectedAmountSummary extends StatelessWidget {
  final double? amount;

  const SelectedAmountSummary({super.key, required this.amount});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: _cardBorder),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              context.l10n.member_contribution_selected_value_label,
              style: const TextStyle(
                fontFamily: AppFonts.fontSubTitle,
                fontSize: 14,
                color: _mutedPurple,
              ),
            ),
          ),
          Text(
            amount == null ? '-' : formatContributionAmount(amount),
            style: const TextStyle(
              fontFamily: AppFonts.fontTitle,
              fontSize: 21,
              color: AppColors.purple,
            ),
          ),
        ],
      ),
    );
  }
}

class ContributionTypeStep extends StatelessWidget {
  final MemberContributionType? selectedType;
  final ValueChanged<MemberContributionType> onTypeSelected;
  final List<FinancialConceptModel> offeringConcepts;
  final String? selectedConceptId;
  final ValueChanged<String> onConceptSelected;

  const ContributionTypeStep({
    super.key,
    required this.selectedType,
    required this.onTypeSelected,
    required this.offeringConcepts,
    required this.selectedConceptId,
    required this.onConceptSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _ContributionTypeCard(
                label: context.l10n.member_contribution_type_offering,
                icon: Icons.favorite,
                isSelected: selectedType == MemberContributionType.offering,
                onTap: () => onTypeSelected(MemberContributionType.offering),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _ContributionTypeCard(
                label: context.l10n.member_contribution_type_tithe,
                icon: Icons.church,
                isSelected: selectedType == MemberContributionType.tithe,
                onTap: () => onTypeSelected(MemberContributionType.tithe),
              ),
            ),
          ],
        ),
        if (selectedType == MemberContributionType.offering) ...[
          const SizedBox(height: 28),
          _OfferingConceptSelector(
            concepts: offeringConcepts,
            selectedConceptId: selectedConceptId,
            onConceptSelected: onConceptSelected,
          ),
        ],
      ],
    );
  }
}

class _ContributionTypeCard extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const _ContributionTypeCard({
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        SizedBox(
          width: double.infinity,
          height: 106,
          child: Material(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            child: InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: onTap,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isSelected ? AppColors.purple : _cardBorder,
                    width: isSelected ? 1.5 : 1,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: const BoxDecoration(
                        color: AppColors.purple,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(icon, color: Colors.white, size: 24),
                    ),
                    const SizedBox(height: 11),
                    Text(
                      label,
                      style: const TextStyle(
                        fontFamily: AppFonts.fontTitle,
                        fontSize: 16,
                        color: AppColors.black,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        if (isSelected)
          const Positioned(
            top: -8,
            right: -8,
            child: CircleAvatar(
              radius: 13,
              backgroundColor: AppColors.purple,
              child: Icon(Icons.check, size: 17, color: Colors.white),
            ),
          ),
      ],
    );
  }
}

class _OfferingConceptSelector extends StatelessWidget {
  final List<FinancialConceptModel> concepts;
  final String? selectedConceptId;
  final ValueChanged<String> onConceptSelected;

  const _OfferingConceptSelector({
    required this.concepts,
    required this.selectedConceptId,
    required this.onConceptSelected,
  });

  @override
  Widget build(BuildContext context) {
    if (concepts.isEmpty) {
      return _ContributionHint(
        text:
            context
                .l10n
                .member_contribution_validator_financial_concept_required,
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          context.l10n.member_contribution_offering_type_title,
          style: const TextStyle(
            fontFamily: AppFonts.fontTitle,
            fontSize: 17,
            color: AppColors.purple,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          context.l10n.member_contribution_offering_type_subtitle,
          style: const TextStyle(
            fontFamily: AppFonts.fontSubTitle,
            fontSize: 13,
            color: _mutedPurple,
          ),
        ),
        const SizedBox(height: 14),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: concepts.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 12,
            crossAxisSpacing: 14,
            childAspectRatio: 1.35,
          ),
          itemBuilder: (context, index) {
            final concept = concepts[index];
            return _OfferingConceptCard(
              label: _conceptLabel(concept.name),
              icon: _conceptIcon(concept.name, index),
              isSelected: selectedConceptId == concept.financialConceptId,
              onTap: () => onConceptSelected(concept.financialConceptId),
            );
          },
        ),
        const SizedBox(height: 14),
        _ContributionHint(
          text:
              selectedConceptId == null
                  ? context.l10n.member_contribution_offering_type_hint
                  : context
                      .l10n
                      .member_contribution_offering_type_selected_hint,
        ),
      ],
    );
  }

  String _conceptLabel(String name) {
    final trimmed = name.trim();
    if (trimmed.isEmpty) return name;
    return trimmed;
  }

  IconData _conceptIcon(String name, int index) {
    final normalized = name.toLowerCase();
    if (normalized.contains('miss') ||
        normalized.contains('mis') ||
        normalized.contains('evangel')) {
      return Icons.language;
    }
    if (normalized.contains('constru') || normalized.contains('obra')) {
      return Icons.church;
    }
    if (normalized.contains('gracia') ||
        normalized.contains('graça') ||
        normalized.contains('gratid')) {
      return Icons.favorite;
    }
    if (normalized.contains('famil')) {
      return Icons.family_restroom;
    }
    if (normalized.contains('jov') ||
        normalized.contains('juven') ||
        normalized.contains('youth')) {
      return Icons.diversity_3;
    }
    if (normalized.contains('crian') ||
        normalized.contains('niñ') ||
        normalized.contains('infant')) {
      return Icons.child_care;
    }
    if (normalized.contains('social') ||
        normalized.contains('assist') ||
        normalized.contains('ajuda') ||
        normalized.contains('ayuda')) {
      return Icons.volunteer_activism;
    }
    if (normalized.contains('mus') ||
        normalized.contains('louvor') ||
        normalized.contains('ador')) {
      return Icons.music_note;
    }
    if (normalized.contains('educ') ||
        normalized.contains('ensino') ||
        normalized.contains('estudio')) {
      return Icons.school;
    }
    if (normalized.contains('especial') || normalized.contains('campanha')) {
      return Icons.stars;
    }

    const fallbackIcons = <IconData>[
      Icons.favorite,
      Icons.church,
      Icons.volunteer_activism,
      Icons.groups,
      Icons.family_restroom,
      Icons.diversity_3,
      Icons.child_care,
      Icons.music_note,
      Icons.school,
      Icons.celebration,
    ];

    return fallbackIcons[index % fallbackIcons.length];
  }
}

class _OfferingConceptCard extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const _OfferingConceptCard({
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: Material(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            child: InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: onTap,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isSelected ? AppColors.purple : _cardBorder,
                    width: isSelected ? 1.5 : 1,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.04),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(icon, color: AppColors.purple, size: 27),
                    const SizedBox(height: 8),
                    Text(
                      label,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontFamily: AppFonts.fontTitle,
                        fontSize: 12.5,
                        height: 1.18,
                        color: AppColors.black,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        if (isSelected)
          const Positioned(
            top: -9,
            right: -9,
            child: CircleAvatar(
              radius: 13,
              backgroundColor: AppColors.purple,
              child: Icon(Icons.check, size: 17, color: Colors.white),
            ),
          ),
      ],
    );
  }
}

class _ContributionHint extends StatelessWidget {
  final String text;

  const _ContributionHint({required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
      decoration: BoxDecoration(
        color: _softPurple,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          const Icon(Icons.info_outline, color: AppColors.purple, size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontFamily: AppFonts.fontSubTitle,
                fontSize: 13,
                height: 1.3,
                color: AppColors.purple,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ContributionAmountStep extends StatelessWidget {
  final double? selectedAmount;
  final List<double> quickAmounts;
  final bool isCustomAmountSelected;
  final ValueChanged<double> onQuickAmountSelected;
  final ValueChanged<double> onCustomAmountChanged;
  final VoidCallback onCustomAmountSelected;

  const ContributionAmountStep({
    super.key,
    required this.selectedAmount,
    required this.quickAmounts,
    required this.isCustomAmountSelected,
    required this.onQuickAmountSelected,
    required this.onCustomAmountChanged,
    required this.onCustomAmountSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          childAspectRatio: 1.65,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          children: [
            ...quickAmounts.map((amount) {
              return _AmountCard(
                label: formatContributionAmount(amount),
                isSelected: selectedAmount == amount && !isCustomAmountSelected,
                onTap: () => onQuickAmountSelected(amount),
              );
            }),
            _AmountCard(
              label: context.l10n.member_contribution_amount_other,
              icon: Icons.edit_outlined,
              isSelected: isCustomAmountSelected,
              onTap: onCustomAmountSelected,
            ),
          ],
        ),
        if (isCustomAmountSelected) ...[
          const SizedBox(height: 6),
          Input(
            label: context.l10n.member_contribution_value_label,
            initialValue:
                selectedAmount != null
                    ? CurrencyFormatter.formatCurrency(
                      selectedAmount!,
                      symbol: 'R\$',
                    )
                    : '',
            keyboardType: TextInputType.number,
            inputFormatters: [CurrencyFormatter.getInputFormatters('R\$')],
            onChanged: (value) {
              if (value.isEmpty) return;
              try {
                final amount = CurrencyFormatter.cleanCurrency(value);
                if (amount > 0) {
                  onCustomAmountChanged(amount);
                }
              } catch (_) {
                // Invalid currency input is ignored while the user edits.
              }
            },
          ),
        ],
      ],
    );
  }
}

class _AmountCard extends StatelessWidget {
  final String label;
  final IconData? icon;
  final bool isSelected;
  final VoidCallback onTap;

  const _AmountCard({
    required this.label,
    this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final foreground = isSelected ? Colors.white : AppColors.purple;

    return Stack(
      children: [
        Material(
          color: isSelected ? AppColors.purple : Colors.white,
          borderRadius: BorderRadius.circular(14),
          child: InkWell(
            borderRadius: BorderRadius.circular(14),
            onTap: onTap,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: isSelected ? AppColors.purple : _cardBorder,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Center(
                child:
                    icon == null
                        ? Text(
                          label,
                          style: TextStyle(
                            fontFamily: AppFonts.fontTitle,
                            fontSize: 21,
                            color: foreground,
                          ),
                        )
                        : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Flexible(
                              child: Text(
                                label,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontFamily: AppFonts.fontTitle,
                                  fontSize: 15,
                                  color: foreground,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Icon(icon, color: foreground, size: 30),
                          ],
                        ),
              ),
            ),
          ),
        ),
        if (isSelected)
          const Positioned(
            top: 9,
            right: 9,
            child: CircleAvatar(
              radius: 13,
              backgroundColor: Colors.white,
              child: Icon(Icons.check, color: AppColors.purple, size: 18),
            ),
          ),
      ],
    );
  }
}

class ContributionDateStep extends StatelessWidget {
  final DateTime? selectedDate;
  final ValueChanged<DateTime> onDateSelected;

  const ContributionDateStep({
    super.key,
    required this.selectedDate,
    required this.onDateSelected,
  });

  @override
  Widget build(BuildContext context) {
    final today = DateTime.now();
    final yesterday = today.subtract(const Duration(days: 1));

    return Column(
      children: [
        _DateOptionCard(
          label: context.l10n.member_contribution_date_today,
          icon: Icons.calendar_month_outlined,
          isSelected: _sameDate(selectedDate, today),
          onTap:
              () =>
                  onDateSelected(DateTime(today.year, today.month, today.day)),
        ),
        const SizedBox(height: 12),
        _DateOptionCard(
          label: context.l10n.member_contribution_date_yesterday,
          icon: Icons.event_repeat_outlined,
          isSelected: _sameDate(selectedDate, yesterday),
          onTap:
              () => onDateSelected(
                DateTime(yesterday.year, yesterday.month, yesterday.day),
              ),
        ),
        const SizedBox(height: 12),
        _DateOptionCard(
          label: context.l10n.member_contribution_date_choose,
          icon: Icons.calendar_today_outlined,
          isSelected:
              selectedDate != null &&
              !_sameDate(selectedDate, today) &&
              !_sameDate(selectedDate, yesterday),
          onTap: () async {
            final picked = await selectDate(context, initialDate: selectedDate);
            if (picked != null) {
              onDateSelected(DateTime(picked.year, picked.month, picked.day));
            }
          },
        ),
      ],
    );
  }

  bool _sameDate(DateTime? a, DateTime b) {
    if (a == null) return false;
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }
}

class _DateOptionCard extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const _DateOptionCard({
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: isSelected ? AppColors.purple : _cardBorder,
              width: isSelected ? 1.5 : 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: const BoxDecoration(
                  color: _softPurple,
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: AppColors.purple, size: 26),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  label,
                  style: const TextStyle(
                    fontFamily: AppFonts.fontTitle,
                    fontSize: 18,
                    color: AppColors.purple,
                  ),
                ),
              ),
              const Icon(
                Icons.chevron_right,
                color: AppColors.purple,
                size: 31,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ContributionReceiptStep extends StatefulWidget {
  final String? fileName;
  final ValueChanged<MultipartFile> onFileSelected;
  final VoidCallback onFileRemoved;

  const ContributionReceiptStep({
    super.key,
    required this.fileName,
    required this.onFileSelected,
    required this.onFileRemoved,
  });

  @override
  State<ContributionReceiptStep> createState() =>
      _ContributionReceiptStepState();
}

class _ContributionReceiptStepState extends State<ContributionReceiptStep> {
  final ImagePicker _picker = ImagePicker();
  Uint8List? _selectedBytes;
  String? _selectedName;

  @override
  void didUpdateWidget(covariant ContributionReceiptStep oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.fileName == null && oldWidget.fileName != null) {
      _selectedBytes = null;
      _selectedName = null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        DottedBorder(
          borderType: BorderType.RRect,
          radius: const Radius.circular(18),
          dashPattern: const [8, 5],
          color: AppColors.purple,
          strokeWidth: 1.5,
          child: Material(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            child: InkWell(
              borderRadius: BorderRadius.circular(18),
              onTap: _selectImage,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 28,
                ),
                child: Column(
                  children: [
                    Container(
                      width: 92,
                      height: 92,
                      decoration: const BoxDecoration(
                        color: _softPurple,
                        shape: BoxShape.circle,
                      ),
                      child:
                          _selectedBytes == null
                              ? const Icon(
                                Icons.image_outlined,
                                color: AppColors.purple,
                                size: 47,
                              )
                              : ClipOval(
                                child: Image.memory(
                                  _selectedBytes!,
                                  fit: BoxFit.cover,
                                ),
                              ),
                    ),
                    const SizedBox(height: 15),
                    Text(
                      context.l10n.member_contribution_receipt_select_photo,
                      style: const TextStyle(
                        fontFamily: AppFonts.fontTitle,
                        fontSize: 19,
                        color: AppColors.purple,
                      ),
                    ),
                    const SizedBox(height: 7),
                    Text(
                      context.l10n.member_contribution_receipt_formats,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontFamily: AppFonts.fontSubTitle,
                        fontSize: 13,
                        color: _mutedPurple,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        if (_selectedName != null || widget.fileName != null) ...[
          const SizedBox(height: 12),
          _SelectedReceiptCard(
            fileName: _selectedName ?? widget.fileName ?? 'receipt.jpg',
            onRemove: _removeImage,
          ),
        ],
      ],
    );
  }

  Future<void> _selectImage() async {
    try {
      final picked = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1600,
        maxHeight: 1600,
        imageQuality: 90,
      );
      if (picked == null) return;

      final bytes = await picked.readAsBytes();
      final fileName = picked.name.isNotEmpty ? picked.name : 'receipt.jpg';
      final multipartFile = MultipartFile.fromBytes(bytes, filename: fileName);

      setState(() {
        _selectedBytes = bytes;
        _selectedName = fileName;
      });
      widget.onFileSelected(multipartFile);
    } catch (_) {
      // Keep the UI quiet and let the user retry.
    }
  }

  void _removeImage() {
    setState(() {
      _selectedBytes = null;
      _selectedName = null;
    });
    widget.onFileRemoved();
  }
}

class _SelectedReceiptCard extends StatelessWidget {
  final String fileName;
  final VoidCallback onRemove;

  const _SelectedReceiptCard({required this.fileName, required this.onRemove});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _cardBorder),
      ),
      child: Row(
        children: [
          const Icon(Icons.check_circle, color: AppColors.green, size: 22),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              fileName,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontFamily: AppFonts.fontSubTitle,
                fontSize: 13,
                color: AppColors.black,
              ),
            ),
          ),
          IconButton(
            onPressed: onRemove,
            icon: const Icon(Icons.close, color: AppColors.grey),
          ),
        ],
      ),
    );
  }
}

class ContributionPrimaryButton extends StatelessWidget {
  final String text;
  final IconData icon;
  final VoidCallback? onPressed;

  const ContributionPrimaryButton({
    super.key,
    required this.text,
    required this.icon,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 58,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.purple,
          disabledBackgroundColor: AppColors.purple.withValues(alpha: 0.38),
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          elevation: 4,
          shadowColor: AppColors.purple.withValues(alpha: 0.25),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Flexible(
              child: Text(
                text,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontFamily: AppFonts.fontTitle,
                  fontSize: 18,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(width: 18),
            Icon(icon, color: Colors.white, size: 25),
          ],
        ),
      ),
    );
  }
}
