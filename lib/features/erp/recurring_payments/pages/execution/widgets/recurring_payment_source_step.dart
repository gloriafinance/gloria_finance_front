import 'package:flutter/material.dart';
import 'package:gloria_finance/core/theme/app_color.dart';
import 'package:gloria_finance/core/theme/app_fonts.dart';
import 'package:gloria_finance/core/utils/app_localizations_ext.dart';
import 'package:gloria_finance/core/widgets/custom_button.dart';

import '../../../models/recurring_payment_source_ui_model.dart';

class RecurringPaymentSourceStep extends StatelessWidget {
  const RecurringPaymentSourceStep({
    super.key,
    required this.sources,
    required this.isLoading,
    required this.selectedId,
    required this.onSelect,
    required this.onContinue,
    this.fillAvailableSpace = false,
  });

  final List<RecurringPaymentSourceUiModel> sources;
  final bool isLoading;
  final String? selectedId;
  final ValueChanged<RecurringPaymentSourceUiModel> onSelect;
  final VoidCallback onContinue;
  final bool fillAvailableSpace;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          l10n.recurringPaymentsExecution_source_description,
          style: const TextStyle(
            fontFamily: AppFonts.fontText,
            fontSize: 12.5,
            color: Color(0xFF5F5F5F),
          ),
        ),
        const SizedBox(height: 14),
        if (fillAvailableSpace)
          Expanded(child: _accountList(context))
        else
          _accountList(context),
        SizedBox(height: fillAvailableSpace ? 12 : 20),
        CustomButton(
          text: l10n.recurringPaymentsExecution_source_continue,
          backgroundColor: AppColors.green,
          disabledBackgroundColor: AppColors.green.withValues(alpha: 0.4),
          textColor: Colors.black,
          icon: Icons.arrow_forward,
          onPressed: selectedId == null ? null : onContinue,
        ),
      ],
    );
  }

  Widget _accountList(BuildContext context) {
    if (isLoading && sources.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }
    if (sources.isEmpty) {
      return Text(context.l10n.recurringPaymentsExecution_source_empty);
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final columns = constraints.maxWidth >= 500 ? 2 : 2;
        return GridView.builder(
          shrinkWrap: !fillAvailableSpace,
          physics:
              fillAvailableSpace
                  ? const ClampingScrollPhysics()
                  : const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: columns,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            mainAxisExtent: 82,
          ),
          itemCount: sources.length,
          itemBuilder: (context, index) {
            final source = sources[index];
            final selected = source.id == selectedId;
            return InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: () => onSelect(source),
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: selected ? const Color(0xFFEFF6FF) : Colors.white,
                  border: Border.all(
                    color: selected ? AppColors.blue : const Color(0xFFE4E7EC),
                    width: selected ? 1.5 : 1,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Row(
                    children: [
                      Icon(
                        source.isAsaas
                            ? Icons.account_balance
                            : Icons.account_balance_wallet_outlined,
                        color: selected ? AppColors.blue : AppColors.grey,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              source.name,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontFamily: AppFonts.fontSubTitle,
                                fontSize: 12.5,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              source.subtitle,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontFamily: AppFonts.fontText,
                                fontSize: 11.5,
                                color: Color(0xFF667085),
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (selected)
                        const Icon(
                          Icons.check_circle,
                          color: AppColors.blue,
                          size: 19,
                        ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
