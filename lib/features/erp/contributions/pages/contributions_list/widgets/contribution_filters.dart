import 'package:gloria_finance/core/theme/app_color.dart';
import 'package:gloria_finance/core/theme/app_fonts.dart';
import 'package:gloria_finance/core/utils/app_localizations_ext.dart';
import 'package:gloria_finance/core/utils/index.dart';
import 'package:gloria_finance/core/widgets/button_acton_table.dart';
import 'package:gloria_finance/core/widgets/form_controls.dart';
import 'package:gloria_finance/features/erp/contributions/models/contribution_model.dart';
import 'package:gloria_finance/features/erp/settings/members/models/member_model.dart';
import 'package:gloria_finance/features/erp/settings/members/store/member_all_store.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../helpers/contribution.helper.dart';
import '../../../store/contribution_pagination_store.dart';

class ContributionFilters extends StatefulWidget {
  const ContributionFilters({super.key});

  @override
  State<ContributionFilters> createState() => _ContributionFiltersState();
}

class _ContributionFiltersState extends State<ContributionFilters> {
  bool isExpandedFilter = false;

  @override
  Widget build(BuildContext context) {
    final contributionStore = context.watch<ContributionPaginationStore>();
    final memberStore = context.watch<MemberAllStore>();

    return isMobile(context)
        ? _layoutMobile(contributionStore, memberStore)
        : _layoutDesktop(contributionStore, memberStore);
  }

