import 'package:church_finance_bk/core/theme/app_color.dart';
import 'package:church_finance_bk/core/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher_web/url_launcher_web.dart';

class ContentViewer extends StatelessWidget {
  final String url;

  const ContentViewer({super.key, required this.url});

  @override
  Widget build(BuildContext context) {
    if (_isPdf(url)) {
      return Center(
        child: CustomButton(
          width: 400,
          onPressed: () async {
            UrlLauncherPlugin().launch(url, useWebView: true);
          },
          text: "Abrir PDF no nevegador",
          textColor: Colors.white,
          backgroundColor: AppColors.blue,
        ),
      );
    } else {
      return Image.network(url, width: 300, height: 300);
    }
  }

  bool _isPdf(String url) {
    // Eliminar los parámetros de consulta (todo después del ?)
    final cleanUrl = url.split('?')[0];
    return cleanUrl.toLowerCase().endsWith('.pdf');
  }
}
