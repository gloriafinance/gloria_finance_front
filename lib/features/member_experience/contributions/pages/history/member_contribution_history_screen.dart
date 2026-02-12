import 'package:gloria_finance/core/theme/app_color.dart';
import 'package:gloria_finance/core/theme/app_fonts.dart';
import 'package:gloria_finance/core/utils/app_localizations_ext.dart';
import 'package:gloria_finance/core/utils/date_formatter.dart';
import 'package:gloria_finance/core/widgets/form_controls.dart';
import 'package:gloria_finance/features/member_experience/contributions/pages/history/widgets/contribution_empty_state.dart';
import 'package:gloria_finance/features/member_experience/contributions/pages/history/widgets/contribution_list.dart';
import 'package:gloria_finance/features/member_experience/contributions/store/member_contribution_history_store.dart';
import 'package:gloria_finance/features/member_experience/widgets/member_header.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class MemberContributionHistoryScreen extends StatelessWidget {
  const MemberContributionHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => MemberContributionHistoryStore(),
      child: Consumer<MemberContributionHistoryStore>(
        builder: (context, store, child) {
          return RefreshIndicator(
            onRefresh: () => store.fetchContributions(refresh: true),
            child: Stack(
              children: [
                Column(
                  children: [
                    MemberHeaderWidget(
                      title: context.l10n.member_contribution_history_title,
                      showBackButton: false,
                    ),
                    _buildFilters(context, store),
                    Expanded(
                      child:
                          store.isLoading
                              ? const Center(child: CircularProgressIndicator())
                              : _buildHistoryList(store),
                    ),
                  ],
                ),
                Positioned(
                  bottom: 26,
                  right: 16,
                  child: FloatingActionButton.extended(
                    onPressed: () => context.push('/member/contribute/new'),
                    label: Text(
                      context.l10n.member_contribution_new_button,
                      style: const TextStyle(
                        color: Colors.white,
                        fontFamily: AppFonts.fontText,
                      ),
                    ),
                    icon: const Icon(Icons.add, color: Colors.white),
                    backgroundColor: AppColors.purple,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildFilters(
    BuildContext context,
    MemberContributionHistoryStore store,
  ) {
    final l10n = context.l10n;
    final typeOptions = {
      'ALL': l10n.member_contribution_filter_type_all,
      'TITHE': l10n.member_contribution_type_tithe,
      'OFFERING': l10n.member_contribution_type_offering,
    };

    return Container(
      color: Colors.white,
      child: ExpansionTile(
        title: Text(
          l10n.common_filters,
          style: const TextStyle(
            fontFamily: AppFonts.fontTitle,
            fontWeight: FontWeight.bold,
            color: AppColors.purple,
          ),
        ),
        iconColor: AppColors.purple,
        childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        children: [
          Row(
            children: [
              Expanded(
                child: Input(
                  label: l10n.common_start_date,
                  initialValue: DateFormat(
                    'dd/MM/yyyy',
                  ).format(store.startDate),
                  onChanged: (_) {},
                  readOnly: true,
                  onTap: () async {
                    final picked = await selectDate(
                      context,
                      initialDate: store.startDate,
                    );
                    if (picked != null) store.setStartDate(picked);
                  },
                  iconRight: const Icon(
                    Icons.calendar_today,
                    color: AppColors.purple,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Input(
                  label: l10n.common_end_date,
                  initialValue: DateFormat('dd/MM/yyyy').format(store.endDate),
                  onChanged: (_) {},
                  readOnly: true,
                  onTap: () async {
                    final picked = await selectDate(
                      context,
                      initialDate: store.endDate,
                    );
                    if (picked != null) store.setEndDate(picked);
                  },
                  iconRight: const Icon(
                    Icons.calendar_today,
                    color: AppColors.purple,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          DropdownButtonFormField<String>(
            isExpanded: true,
            decoration: InputDecoration(
              labelText: l10n.member_contribution_filter_type_label,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.grey.shade400),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.grey.shade400),
              ),
              focusedBorder: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(8)),
                borderSide: BorderSide(color: AppColors.purple, width: 2),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 16,
              ),
            ),
            value: typeOptions[store.type],
            items:
                typeOptions.values.map((value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(
                      value,
                      style: const TextStyle(
                        fontSize: 16,
                        color: AppColors.black,
                        fontFamily: AppFonts.fontText,
                      ),
                    ),
                  );
                }).toList(),
            onChanged: (value) {
              if (value != null) {
                final match = typeOptions.entries.firstWhere(
                  (entry) => entry.value == value,
                  orElse: () => typeOptions.entries.first,
                );
                store.setType(match.key);
              }
            },
            icon: const Icon(Icons.arrow_drop_down, color: AppColors.purple),
            dropdownColor: Colors.white,
          ),
        ],
      ),
    );
  }

  Widget _buildHistoryList(MemberContributionHistoryStore store) {
    if (store.contributions.isEmpty) {
      return const ContributionEmptyState();
    }

    return ContributionList(store: store);
  }
}
