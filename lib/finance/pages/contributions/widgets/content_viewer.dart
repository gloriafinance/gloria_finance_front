import 'dart:html' as html;
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ContentViewer extends StatelessWidget {
  final String url;

  const ContentViewer({super.key, required this.url});

  @override
  Widget build(BuildContext context) {
    print(url);
    print(_isPdf(url));
    //https://storage.googleapis.com/churchs3/2025/1/3468c5e2-4c44-4423-982a-9ddd81a9e3b7.pdf?GoogleAccessId=devpto-dev%40appspot.gserviceaccount.com&Expires=1736307510&Signature=ahrtVxy76ZN2cVNs74f1uzbpW%2BmZ9YgVuzUfWtn9KjO3y0rvwJo%2Bja55fNr3S5%2BC%2BQIzedKpvsBLusDEnOJbwXBq6L5ZP3QRKiL3lEbYrf8CNNiR%2BzzDyoh7Z2B4u4fkoWbBg9h%2FOuIb7mBjOCQZrdU%2B%2FlzqiQ2R51V4%2B87KyQIgYrj7FFaXWTFIzfL9k1NBHsgGY73c80SBeHTIBIOkjOF8jR7vaO0hhczJ91Gm0PSSGvbIqsPFZTh%2BttvHbgdZBlqImvRwg5Bd7DtXDo6GSyxvu2gJU6CXqK89eseAKd5Qq9GS12NtqVT46ksB5CbGWUDW05aYyd1HkidO2xIeTg%3D%3D
    if (_isPdf(url)) {
      // Crear un iframe para visualizar el PDF
      return PDFViewWidget(url: url);
    } else {
      // Si no es un PDF, mostrar algo diferente (por ejemplo, una imagen)
      return Image.network(url, width: 300, height: 300);
    }
  }

  bool _isPdf(String url) {
    // Eliminar los parámetros de consulta (todo después del ?)
    final cleanUrl = url.split('?')[0];
    return cleanUrl.toLowerCase().endsWith('.pdf');
  }
}

class PDFViewWidget extends StatelessWidget {
  final String url;

  const PDFViewWidget({super.key, required this.url});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Uint8List>(
      future: _downloadFile(url),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return const Center(child: Text("Error al cargar el PDF"));
        }
        if (!snapshot.hasData || snapshot.data == null) {
          return const Center(child: Text("No se pudo descargar el archivo"));
        }

        // Mostrar el PDF usando un iframe
        return _buildPdfViewer(snapshot.data!);
      },
    );
  }

  Future<Uint8List> _downloadFile(String url) async {
    try {
      // Realiza una solicitud HTTP para obtener el archivo PDF
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        return response.bodyBytes; // Devuelve los bytes del archivo PDF
      } else {
        throw Exception("Error al descargar el archivo PDF");
      }
    } catch (e) {
      throw Exception("Error al descargar el archivo: $e");
    }
  }

  Widget _buildPdfViewer(Uint8List pdfBytes) {
    // Crear un archivo Blob a partir de los bytes del PDF
    final blob = html.Blob([pdfBytes]);
    final url = html.Url.createObjectUrlFromBlob(blob);

    // Crear un iframe para mostrar el PDF
    final iframe = html.IFrameElement()
      ..width = '100%'
      ..height = '600'
      ..src = url
      ..style.border = 'none';

    // Usamos HtmlElementView para integrar el iframe en el widget de Flutter
    return HtmlElementView(
      viewType: 'iframeElement',
    );
  }
}
