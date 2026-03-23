import 'package:file_picker/file_picker.dart';
import 'package:gloria_finance/features/erp/support_assistant/models/support_chat_message_model.dart';
import 'package:gloria_finance/features/erp/support_assistant/models/support_conversation_model.dart';

class SupportAssistantState {
  const SupportAssistantState({
    required this.messages,
    required this.pendingFiles,
    required this.isLoading,
    required this.conversationId,
    required this.recentConversations,
    required this.isLoadingConversations,
  });

  factory SupportAssistantState.initial() {
    return const SupportAssistantState(
      messages: [],
      pendingFiles: [],
      isLoading: false,
      conversationId: '',
      recentConversations: [],
      isLoadingConversations: false,
    );
  }

  final List<SupportChatMessageModel> messages;
  final List<PlatformFile> pendingFiles;
  final bool isLoading;
  final String conversationId;
  final List<SupportConversationSummaryModel> recentConversations;
  final bool isLoadingConversations;

  SupportAssistantState copyWith({
    List<SupportChatMessageModel>? messages,
    List<PlatformFile>? pendingFiles,
    bool? isLoading,
    String? conversationId,
    List<SupportConversationSummaryModel>? recentConversations,
    bool? isLoadingConversations,
  }) {
    return SupportAssistantState(
      messages: messages ?? this.messages,
      pendingFiles: pendingFiles ?? this.pendingFiles,
      isLoading: isLoading ?? this.isLoading,
      conversationId: conversationId ?? this.conversationId,
      recentConversations: recentConversations ?? this.recentConversations,
      isLoadingConversations:
          isLoadingConversations ?? this.isLoadingConversations,
    );
  }
}
