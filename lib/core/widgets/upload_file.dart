import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

import '../theme/app_color.dart';
import '../theme/app_fonts.dart';

class UploadFile extends StatefulWidget {
  final String label;
  final String? folderStorage;
  final void Function(MultipartFile) multipartFile;

  const UploadFile(
      {super.key,
      required this.label,
      required this.multipartFile,
      this.folderStorage});

  @override
  State<StatefulWidget> createState() => _UploadFile();
}

class _UploadFile extends State<UploadFile>
    with SingleTickerProviderStateMixin {
  PlatformFile? _platformFile;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _label(),
        _selectorFile(),
        _platformFile != null ? _presentationInformationFile() : Container(),
      ],
    );
  }

  Widget _presentationInformationFile() {
    return Container(
        margin: const EdgeInsets.only(top: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.shade200,
                        offset: Offset(0, 1),
                        blurRadius: 3,
                        spreadRadius: 2,
                      )
                    ]),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _platformFile!.name,
                            style: const TextStyle(
                                fontSize: 13, color: Colors.black),
                          ),
                          Text(
                            '${(_platformFile!.size / 1024).ceil()} KB',
                            style: TextStyle(
                                fontSize: 13, color: Colors.grey.shade500),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                  ],
                )),
          ],
        ));
  }

  Widget _selectorFile() {
    return GestureDetector(
      onTap: _actionSelectFile,
      child: Center(
        child: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
              border: Border.all(color: AppColors.greyMiddle),
              borderRadius: BorderRadius.circular(10)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'images/uploadFile.png',
                width: 80,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _label() {
    return Padding(
      padding: const EdgeInsets.only(top: 20.0),
      child: Text(
        widget.label,
        textAlign: TextAlign.left,
        style: const TextStyle(
            color: AppColors.purple,
            fontFamily: AppFonts.fontRegular,
            fontSize: 18),
      ),
    );
  }

  _actionSelectFile() async {
    FilePickerResult? file = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'jpeg', 'png', 'pdf'],
    );

    if (file != null) {
      setState(() {
        _platformFile = file.files.first;

        // Crear MultipartFile desde los bytes del archivo (sin usar path)
        if (_platformFile!.bytes != null) {
          widget.multipartFile(
            MultipartFile.fromBytes(
              _platformFile!.bytes!,
              filename: _platformFile!.name,
            ),
          );
        }
      });
    }
  }
}
