import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';

class ContentViewer extends StatelessWidget {
  final String url;

  const ContentViewer({super.key, required this.url});

  @override
  Widget build(BuildContext context) {
    return _isPdf(url)
        ? PDFViewWidget(url: url)
        : Image.network(
            url,
            fit: BoxFit.contain,
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) return child;
              return const Center(child: CircularProgressIndicator());
            },
            errorBuilder: (context, error, stackTrace) {
              return const Center(child: Text("No se pudo cargar la imagen"));
            },
          );
  }

  bool _isPdf(String url) {
    return url.toLowerCase().endsWith(".pdf");
  }
}

class PDFViewWidget extends StatelessWidget {
  final String url;

  const PDFViewWidget({super.key, required this.url});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: _downloadFile(url),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return const Center(child: Text("Error al cargar el PDF"));
        }
        return PDFView(
          filePath: snapshot.data!,
        );
      },
    );
  }

  Future<String> _downloadFile(String url) async {
    // Puedes usar paquetes como `dio` o `http` para descargar el archivo.
    // Por ahora, asumimos que el archivo está disponible localmente.
    // Implementa la lógica de descarga aquí si el archivo necesita ser descargado.
    throw UnimplementedError("Implementa la descarga del archivo aquí.");
  }
}
