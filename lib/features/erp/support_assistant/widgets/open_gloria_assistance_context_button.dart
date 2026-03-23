import 'package:flutter/material.dart';
import 'package:gloria_finance/core/utils/app_localizations_ext.dart';
import 'package:gloria_finance/features/erp/support_assistant/models/support_assistant_launch_model.dart';
import 'package:gloria_finance/features/erp/support_assistant/widgets/open_gloria_assistance_button.dart';
import 'package:go_router/go_router.dart';

class OpenGloriaAssistanceContextButton extends StatelessWidget {
  const OpenGloriaAssistanceContextButton({
    super.key,
    required this.question,
    required this.title,
    required this.route,
    required this.module,
    required this.summary,
    this.relatedRoutes = const [],
    this.extraData = const {},
  });

  final String question;
  final String title;
  final String route;
  final String module;
  final String summary;
  final List<String> relatedRoutes;
  final Map<String, dynamic> extraData;

  @override
  Widget build(BuildContext context) {
    return OpenGloriaAssistanceButton(
      label: context.l10n.support_assistant_context_action,
      onPressed: () {
        context.push(
          '/support-assistant',
          extra: SupportAssistantLaunchModel(
            question: question,
            analysisTarget: SupportAssistantAnalysisTargetModel(
              type: SupportAssistantAnalysisTargetType.text,
              title: title,
              data: {
                'contextType': 'screen_help',
                'route': route,
                'module': module,
                'screenTitle': title,
                'summary': summary,
                'relatedRoutes': relatedRoutes,
                ...extraData,
              },
            ),
          ),
        );
      },
    );
  }
}
