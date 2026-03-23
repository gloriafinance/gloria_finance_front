import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:gloria_finance/features/erp/support_assistant/models/support_chat_attachment_model.dart';
import 'package:gloria_finance/features/erp/support_assistant/models/support_chat_message_model.dart';
import 'package:gloria_finance/features/erp/support_assistant/models/support_assistant_launch_model.dart';
import 'package:gloria_finance/features/erp/support_assistant/service/support_assistant_service.dart';
import 'package:gloria_finance/features/erp/support_assistant/state/support_assistant_state.dart';

class SupportAssistantStore extends ChangeNotifier {
  SupportAssistantStore({SupportAssistantService? service})
    : service = service ?? SupportAssistantService();

  final SupportAssistantService service;

  SupportAssistantState state = SupportAssistantState.initial();

  String _buildAnalysisLabel(
    SupportAssistantAnalysisTargetModel analysisTarget,
  ) {
    switch (analysisTarget.type) {
      case SupportAssistantAnalysisTargetType.report:
        return 'report: ${analysisTarget.title.trim()}';
      case SupportAssistantAnalysisTargetType.text:
        return analysisTarget.title.trim();
    }
  }

  Future<void> loadRecentConversations() async {
    state = state.copyWith(isLoadingConversations: true);
    notifyListeners();

    try {
      final conversations = await service.listConversations();
      state = state.copyWith(
        recentConversations: conversations,
        isLoadingConversations: false,
      );
      notifyListeners();
    } catch (_) {
      state = state.copyWith(isLoadingConversations: false);
      notifyListeners();
    }
  }

  Future<void> openConversation(String conversationId) async {
    if (conversationId.trim().isEmpty || state.isLoading) return;

    state = state.copyWith(isLoading: true, pendingFiles: []);
    notifyListeners();

    try {
      final detail = await service.getConversation(conversationId);
      final messages = <SupportChatMessageModel>[];

      for (final entry in detail.messages) {
        messages.add(
          SupportChatMessageModel(
            role: SupportChatRole.user,
            text: entry.question,
            attachments: entry.attachments,
            analysisLabel:
                entry.analysisTarget != null
                    ? _buildAnalysisLabel(entry.analysisTarget!)
                    : null,
          ),
        );
        messages.add(
          SupportChatMessageModel(
            role: SupportChatRole.assistant,
            text: entry.answer,
            response: entry.response,
          ),
        );
      }

      state = state.copyWith(
        messages: messages,
        conversationId: detail.conversationId,
        isLoading: false,
      );
      notifyListeners();
    } catch (_) {
      state = state.copyWith(isLoading: false);
      notifyListeners();
    }
  }

  Future<void> startNewConversation() async {
    state = state.copyWith(
      messages: const [],
      pendingFiles: const [],
      conversationId: '',
      isLoading: false,
    );
    notifyListeners();
  }

  Future<void> deleteConversation(String conversationId) async {
    final trimmedId = conversationId.trim();
    if (trimmedId.isEmpty || state.isLoading) return;

    state = state.copyWith(isLoading: true);
    notifyListeners();

    try {
      await service.deleteConversation(trimmedId);
      final isCurrentConversation = state.conversationId == trimmedId;
      final filteredConversations = state.recentConversations
          .where((item) => item.conversationId != trimmedId)
          .toList(growable: false);

      state = state.copyWith(
        isLoading: false,
        recentConversations: filteredConversations,
        conversationId: isCurrentConversation ? '' : state.conversationId,
        messages: isCurrentConversation ? const [] : state.messages,
        pendingFiles: isCurrentConversation ? const [] : state.pendingFiles,
      );
      notifyListeners();
    } catch (_) {
      state = state.copyWith(isLoading: false);
      notifyListeners();
    }
  }

  Future<void> pickFiles() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: const ['jpg', 'jpeg', 'png', 'webp'],
      allowMultiple: true,
      withData: true,
    );

    if (result == null) return;

    state = state.copyWith(
      pendingFiles: [...state.pendingFiles, ...result.files],
    );
    notifyListeners();
  }

  void removePendingFile(PlatformFile file) {
    state = state.copyWith(
      pendingFiles: state.pendingFiles
          .where(
            (item) =>
                item.identifier != file.identifier || item.name != file.name,
          )
          .toList(growable: false),
    );
    notifyListeners();
  }

  Future<void> sendMessage(String text) async {
    final question = text.trim();
    if (question.isEmpty || state.isLoading) return;

    final files = List<PlatformFile>.from(state.pendingFiles);
    final userMessage = SupportChatMessageModel(
      role: SupportChatRole.user,
      text: question,
      files: files,
      attachments: files
          .map(SupportChatAttachmentModel.fromPlatformFile)
          .toList(growable: false),
    );

    state = state.copyWith(
      messages: [...state.messages, userMessage],
      pendingFiles: [],
      isLoading: true,
    );
    notifyListeners();

    try {
      final response = await service.ask(
        question: question,
        conversationId: state.conversationId,
        files: files,
      );
      final assistantMessage = SupportChatMessageModel(
        role: SupportChatRole.assistant,
        text: response.answer,
        response: response,
      );

      state = state.copyWith(
        messages: [...state.messages, assistantMessage],
        isLoading: false,
        conversationId: response.conversationId,
      );
      notifyListeners();
      await loadRecentConversations();
    } catch (_) {
      state = state.copyWith(isLoading: false);
      notifyListeners();
    }
  }

  Future<void> sendAnalysisTarget({
    required String question,
    required SupportAssistantAnalysisTargetModel analysisTarget,
  }) async {
    final trimmedQuestion = question.trim();
    final trimmedTitle = analysisTarget.title.trim();
    if (trimmedQuestion.isEmpty || trimmedTitle.isEmpty || state.isLoading) {
      return;
    }

    final userMessage = SupportChatMessageModel(
      role: SupportChatRole.user,
      text: trimmedQuestion,
      attachments: const [],
      analysisLabel: _buildAnalysisLabel(
        SupportAssistantAnalysisTargetModel(
          type: analysisTarget.type,
          title: trimmedTitle,
          data: analysisTarget.data,
        ),
      ),
    );

    state = state.copyWith(
      messages: [...state.messages, userMessage],
      pendingFiles: [],
      isLoading: true,
    );
    notifyListeners();

    try {
      final response = await service.ask(
        question: trimmedQuestion,
        conversationId: state.conversationId,
        analysisTarget: SupportAssistantAnalysisTargetModel(
          type: analysisTarget.type,
          title: trimmedTitle,
          data: analysisTarget.data,
        ),
      );
      final assistantMessage = SupportChatMessageModel(
        role: SupportChatRole.assistant,
        text: response.answer,
        response: response,
      );

      state = state.copyWith(
        messages: [...state.messages, assistantMessage],
        isLoading: false,
        conversationId: response.conversationId,
      );
      notifyListeners();
      await loadRecentConversations();
    } catch (_) {
      state = state.copyWith(isLoading: false);
      notifyListeners();
    }
  }

  Future<void> sendLaunchRequest(SupportAssistantLaunchModel launch) {
    return sendAnalysisTarget(
      question: launch.question,
      analysisTarget: launch.analysisTarget,
    );
  }
}
