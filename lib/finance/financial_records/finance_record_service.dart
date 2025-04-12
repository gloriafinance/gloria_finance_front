import 'dart:io';

import 'package:church_finance_bk/auth/auth_persistence.dart';
import 'package:church_finance_bk/core/app_http.dart';
import 'package:church_finance_bk/core/paginate/paginate_response.dart';
import 'package:church_finance_bk/finance/financial_records/models/finance_record_filter_model.dart';
import 'package:dio/dio.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

import 'models/finance_record_list_model.dart';

class FinanceRecordService extends AppHttp {
  FinanceRecordService({super.tokenAPI});

  Future<bool> sendSaveFinanceRecord(Map<String, dynamic> form) async {
    final session = await AuthPersistence().restore();
    tokenAPI = session.token;

    FormData formData = FormData.fromMap({
      ...form,
      if (form['file'] != null) 'file': form['file']!,
    });

    try {
      await http.post(
        '${await getUrlApi()}finance/financial-record',
        data: formData,
        options: Options(
          headers: getHeader(),
        ),
      );

      return true;
    } on DioException catch (e) {
      transformResponse(e.response?.data);
      return false;
    }
  }

  Future<PaginateResponse<FinanceRecordListModel>> searchFinanceRecords(
      FinanceRecordFilterModel params) async {
    final session = await AuthPersistence().restore();
    tokenAPI = session.token;

    params.churchId = session.churchId;

    try {
      final response = await http.get(
        '${await getUrlApi()}finance/financial-record',
        queryParameters: params.toJson(),
        options: Options(
          headers: getHeader(),
        ),
      );

      return PaginateResponse.fromJson(params.perPage, response.data,
          (data) => FinanceRecordListModel.fromJson(data));
    } on DioException catch (e) {
      transformResponse(e.response?.data);
      rethrow;
    }
  }

  Future<bool> exportFinanceRecords(FinanceRecordFilterModel params) async {
    final session = await AuthPersistence().restore();
    tokenAPI = session.token;

    params.churchId = session.churchId;

    try {
      final response = await http.get(
        '${await getUrlApi()}finance/financial-record/export',
        queryParameters: params.toJson(),
        options: Options(
          headers: getHeader(),
          responseType: ResponseType.bytes,
        ),
      );

      final bytes = response.data as List<int>;
      final fileName = 'registros_financieros.xlsx';

      await downloadXls(bytes, fileName);

      return true;
    } on DioException catch (e) {
      transformResponse(e.response?.data);
      return false;
    }
  }

  Future<void> downloadXls(List<int> bytes, String filename) async {
    try {
      // Request storage permission
      final status = await Permission.storage.request();
      if (!status.isGranted) {
        print("Storage permission not granted.");
        return; // Or handle the denial appropriately (e.g., show a message)
      }

      Directory? directory;
      if (Platform.isAndroid) {
        directory = Directory(
            '/storage/emulated/0/Download'); // Standard downloads folder on Android
        if (!await directory.exists()) {
          directory = await getExternalStorageDirectory();
        }
      } else {
        directory = await getApplicationDocumentsDirectory();
      }

      if (directory == null) {
        print("Could not determine download directory.");
        return;
      }

      final filePath = '${directory.path}/$filename';
      final file = File(filePath);
      await file.writeAsBytes(bytes);

      final result = await OpenFile.open(filePath);

      if (result.type != ResultType.done) {
        print("Error opening file: ${result.message}");
      }
    } catch (e) {
      print("Error during download: $e");
    }
  }
}
