import 'package:church_finance_bk/core/theme/app_fonts.dart';
import 'package:church_finance_bk/core/toast.dart';
import 'package:church_finance_bk/core/widgets/app_logo.dart';
import 'package:church_finance_bk/core/widgets/background_container.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';

class LayoutAuth extends StatefulWidget {
  final Widget child;
  final double? width;
  final double? height;

  const LayoutAuth({super.key, required this.child, this.width, this.height});

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
    Toast.init(context);

    return Scaffold(
      body: Stack(
        children: [
          const BackgroundContainer(),
          _buildContent(context),
          _buildFooter(),
        ],
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        double containerHeight = widget.height ??
            (constraints.maxHeight.isFinite
                ? constraints.maxHeight * 0.85
                : 600);
        return Center(
          child: Container(
            width: widget.width ?? MediaQuery.of(context).size.width * 0.97,
            height: containerHeight,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Expanded(
                  child: NotificationListener<OverscrollIndicatorNotification>(
                    onNotification: (overscroll) {
                      overscroll.disallowIndicator();
                      return false;
                    },
                    child: SingleChildScrollView(
                      physics: const ClampingScrollPhysics(),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const SizedBox(height: 20),
                          const ApplicationLogo(height: 100),
                          widget.child,
                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildFooter() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              '© ${DateTime.now().year} Jaspesoft CNPJ 43.716.343/0001-60 ',
              style: TextStyle(
                color: Colors.white,
                fontFamily: AppFonts.fontSubTitle,
              ),
              textAlign: TextAlign.center,
            ),
            Text(
              _version,
              style: TextStyle(
                color: Colors.white,
                fontFamily: AppFonts.fontSubTitle,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
