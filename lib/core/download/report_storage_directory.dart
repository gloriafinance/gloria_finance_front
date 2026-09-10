import 'dart:io';

import 'package:path_provider/path_provider.dart';

/// Returns a directory where report exports can be stored without requesting
/// broad storage permissions.
///
/// On Android this uses the app-specific external storage directory. Files in
/// this directory do not require READ/WRITE/MANAGE_EXTERNAL_STORAGE. On other
/// platforms it falls back to the application documents directory.
Future<Directory> getReportStorageDirectory() async {
  Directory baseDirectory;

  if (Platform.isAndroid) {
    final externalDirectory = await getExternalStorageDirectory();
    if (externalDirectory != null) {
      baseDirectory = externalDirectory;
    } else {
      baseDirectory = await getApplicationDocumentsDirectory();
    }
  } else {
    baseDirectory = await getApplicationDocumentsDirectory();
  }

  final reportsDirectory = Directory('${baseDirectory.path}/reports');
  if (!await reportsDirectory.exists()) {
    await reportsDirectory.create(recursive: true);
  }

  return reportsDirectory;
}
