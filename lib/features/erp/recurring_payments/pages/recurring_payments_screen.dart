import 'package:flutter/material.dart';
import 'package:gloria_finance/core/theme/app_color.dart';
import 'package:gloria_finance/core/theme/app_fonts.dart';
import 'package:gloria_finance/core/utils/app_localizations_ext.dart';

import 'monthly/recurring_payment_monthly_view.dart';
import 'recurring_payment_list/recurring_payment_list_screen.dart';

/// Módulo de pagamentos recorrentes com duas abas:
///
/// - **Mês**: a execução mensal (o que vence, o que está pago e o que pagar).
/// - **Configuração**: o cadastro permanente (entregable anterior).
///
/// A competência é o eixo do trabalho do tesoureiro, então ela é a aba padrão.
class RecurringPaymentsScreen extends StatefulWidget {
  const RecurringPaymentsScreen({super.key, this.initialTab = 0});

  final int initialTab;

  @override
  State<RecurringPaymentsScreen> createState() =>
      _RecurringPaymentsScreenState();
}

class _RecurringPaymentsScreenState extends State<RecurringPaymentsScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _controller = TabController(
    length: 2,
    initialIndex: widget.initialTab,
    vsync: this,
  );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 40,
          child: TabBar(
            controller: _controller,
            isScrollable: true,
            indicatorColor: AppColors.purple,
            labelColor: AppColors.purple,
            unselectedLabelColor: AppColors.grey,
            labelStyle: const TextStyle(
              fontFamily: AppFonts.fontSubTitle,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
            unselectedLabelStyle: const TextStyle(
              fontFamily: AppFonts.fontSubTitle,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
            tabs: [
              Tab(text: l10n.recurringPaymentsExecution_tab_month),
              Tab(text: l10n.recurringPaymentsExecution_tab_configuration),
            ],
          ),
        ),
        const SizedBox(height: 19),
        // Sem TabBarView: o shell já envolve a tela em um scroll, e um
        // TabBarView exige altura limitada. A troca é feita pelo índice.
        AnimatedBuilder(
          animation: _controller,
          builder:
              (context, _) =>
                  _controller.index == 0
                      ? const RecurringPaymentMonthlyView()
                      : const RecurringPaymentListScreen(),
        ),
      ],
    );
  }
}
