import 'package:gloria_finance/core/theme/app_color.dart';
import 'package:gloria_finance/core/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ContentViewer extends StatelessWidget {
  final String url;
  final String title;

  ContentViewer({
    super.key,
    required this.url,
    this.title = "Abrir PDF no navegador",
  });

  @override
  Widget build(BuildContext context) {
    if (_isPdf(url)) {
      return Center(
        child: CustomButton(
          onPressed: () async {
            //UrlLauncherPlugin().launch(url, useWebView: true);
            if (!await launchUrl(
              Uri.parse(url),
              mode: LaunchMode.inAppBrowserView,
            )) {
              throw Exception('Could not launch $url');
            }
          },
          text: title,
          textColor: Colors.white,
          backgroundColor: AppColors.blue,
        ),
      );
    } else {
      return Image.network(url, width: double.infinity);
    }
  }

  bool _isPdf(String url) {
    // Eliminar los parámetros de consulta (todo después del ?)
    final cleanUrl = url.split('?')[0];
    return cleanUrl.toLowerCase().endsWith('.pdf');
  }
}
