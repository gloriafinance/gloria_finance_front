import 'package:gloria_finance/features/erp/support_assistant/models/support_assistant_response_model.dart';
import 'package:gloria_finance/features/erp/support_assistant/models/support_chat_attachment_model.dart';
import 'package:gloria_finance/features/erp/support_assistant/models/support_assistant_launch_model.dart';

class SupportConversationSummaryModel {
  const SupportConversationSummaryModel({
    required this.conversationId,
    required this.title,
    required this.createdAt,
    required this.updatedAt,
  });

  factory SupportConversationSummaryModel.fromJson(Map<String, dynamic> json) {
    return SupportConversationSummaryModel(
      conversationId: json['conversationId']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      createdAt: json['createdAt']?.toString() ?? '',
      updatedAt: json['updatedAt']?.toString() ?? '',
    );
  }

  final String conversationId;
  final String title;
  final String createdAt;
  final String updatedAt;
}

class SupportConversationHistoryEntryModel {
  const SupportConversationHistoryEntryModel({
    required this.question,
    required this.answer,
    required this.intent,
    required this.sources,
    required this.createdAt,
    required this.attachments,
    this.response,
    this.analysisTarget,
  });

  factory SupportConversationHistoryEntryModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return SupportConversationHistoryEntryModel(
      question: json['question']?.toString() ?? '',
      answer: json['answer']?.toString() ?? '',
      intent: json['intent']?.toString() ?? '',
      sources: ((json['sources'] as List?) ?? const [])
          .map((item) => item.toString())
          .toList(growable: false),
      createdAt: json['createdAt']?.toString() ?? '',
      attachments: ((json['attachments'] as List?) ?? const [])
          .map(
            (item) => SupportChatAttachmentModel.fromConversationJson(
              Map<String, dynamic>.from(item as Map),
            ),
          )
          .toList(growable: false),
      response:
          json['response'] is Map<String, dynamic>
              ? SupportAssistantResponseModel.fromJson(
                Map<String, dynamic>.from(json['response'] as Map),
              )
              : json['response'] is Map
              ? SupportAssistantResponseModel.fromJson(
                Map<String, dynamic>.from(json['response'] as Map),
              )
              : null,
      analysisTarget:
          json['analysisTarget'] is Map<String, dynamic>
              ? SupportAssistantAnalysisTargetModel.fromJson(
                Map<String, dynamic>.from(json['analysisTarget'] as Map),
              )
              : json['analysisTarget'] is Map
              ? SupportAssistantAnalysisTargetModel.fromJson(
                Map<String, dynamic>.from(json['analysisTarget'] as Map),
              )
              : null,
    );
  }

  final String question;
  final String answer;
  final String intent;
  final List<String> sources;
  final String createdAt;
  final List<SupportChatAttachmentModel> attachments;
  final SupportAssistantResponseModel? response;
  final SupportAssistantAnalysisTargetModel? analysisTarget;
}

class SupportConversationDetailModel {
  const SupportConversationDetailModel({
    required this.conversationId,
    required this.messages,
  });

  factory SupportConversationDetailModel.fromJson(Map<String, dynamic> json) {
    return SupportConversationDetailModel(
      conversationId: json['conversationId']?.toString() ?? '',
      messages: ((json['messages'] as List?) ?? const [])
          .map(
            (item) => SupportConversationHistoryEntryModel.fromJson(
              Map<String, dynamic>.from(item as Map),
            ),
          )
          .toList(growable: false),
    );
  }

  final String conversationId;
  final List<SupportConversationHistoryEntryModel> messages;
}
