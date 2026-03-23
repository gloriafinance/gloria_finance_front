import 'package:file_picker/file_picker.dart';
import 'package:gloria_finance/features/erp/support_assistant/models/support_chat_attachment_model.dart';
import 'package:gloria_finance/features/erp/support_assistant/models/support_assistant_response_model.dart';

enum SupportChatRole { user, assistant }

class SupportChatMessageModel {
  const SupportChatMessageModel({
    required this.role,
    required this.text,
    this.response,
    this.files = const [],
    this.attachments = const [],
    this.analysisLabel,
  });

  final SupportChatRole role;
  final String text;
  final SupportAssistantResponseModel? response;
  final List<PlatformFile> files;
  final List<SupportChatAttachmentModel> attachments;
  final String? analysisLabel;
}
