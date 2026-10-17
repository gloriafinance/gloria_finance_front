import 'package:flutter/material.dart';
import 'package:gloria_finance/core/theme/app_color.dart';
import 'package:gloria_finance/core/theme/app_fonts.dart';
import 'package:gloria_finance/core/utils/app_localizations_ext.dart';
import 'package:gloria_finance/core/utils/index.dart';
import 'package:gloria_finance/core/widgets/button_acton_table.dart';
import 'package:go_router/go_router.dart';

/// Título del módulo y acción principal.
///
/// En desktop van en la misma fila; en mobile el título y el botón de ancho
/// completo se apilan, porque la etiqueta no cabe junto al título.
class RecurringPaymentListHeader extends StatelessWidget {
  const RecurringPaymentListHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final title = Text(
      context.l10n.recurringPayments_list_title,
      textAlign: TextAlign.left,
      style: TextStyle(
        fontFamily: AppFonts.fontTitle,
        fontSize: isMobile(context) ? 20 : 24,
        color: Colors.black,
      ),
    );

    final action = ButtonActionTable(
      color: AppColors.purple,
      text: context.l10n.recurringPayments_new_action,
      onPressed: () => context.go('/recurring-payments/add'),
      icon: Icons.add_box_outlined,
    );

    if (isMobile(context)) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [title, const SizedBox(height: 12), action],
      );
    }

    return Row(
      children: [
        Expanded(child: title),
        Align(alignment: Alignment.centerRight, child: action),
      ],
    );
  }
}
