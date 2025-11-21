import 'package:church_finance_bk/core/layout/layout_dashboard.dart';
import 'package:church_finance_bk/core/theme/app_color.dart';
import 'package:church_finance_bk/core/theme/app_fonts.dart';
import 'package:church_finance_bk/helpers/general.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'store/member_commitments_store.dart';
import 'widgets/member_commitments_filters.dart';
import 'widgets/member_commitments_table.dart';

class MemberCommitmentsScreen extends StatelessWidget {
  const MemberCommitmentsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => MemberCommitmentsStore()..initialize(),
      child: LayoutDashboard(
        _header(context),
        screen: Consumer<MemberCommitmentsStore>(
          builder: (context, store, _) {
            if (store.state.permissionDenied) {
              return _errorContainer(
                context,
                store.state.errorMessage ??
                    'Você não tem permissão para visualizar esta informação.',
                primaryLabel: 'Ir para início',
                primaryAction: () => GoRouter.of(context).go('/dashboard'),
              );
            }

            if (store.state.errorMessage != null && !store.state.isLoading) {
              return _errorContainer(
                context,
                store.state.errorMessage!,
                primaryLabel: 'Tentar novamente',
                primaryAction: () => store.fetchCommitments(),
              );
            }

            return const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [MemberCommitmentsFilters(), MemberCommitmentsTable()],
            );
          },
        ),
      ),
    );
  }

  Widget _header(BuildContext context) {
    final isMobileView = isMobile(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'Meus compromissos de contribuição',
                    style: TextStyle(
                      fontFamily: AppFonts.fontTitle,
                      fontSize: 20,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 6),
                  Text(
                    'Acompanhe seus compromissos com a igreja e declare pagamentos feitos por transferência.',
                    style: TextStyle(
                      fontFamily: AppFonts.fontSubTitle,
                      color: AppColors.grey,
                    ),
                  ),
                ],
              ),
            ),
            if (!isMobileView)
              TextButton.icon(
                onPressed: () => GoRouter.of(context).go('/dashboard'),
                icon: const Icon(Icons.home),
                label: const Text(
                  'Ir para início',
                  style: TextStyle(fontFamily: AppFonts.fontSubTitle),
                ),
              ),
          ],
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _errorContainer(
    BuildContext context,
    String message, {
    required String primaryLabel,
    required VoidCallback primaryAction,
  }) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(top: 20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.greyLight),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            message,
            style: const TextStyle(fontFamily: AppFonts.fontSubTitle),
          ),
          const SizedBox(height: 12),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.purple),
            onPressed: primaryAction,
            child: Text(
              primaryLabel,
              style: const TextStyle(
                fontFamily: AppFonts.fontSubTitle,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
