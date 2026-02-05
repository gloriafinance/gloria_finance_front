import 'package:gloria_finance/core/theme/app_color.dart';
import 'package:gloria_finance/core/theme/app_fonts.dart';
import 'package:gloria_finance/core/toast.dart';
import 'package:gloria_finance/features/erp/schedule/models/schedule_models.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../store/schedule_form_store.dart';
import 'widgets/schedule_form.dart';

class ScheduleFormScreen extends StatelessWidget {
  final String? scheduleItemId;
  final ScheduleItemConfig? initialData;

  const ScheduleFormScreen({super.key, this.scheduleItemId, this.initialData});

  @override
  Widget build(BuildContext context) {
    Toast.init(context);

    final title = scheduleItemId != null ? 'Editar evento' : 'Cadastrar evento';

    return ChangeNotifierProvider(
      create:
          (_) => ScheduleFormStore(
            scheduleItemId: scheduleItemId,
            initialData: initialData,
          ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              GestureDetector(
                onTap: () => context.go('/schedule'),
                child: const Icon(
                  Icons.arrow_back_ios,
                  color: AppColors.purple,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                title,
                textAlign: TextAlign.left,
                style: const TextStyle(
                  fontFamily: AppFonts.fontTitle,
                  fontSize: 18,
                  color: Colors.black,
                ),
              ),
            ],
          ),
          const ScheduleForm(),
        ],
      ),
    );
  }
}
