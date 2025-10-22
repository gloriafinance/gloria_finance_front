import 'dart:io';

import 'package:church_finance_bk/auth/auth_persistence.dart';
import 'package:church_finance_bk/core/app_http.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:path_provider/path_provider.dart';
import 'package:universal_html/html.dart' as html;

import 'models/income_statement_filter_model.dart';
import 'models/income_statement_model.dart';

class IncomeStatementService extends AppHttp {
  Future<IncomeStatementModel> fetchIncomeStatement(
    IncomeStatementFilterModel params,
  ) async {
    final session = await AuthPersistence().restore();
    tokenAPI = session.token;

    params.churchId = session.churchId;

    try {
      final response = await http.get(
        '${await getUrlApi()}reports/finance/income-statement',
        queryParameters: params.toJson(),
        options: Options(headers: bearerToken()),
      );

      return IncomeStatementModel.fromJson(response.data);
    } on DioException catch (e) {
      transformResponse(e.response?.data);
      rethrow;
    }
  }

  Future<bool> downloadIncomeStatementPdf(
    IncomeStatementFilterModel params,
  ) async {
    final session = await AuthPersistence().restore();
    tokenAPI = session.token;

    params.churchId = session.churchId;

    try {
      final response = await http.get(
        '${await getUrlApi()}reports/finance/income-statement/pdf',
        queryParameters: params.toJson(),
        options: Options(
          headers: bearerToken(),
          responseType: ResponseType.bytes,
        ),
      );

      final bytes = response.data as List<int>;
      const fileName = 'estado_ingresos.pdf';

      if (kIsWeb) {
        return _downloadPdfWeb(bytes, fileName);
      }

      final filePath = await _downloadPdfMobile(bytes, fileName);
      return filePath != null;
    } on DioException catch (e) {
      transformResponse(e.response?.data);
      rethrow;
    } catch (e) {
      print('Error al descargar el PDF: $e');
      return false;
    }
  }

  bool _downloadPdfWeb(List<int> bytes, String fileName) {
    try {
      final blob = html.Blob([bytes], 'application/pdf');
      final url = html.Url.createObjectUrlFromBlob(blob);
      final anchor =
          html.AnchorElement(href: url)
            ..setAttribute('download', fileName)
            ..style.display = 'none';

      html.document.body?.children.add(anchor);
      anchor.click();
      html.document.body?.children.remove(anchor);
      html.Url.revokeObjectUrl(url);

      return true;
    } catch (e) {
      print('Error al iniciar la descarga en web: $e');
      return false;
    }
  }

  Future<String?> _downloadPdfMobile(List<int> bytes, String fileName) async {
    try {
      if (Platform.isAndroid) {
        final downloadPath = Directory('/storage/emulated/0/Download');

        if (!await downloadPath.exists()) {
          await downloadPath.create(recursive: true);
        }

        final file = File('${downloadPath.path}/$fileName');
        await file.writeAsBytes(bytes, flush: true);

        return file.path;
      }

      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/$fileName');
      await file.writeAsBytes(bytes, flush: true);

      return file.path;
    } catch (e) {
      print('Error al guardar el PDF localmente: $e');
      return null;
    }
  }
}