  Widget _layoutMobile(
    ContributionPaginationStore contributionStore,
    MemberAllStore memberStore,
  ) {
    final l10n = context.l10n;

    return Container(
      margin: const EdgeInsets.only(top: 10.0),
      child: ExpansionPanelList(
        expansionCallback: (int index, bool isExpanded) {
          isExpandedFilter = !isExpanded;
          setState(() {});
        },
        animationDuration: const Duration(milliseconds: 500),
        children: [
          ExpansionPanel(
            canTapOnHeader: true,
            isExpanded: isExpandedFilter,
            headerBuilder: (context, isOpen) {
              return ListTile(
                title: Text(
                  l10n.common_filters_upper,
                  style: TextStyle(
                    fontSize: 16,
                    fontFamily: AppFonts.fontTitle,
                    color: AppColors.purple,
                  ),
                ),
              );
            },
            body: Column(
              children: [
                Row(children: [Expanded(child: _dropdownStatus(contributionStore))]),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: _dropdownMember(contributionStore, memberStore),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(child: _dateStart(contributionStore)),
                    const SizedBox(width: 10),
                    Expanded(child: _dateEnd(contributionStore)),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(child: _clearButton(contributionStore)),
                    const SizedBox(width: 10),
                    Expanded(child: _buttonApplyFilter(contributionStore)),
                  ],
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _layoutDesktop(
    ContributionPaginationStore contributionStore,
    MemberAllStore memberStore,
  ) {
    return Container(
      margin: const EdgeInsets.only(top: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(flex: 1, child: _dropdownStatus(contributionStore)),
              const SizedBox(width: 10),
              Expanded(
                flex: 2,
                child: _dropdownMember(contributionStore, memberStore),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(flex: 1, child: _dateStart(contributionStore)),
              const SizedBox(width: 10),
              Expanded(flex: 1, child: _dateEnd(contributionStore)),
              const SizedBox(width: 10),
              const Expanded(flex: 2, child: SizedBox()),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              _clearButton(contributionStore),
              const SizedBox(width: 12),
              _buttonApplyFilter(contributionStore),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buttonApplyFilter(ContributionPaginationStore contributionStore) {
    final isLoading = contributionStore.state.makeRequest;
    final l10n = context.l10n;

    return ButtonActionTable(
      color: AppColors.blue,
      text: isLoading ? l10n.common_loading : l10n.common_apply_filters,
      icon: isLoading ? Icons.hourglass_bottom : Icons.search,
      onPressed: () {
        if (!isLoading) {
          isExpandedFilter = false;
          setState(() {});
          contributionStore.apply();
        }
      },
    );
  }

  Widget _clearButton(ContributionPaginationStore contributionStore) {
    return ButtonActionTable(
      icon: Icons.clear,
      color: AppColors.mustard,
      text: context.l10n.common_clear_filters,
      onPressed: () => contributionStore.clearFilters(),
    );
  }

  Widget _dropdownStatus(ContributionPaginationStore contributionStore) {
    final statuses = ContributionStatus.values;
    final List<String> labels =
        statuses
            .map(
              (status) => getContributionStatusLabel(context, status),
            )
            .toList(growable: false);

    final status = contributionStore.state.filter.status;
    final selectedStatus =
        status != null && status.isNotEmpty
            ? getContributionStatusLabel(context, parseContributionStatus(status))
            : null;

    return Dropdown(
      label: context.l10n.common_status,
      items: labels,
      initialValue: selectedStatus,
      onChanged: (value) {
        final index = labels.indexOf(value);
        if (index >= 0) {
          contributionStore.setStatus(statuses[index]);
        }
      },
    );
  }

  Widget _dropdownMember(
    ContributionPaginationStore contributionStore,
    MemberAllStore memberStore,
  ) {
    final allLabel = context.l10n.settings_financial_concept_filter_all;
    final members = memberStore.getMembers();
    final memberLabels = members.map(_memberLabel).toList(growable: false);
    final items = [allLabel, ...memberLabels];

    final selectedMemberId = contributionStore.state.filter.memberId;
    String selectedMemberLabel = allLabel;

    if (selectedMemberId != null && selectedMemberId.isNotEmpty) {
      for (final member in members) {
        if (member.memberId == selectedMemberId) {
          selectedMemberLabel = _memberLabel(member);
          break;
        }
      }
    }

    return Dropdown(
      label: context.l10n.accountsReceivable_form_field_member,
      items: items,
      initialValue: selectedMemberLabel,
      onChanged: (value) {
        if (value == allLabel) {
          contributionStore.setMemberFilter(null);
          return;
        }

        for (final member in members) {
          if (_memberLabel(member) == value) {
            contributionStore.setMemberFilter(member.memberId);
            return;
          }
        }
      },
    );
  }

  Widget _dateStart(ContributionPaginationStore contributionStore) {
    final selectedDate = _formatDateForDisplay(
      contributionStore.state.filter.startDate,
    );

    return Input(
      label: context.l10n.common_start_date,
      initialValue: selectedDate,
      readOnly: true,
      onChanged: (_) {},
      onTap: () {
        selectDate(
          context,
          initialDate: _parseDate(contributionStore.state.filter.startDate),
        ).then((picked) {
          if (picked == null) return;
          contributionStore.setStartDate(picked.toIso8601String());
        });
      },
    );
  }

  Widget _dateEnd(ContributionPaginationStore contributionStore) {
    final selectedDate = _formatDateForDisplay(
      contributionStore.state.filter.endDate,
    );

    return Input(
      label: context.l10n.common_end_date,
      initialValue: selectedDate,
      readOnly: true,
      onChanged: (_) {},
      onTap: () {
        selectDate(
          context,
          initialDate: _parseDate(contributionStore.state.filter.endDate),
        ).then((picked) {
          if (picked == null) return;
          contributionStore.setEndDate(picked.toIso8601String());
        });
      },
    );
  }

  DateTime _parseDate(String? date) {
    if (date == null || date.trim().isEmpty) {
      return DateTime.now();
    }
    return DateTime.tryParse(date) ?? DateTime.now();
  }

  String _formatDateForDisplay(String? date) {
    if (date == null || date.trim().isEmpty) {
      return '';
    }

    try {
      final normalized = date.length >= 10 ? date.substring(0, 10) : date;
      return convertDateFormatToDDMMYYYY(normalized);
    } catch (_) {
      return '';
    }
  }

  String _memberLabel(MemberModel member) {
    final dni = member.dni.trim();
    if (dni.isEmpty) return member.name;
    return '${member.name} - $dni';
  }
}
