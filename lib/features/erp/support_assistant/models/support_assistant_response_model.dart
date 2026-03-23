class SupportRecommendedConceptModel {
  const SupportRecommendedConceptModel({
    required this.financialConceptId,
    required this.name,
  });

  factory SupportRecommendedConceptModel.fromJson(Map<String, dynamic> json) {
    return SupportRecommendedConceptModel(
      financialConceptId: json['financialConceptId']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
    );
  }

  final String financialConceptId;
  final String name;
}

class SupportExtractedDataModel {
  const SupportExtractedDataModel({
    required this.documentType,
    required this.vendor,
    required this.amount,
    required this.currency,
    required this.documentDate,
    required this.summary,
  });

  factory SupportExtractedDataModel.empty() {
    return const SupportExtractedDataModel(
      documentType: '',
      vendor: '',
      amount: '',
      currency: '',
      documentDate: '',
      summary: '',
    );
  }

  factory SupportExtractedDataModel.fromJson(Map<String, dynamic> json) {
    return SupportExtractedDataModel(
      documentType: json['documentType']?.toString() ?? '',
      vendor: json['vendor']?.toString() ?? '',
      amount: json['amount']?.toString() ?? '',
      currency: json['currency']?.toString() ?? '',
      documentDate: json['documentDate']?.toString() ?? '',
      summary: json['summary']?.toString() ?? '',
    );
  }

  final String documentType;
  final String vendor;
  final String amount;
  final String currency;
  final String documentDate;
  final String summary;

  bool get isEmpty =>
      documentType.isEmpty &&
      vendor.isEmpty &&
      amount.isEmpty &&
      currency.isEmpty &&
      documentDate.isEmpty &&
      summary.isEmpty;
}

class SupportAssistantResponseModel {
  const SupportAssistantResponseModel({
    required this.conversationId,
    required this.answer,
    required this.intent,
    required this.confidence,
    required this.recommendedRoute,
    required this.recommendedScreen,
    required this.recommendedConcept,
    required this.steps,
    required this.warnings,
    required this.extractedData,
    required this.sources,
  });

  factory SupportAssistantResponseModel.fromJson(Map<String, dynamic> json) {
    return SupportAssistantResponseModel(
      conversationId: json['conversationId']?.toString() ?? '',
      answer: json['answer']?.toString() ?? '',
      intent: json['intent']?.toString() ?? '',
      confidence: json['confidence']?.toString() ?? '',
      recommendedRoute: json['recommendedRoute']?.toString() ?? '',
      recommendedScreen: json['recommendedScreen']?.toString() ?? '',
      recommendedConcept: SupportRecommendedConceptModel.fromJson(
        Map<String, dynamic>.from(
          (json['recommendedConcept'] as Map?) ?? const {},
        ),
      ),
      steps: ((json['steps'] as List?) ?? const [])
          .map((item) => item.toString())
          .toList(growable: false),
      warnings: ((json['warnings'] as List?) ?? const [])
          .map((item) => item.toString())
          .toList(growable: false),
      extractedData: SupportExtractedDataModel.fromJson(
        Map<String, dynamic>.from((json['extractedData'] as Map?) ?? const {}),
      ),
      sources: ((json['sources'] as List?) ?? const [])
          .map((item) => item.toString())
          .toList(growable: false),
    );
  }

  final String conversationId;
  final String answer;
  final String intent;
  final String confidence;
  final String recommendedRoute;
  final String recommendedScreen;
  final SupportRecommendedConceptModel recommendedConcept;
  final List<String> steps;
  final List<String> warnings;
  final SupportExtractedDataModel extractedData;
  final List<String> sources;
}
