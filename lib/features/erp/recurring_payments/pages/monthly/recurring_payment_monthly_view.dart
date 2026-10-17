import 'package:flutter/material.dart';
import 'package:gloria_finance/core/widgets/loading.dart';
import 'package:gloria_finance/features/auth/pages/login/store/auth_session_store.dart';
import 'package:provider/provider.dart';

import '../../store/recurring_payment_monthly_store.dart';
import '../../store/recurring_payment_options_store.dart';
import 'widgets/recurring_payment_month_selector.dart';
import 'widgets/recurring_payment_monthly_cards.dart';
import 'widgets/recurring_payment_monthly_empty_state.dart';
import 'widgets/recurring_payment_monthly_summary.dart';
import 'widgets/recurring_payment_monthly_table.dart';

/// Execução mensal: o que vence na competência escolhida e o que já foi pago.
///
/// - Desktop (≥ 1024): tabela.
/// - Tablet (768–1023): duas colunas de tarjetas.
/// - Mobile (< 768): uma coluna de tarjetas, sem tabela.
class RecurringPaymentMonthlyView extends StatefulWidget {
  const RecurringPaymentMonthlyView({super.key});

  static const double desktopBreakpoint = 1024;

  @override
  State<RecurringPaymentMonthlyView> createState() =>
      _RecurringPaymentMonthlyViewState();
}

class _RecurringPaymentMonthlyViewState
    extends State<RecurringPaymentMonthlyView> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!mounted) return;

      // Tudo se lê antes de qualquer await, para não usar o context depois.
      final session = context.read<AuthSessionStore>().state.session;
      final store = context.read<RecurringPaymentMonthlyStore>();
      // Os nomes de conceito e centro de custo saem destas opções.
      final options = context.read<RecurringPaymentOptionsStore>();

      await store.load(churchId: session.churchId);

      if (await options.needsLoad(churchId: session.churchId)) {
        await options.searchOptions(churchId: session.churchId);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final session = context.watch<AuthSessionStore>().state.session;
    final state = context.watch<RecurringPaymentMonthlyStore>().state;
    final width = MediaQuery.of(context).size.width;
    final hasBanking = session.asaasConnect;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Só no desktop o seletor e o resumo cabem lado a lado.
        if (width >= RecurringPaymentMonthlyView.desktopBreakpoint)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              RecurringPaymentMonthlySummary(symbol: session.symbolFormatMoney),
              const RecurringPaymentMonthSelector(),
            ],
          )
        else ...[
          const RecurringPaymentMonthSelector(),
          const SizedBox(height: 12),
          RecurringPaymentMonthlySummary(symbol: session.symbolFormatMoney),
        ],
        const SizedBox(height: 16),
        if (state.isLoading && !state.hasItems)
          const Loading()
        else if (!state.hasItems)
          const RecurringPaymentMonthlyEmptyState()
        else if (width >= RecurringPaymentMonthlyView.desktopBreakpoint)
          RecurringPaymentMonthlyTable(
            items: state.items,
            symbolFormatMoney: session.symbolFormatMoney,
            hasBanking: hasBanking,
          )
        else
          RecurringPaymentMonthlyCards(
            items: state.items,
            symbolFormatMoney: session.symbolFormatMoney,
            hasBanking: hasBanking,
            columns: width >= 768 ? 2 : 1,
          ),
        if (state.isLoading && state.hasItems) ...[
          const SizedBox(height: 14),
          const LinearProgressIndicator(minHeight: 2),
        ],
      ],
    );
  }
}
