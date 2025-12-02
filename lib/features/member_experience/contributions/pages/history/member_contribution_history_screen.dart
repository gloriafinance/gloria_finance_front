import 'package:church_finance_bk/core/theme/app_color.dart';
import 'package:church_finance_bk/core/theme/app_fonts.dart';
import 'package:church_finance_bk/core/utils/date_formatter.dart';
import 'package:church_finance_bk/core/widgets/form_controls.dart';
import 'package:church_finance_bk/core/widgets/loading.dart';
import 'package:church_finance_bk/features/member_experience/contributions/pages/history/widgets/contribution_history_item.dart';
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
                    style: TextStyle(color: Colors.white),
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
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.history, size: 64, color: Colors.grey.shade400),
            const SizedBox(height: 16),
            Text(
              'Nenhuma contribuição encontrada',
              style: TextStyle(
                fontFamily: AppFonts.fontText,
                fontSize: 16,
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ),
      );
    }

    final grouped = store.groupedContributions;

    return ListView.builder(
      itemCount: grouped.length + (store.nextPag != null ? 1 : 0),
      itemBuilder: (context, index) {
        if (index == grouped.length) {
          // Load more button or indicator
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Center(
              child:
                  store.isLoading
                      ? const Loading()
                      : TextButton(
                        onPressed: store.loadMore,
                        child: const Text('Carregar mais'),
                      ),
            ),
          );
        }

        final monthKey = grouped.keys.elementAt(index);
        final contributions = grouped[monthKey]!;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 12, top: 8),
              child: Text(
                monthKey,
                style: TextStyle(
                  fontFamily: AppFonts.fontSubTitle,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey.shade700,
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.shade200,
                    offset: const Offset(0, 2),
                    blurRadius: 8,
                  ),
                ],
              ),
              child: Column(
                children:
                    contributions.map((contribution) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: ContributionHistoryItem(
                          contribution: contribution,
                        ),
                      );
                    }).toList(),
              ),
            ),
            const SizedBox(height: 24),
          ],
        );
      },
    );
  }
}
