import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:gloria_finance/core/app_http.dart';
import 'package:gloria_finance/features/auth/auth_persistence.dart';
import 'package:gloria_finance/features/erp/support_assistant/models/support_assistant_launch_model.dart';
import 'package:gloria_finance/features/erp/support_assistant/models/support_conversation_model.dart';
import 'package:gloria_finance/features/erp/support_assistant/models/support_assistant_response_model.dart';

class SupportAssistantService extends AppHttp {
  Future<SupportAssistantResponseModel> ask({
    required String question,
    String? conversationId,
    SupportAssistantAnalysisTargetModel? analysisTarget,
    List<PlatformFile> files = const [],
  }) async {
    final session = await AuthPersistence().restore();
    tokenAPI = session.token;

    final formMap = <String, dynamic>{
      'question': question,
      if (conversationId != null && conversationId.trim().isNotEmpty)
        'conversationId': conversationId.trim(),
      if (analysisTarget != null) 'analysisTarget': analysisTarget.toJson(),
    };

    if (files.isNotEmpty) {
      final multipartFiles = <MultipartFile>[];
      for (final file in files) {
        if (file.path != null) {
          multipartFiles.add(
            await MultipartFile.fromFile(file.path!, filename: file.name),
          );
          continue;
        }

        final bytes = file.bytes;
        if (bytes != null) {
          multipartFiles.add(
            MultipartFile.fromBytes(bytes, filename: file.name),
          );
        }
      }

      if (multipartFiles.isNotEmpty) {
        formMap['file'] = multipartFiles;
      }
    }

    try {
      final payload =
          formMap.containsKey('file') ? FormData.fromMap(formMap) : formMap;
      final response = await http.post(
        '${await getUrlApi()}ai/support',
        data: payload,
        options: Options(headers: bearerToken()),
      );

      return SupportAssistantResponseModel.fromJson(
        Map<String, dynamic>.from(response.data as Map),
      );
    } on DioException catch (e) {
      transformResponse(e.response?.data);
      rethrow;
    }
  }

  Future<List<SupportConversationSummaryModel>> listConversations() async {
    final session = await AuthPersistence().restore();
    tokenAPI = session.token;

    final response = await http.get(
      '${await getUrlApi()}ai/support/conversations',
      options: Options(headers: bearerToken()),
    );

    return ((response.data as List?) ?? const [])
        .map(
          (item) => SupportConversationSummaryModel.fromJson(
            Map<String, dynamic>.from(item as Map),
          ),
        )
        .toList(growable: false);
  }

  Future<SupportConversationDetailModel> getConversation(
    String conversationId,
  ) async {
    final session = await AuthPersistence().restore();
    tokenAPI = session.token;

    final response = await http.get(
      '${await getUrlApi()}ai/support/conversations/$conversationId',
      options: Options(headers: bearerToken()),
    );

    return SupportConversationDetailModel.fromJson(
      Map<String, dynamic>.from(response.data as Map),
    );
  }

  Future<void> deleteConversation(String conversationId) async {
    final session = await AuthPersistence().restore();
    tokenAPI = session.token;

    await http.delete(
      '${await getUrlApi()}ai/support/conversations/$conversationId',
      options: Options(headers: bearerToken()),
    );
  }
}
