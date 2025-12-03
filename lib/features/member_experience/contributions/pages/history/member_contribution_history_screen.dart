import 'package:church_finance_bk/core/theme/app_color.dart';
import 'package:church_finance_bk/core/theme/app_fonts.dart';
import 'package:church_finance_bk/core/utils/date_formatter.dart';
import 'package:church_finance_bk/core/widgets/form_controls.dart';
import 'package:church_finance_bk/core/widgets/loading.dart';
import 'package:church_finance_bk/features/member_experience/contributions/pages/history/widgets/contribution_empty_state.dart';
import 'package:church_finance_bk/features/member_experience/contributions/pages/history/widgets/contribution_list.dart';
import 'package:church_finance_bk/features/member_experience/contributions/store/member_contribution_history_store.dart';
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
          if (store.isLoading && store.contributions.isEmpty) {
            return const Center(child: Loading());
          }

          return Stack(
            children: [
              Column(
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    decoration: const BoxDecoration(
                      color: AppColors.purple,
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Histórico de contribuições',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: AppFonts.fontTitle,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ),
                  _buildFilters(context, store),
                  Expanded(child: _buildHistoryList(store)),
                ],
              ),
              Positioned(
                bottom: 16,
                right: 16,
                child: FloatingActionButton.extended(
                  onPressed: () => context.push('/member/contribute/new'),
                  label: const Text(
                    'Nova Contribuição',
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: AppFonts.fontText,
                    ),
                  ),
                  icon: const Icon(Icons.add, color: Colors.white),
                  backgroundColor: AppColors.purple,
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildFilters(
    BuildContext context,
    MemberContributionHistoryStore store,
  ) {
    return Container(
      color: Colors.white,
      child: ExpansionTile(
        title: const Text(
          'Filtros',
          style: TextStyle(
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
                  label: 'Data Inicial',
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
                  label: 'Data Final',
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
          Dropdown(
            label: 'Tipo',
            items: const ['Todos', 'Dízimo', 'Oferta'],
            initialValue: store.type,
            onChanged: store.setType,
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
