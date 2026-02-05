import 'package:gloria_finance/core/theme/app_color.dart';
import 'package:gloria_finance/core/theme/app_fonts.dart';
import 'package:gloria_finance/core/utils/app_localizations_ext.dart';
import 'package:gloria_finance/core/utils/index.dart';
import 'package:gloria_finance/core/widgets/button_acton_table.dart';
import 'package:gloria_finance/features/erp/schedule/store/schedule_list_store.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'widgets/schedule_filters.dart';
import 'widgets/schedule_table.dart';

class ScheduleListScreen extends StatelessWidget {
  const ScheduleListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ScheduleListStore()..fetchScheduleItems(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _header(context),
          const SizedBox(height: 16),
          const ScheduleFilters(),
          const SizedBox(height: 16),
          const ScheduleTable(),
        ],
      ),
    );
  }

  Widget _header(BuildContext context) {
    final title = Text(
      context.l10n.schedule_list_title,
      textAlign: TextAlign.left,
      style: const TextStyle(
        fontFamily: AppFonts.fontTitle,
        fontSize: 20,
        color: Colors.black,
      ),
    );

    final newButton = ButtonActionTable(
      color: AppColors.purple,
      text: context.l10n.schedule_list_new_button,
      icon: Icons.add_circle_outline,
      onPressed: () => context.go('/schedule/new'),
    );

    if (!isMobile(context)) {
      return Row(children: [Expanded(child: title), newButton]);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [title, const SizedBox(height: 16), newButton],
    );
  }
}
