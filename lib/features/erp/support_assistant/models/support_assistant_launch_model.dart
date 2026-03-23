class SupportAssistantLaunchModel {
  const SupportAssistantLaunchModel({
    required this.question,
    required this.analysisTarget,
  });

  final String question;
  final SupportAssistantAnalysisTargetModel analysisTarget;
}

enum SupportAssistantAnalysisTargetType { report, text }

class SupportAssistantAnalysisTargetModel {
  const SupportAssistantAnalysisTargetModel({
    required this.type,
    required this.title,
    required this.data,
  });

  factory SupportAssistantAnalysisTargetModel.fromJson(
    Map<String, dynamic> json,
  ) {
    final rawType = json['type']?.toString() ?? 'text';

    return SupportAssistantAnalysisTargetModel(
      type:
          rawType == 'report'
              ? SupportAssistantAnalysisTargetType.report
              : SupportAssistantAnalysisTargetType.text,
      title: json['title']?.toString() ?? '',
      data: json['data'] ?? const {},
    );
  }

  final SupportAssistantAnalysisTargetType type;
  final String title;
  final Object data;

  Map<String, dynamic> toJson() {
    return {'type': type.name, 'title': title, 'data': data};
  }
}
