import 'package:church_finance_bk/core/theme/app_fonts.dart';
import 'package:church_finance_bk/core/widgets/background_container.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';

class LayoutAuth extends StatefulWidget {
  final Widget child;

  const LayoutAuth({super.key, required this.child});

  @override
  State<LayoutAuth> createState() => _LayoutAuthState();
}

class _LayoutAuthState extends State<LayoutAuth> {
  String _version = 'Carregando...';

  @override
  void initState() {
    super.initState();
    _loadVersion();
  }

  Future<void> _loadVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    setState(() {
      _version = 'v${packageInfo.version}+${packageInfo.buildNumber}';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: [
        const BackgroundContainer(),
        widget.child,
        Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
            child: Text(
              textAlign: TextAlign.center,
              '© ${DateTime.now().year} Jaspesoft CNPJ 43.716.343/0001-60 ${_version}',
              style: TextStyle(
                color: Colors.white,
                fontFamily: AppFonts.fontSubTitle,
              ),
            ),
          ),
        )
      ]),
    );
  }
}
