import 'package:flutter/material.dart';
import 'package:gloria_finance/core/theme/app_color.dart';
import 'package:gloria_finance/core/toast.dart';
import 'package:gloria_finance/core/utils/app_localizations_ext.dart';
import 'package:gloria_finance/features/erp/support_assistant/models/support_assistant_launch_model.dart';
import 'package:gloria_finance/features/erp/support_assistant/store/support_assistant_store.dart';
import 'package:gloria_finance/features/erp/support_assistant/widgets/chat/support_assistant_composer.dart';
import 'package:gloria_finance/features/erp/support_assistant/widgets/chat/support_assistant_conversation_toolbar.dart';
import 'package:gloria_finance/features/erp/support_assistant/widgets/chat/support_assistant_empty_state.dart';
import 'package:gloria_finance/features/erp/support_assistant/widgets/chat/support_assistant_header.dart';
import 'package:gloria_finance/features/erp/support_assistant/widgets/chat/support_assistant_loading_state.dart';
import 'package:gloria_finance/features/erp/support_assistant/widgets/chat/support_message_bubble.dart';
import 'package:gloria_finance/features/erp/support_assistant/widgets/chat/support_pending_files.dart';
import 'package:provider/provider.dart';

class SupportAssistantScreen extends StatelessWidget {
  const SupportAssistantScreen({super.key, this.initialRequest});

  final SupportAssistantLaunchModel? initialRequest;

  @override
  Widget build(BuildContext context) {
    Toast.init(context);

    return ChangeNotifierProvider(
      create: (_) => SupportAssistantStore(),
      child: _SupportAssistantView(initialRequest: initialRequest),
    );
  }
}

class _SupportAssistantView extends StatefulWidget {
  const _SupportAssistantView({this.initialRequest});

  final SupportAssistantLaunchModel? initialRequest;

  @override
  State<_SupportAssistantView> createState() => _SupportAssistantViewState();
}

class _SupportAssistantViewState extends State<_SupportAssistantView> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final GlobalKey _lastMessageKey = GlobalKey();
  int _lastAutoScrolledMessageCount = 0;
  bool _bootstrappedInitialRequest = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _sendInitialRequestIfNeeded();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _sendInitialRequestIfNeeded() {
    context.read<SupportAssistantStore>().loadRecentConversations();

    final initialRequest = widget.initialRequest;
    if (_bootstrappedInitialRequest || initialRequest == null || !mounted) {
      return;
    }

    _bootstrappedInitialRequest = true;
    context.read<SupportAssistantStore>().sendLaunchRequest(initialRequest);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<SupportAssistantStore>(
      builder: (context, store, _) {
        if (store.state.messages.length != _lastAutoScrolledMessageCount) {
          _lastAutoScrolledMessageCount = store.state.messages.length;
          WidgetsBinding.instance.addPostFrameCallback((_) {
            final messageContext = _lastMessageKey.currentContext;
            if (messageContext == null) return;

            Scrollable.ensureVisible(
              messageContext,
              alignment: 0,
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeOut,
            );
          });
        }

        final media = MediaQuery.of(context);
        final isCompact = media.size.width < 900;

        return LayoutBuilder(
          builder: (context, constraints) {
            final viewportHeight =
                constraints.maxHeight.isFinite
                    ? constraints.maxHeight
                    : media.size.height;
            final maxWidth = constraints.maxWidth >= 1480 ? 1380.0 : 1180.0;
            final chatHeight =
                isCompact
                    ? (viewportHeight - 220).clamp(520.0, 760.0)
                    : (viewportHeight - 170).clamp(680.0, 960.0);
            final sidebarWidth = isCompact ? maxWidth : 320.0;

            return Align(
              alignment: Alignment.topCenter,
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: maxWidth),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SupportAssistantHeader(isCompact: isCompact),
                    const SizedBox(height: 16),
                    if (isCompact) ...[
                      SupportAssistantConversationToolbar(
                        isCompact: true,
                        fillHeight: false,
                        isLoading: store.state.isLoading,
                        selectedConversationId: store.state.conversationId,
                        recentConversations: store.state.recentConversations,
                        onStartNewConversation: store.startNewConversation,
                        onOpenConversation: store.openConversation,
                        onDeleteConversation:
                            (conversationId) => _confirmDeleteConversation(
                              context,
                              store,
                              conversationId,
                            ),
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        height: chatHeight,
                        child: _buildChatPanel(store, isCompact),
                      ),
                    ] else
                      SizedBox(
                        height: chatHeight,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: sidebarWidth,
                              child: SupportAssistantConversationToolbar(
                                isCompact: false,
                                fillHeight: true,
                                isLoading: store.state.isLoading,
                                selectedConversationId:
                                    store.state.conversationId,
                                recentConversations:
                                    store.state.recentConversations,
                                onStartNewConversation:
                                    store.startNewConversation,
                                onOpenConversation: store.openConversation,
                                onDeleteConversation:
                                    (conversationId) =>
                                        _confirmDeleteConversation(
                                          context,
                                          store,
                                          conversationId,
                                        ),
                              ),
                            ),
                            const SizedBox(width: 18),
                            Expanded(child: _buildChatPanel(store, isCompact)),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildChatPanel(SupportAssistantStore store, bool isCompact) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.greyLight),
        boxShadow: const [
          BoxShadow(
            color: Color(0x11000000),
            blurRadius: 24,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          Expanded(
            child:
                store.state.messages.isEmpty
                    ? store.state.isLoading
                        ? const SupportAssistantLoadingState()
                        : SupportAssistantEmptyState(
                          isCompact: isCompact,
                          onSuggestionSelected: _applySuggestionText,
                        )
                    : ListView.separated(
                      controller: _scrollController,
                      padding: const EdgeInsets.all(20),
                      itemBuilder: (context, index) {
                        final message = store.state.messages[index];
                        return SupportMessageBubble(
                          key:
                              index == store.state.messages.length - 1
                                  ? _lastMessageKey
                                  : ValueKey('support-message-$index'),
                          message: message,
                        );
                      },
                      separatorBuilder: (_, __) => const SizedBox(height: 16),
                      itemCount: store.state.messages.length,
                    ),
          ),
          if (store.state.pendingFiles.isNotEmpty)
            SupportPendingFiles(
              files: store.state.pendingFiles,
              onRemoveFile: store.removePendingFile,
            ),
          if (store.state.isLoading)
            const Padding(
              padding: EdgeInsets.only(bottom: 8),
              child: LinearProgressIndicator(),
            ),
          SupportAssistantComposer(
            controller: _controller,
            isCompact: isCompact,
            isLoading: store.state.isLoading,
            onAttach: store.pickFiles,
            onSend: () => _send(store),
          ),
        ],
      ),
    );
  }

  void _send(SupportAssistantStore store) {
    final message = _controller.text;
    _controller.clear();
    store.sendMessage(message);
  }

  void _applySuggestionText(String text) {
    _controller.text = text;
  }

  Future<void> _confirmDeleteConversation(
    BuildContext context,
    SupportAssistantStore store,
    String conversationId,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text(
            context.l10n.support_assistant_delete_conversation_title,
          ),
          content: Text(context.l10n.support_assistant_delete_conversation_body),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: Text(context.l10n.common_cancel),
            ),
            FilledButton(
              onPressed: () => Navigator.of(dialogContext).pop(true),
              child: Text(context.l10n.support_assistant_delete_conversation),
            ),
          ],
        );
      },
    );

    if (confirmed == true && mounted) {
      await store.deleteConversation(conversationId);
    }
  }
}
