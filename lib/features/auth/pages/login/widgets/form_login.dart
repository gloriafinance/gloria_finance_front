import 'package:gloria_finance/core/theme/app_fonts.dart';
import 'package:gloria_finance/core/utils/app_localizations_ext.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:url_launcher/url_launcher.dart';

import '../store/auth_session_store.dart';

class FormLogin extends StatefulWidget {
  const FormLogin({super.key});

  @override
  State<StatefulWidget> createState() => _FormLogin();
}

class _FormLogin extends State<FormLogin> {
  // Local state to handle UI-specific loading (spinner on button)
  bool _isGoogleLoading = false;
  bool _isMicrosoftLoading = false;

  @override
  Widget build(BuildContext context) {
    final authStore = Provider.of<AuthSessionStore>(context);
    // General loading from store or local state
    final bool isLoading =
        authStore.formState.makeRequest ||
        _isGoogleLoading ||
        _isMicrosoftLoading;

    return Padding(
      padding: const EdgeInsets.all(14.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 34),
          // 1. Header (Title + Subtitle)
          _buildHeader(context),
          const SizedBox(height: 24),

          // 2. Buttons & Divider
          _buttonGoogle(context, authStore, isLoading),
          const SizedBox(height: 14),
          _buildDivider(context),
          const SizedBox(height: 14),
          _buttonMicrosoft(context, authStore, isLoading),

          // 3. Legal Footer
          const SizedBox(height: 18),
          _buildLegalFooter(context),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Column(
      children: [


        Text(
          context.l10n.auth_login_social_enter_subtitle,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Color.fromRGBO(131, 131, 131, 0.9),
            fontSize: 14, // 14-15px
            fontFamily: AppFonts.fontSubTitle, // Regular/SubTitle font
          ),
        ),
      ],
    );
  }

  Widget _buildDivider(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Divider(
            color: const Color.fromRGBO(131, 131, 131, 0.2),
            thickness: 1,
            endIndent: 12,
          ),
        ),
        Text(
          context.l10n.auth_login_social_divider_or,
          style: const TextStyle(
            color: Color.fromRGBO(131, 131, 131, 0.9),
            fontSize: 14,
            fontFamily: AppFonts.fontSubTitle,
          ),
        ),
        Expanded(
          child: Divider(
            color: const Color.fromRGBO(131, 131, 131, 0.2),
            thickness: 1,
            indent: 12,
          ),
        ),
      ],
    );
  }

  Widget _buttonGoogle(
    BuildContext context,
    AuthSessionStore authStore,
    bool isLoading,
  ) {
    return _SocialButton(
      text: context.l10n.auth_login_social_google_btn,
      textColor: const Color(0xFF2D2D2D),
      backgroundColor: Color(0xD5E5E5E5),
      borderColor: const Color.fromRGBO(131, 131, 131, 0.2),
      iconPath: 'images/icons/google.svg',
      isLoading:
          _isGoogleLoading, // Only show spinner if THIS button was pressed
      isDisabled: isLoading, // Disable if ANY loading is happening
      onPressed: () => _handleLogin(authStore, LoginProvider.google),
    );
  }

  Widget _buttonMicrosoft(
    BuildContext context,
    AuthSessionStore authStore,
    bool isLoading,
  ) {
    return _SocialButton(
      text: context.l10n.auth_login_social_microsoft_btn,
      textColor: Colors.white,
      backgroundColor: const Color(0xFF0078D4),
      iconPath: 'images/icons/microsoft.svg',
      iconColor: Colors.white,
      isLoading: _isMicrosoftLoading,
      isDisabled: isLoading,
      onPressed: () => _handleLogin(authStore, LoginProvider.microsoft),
    );
  }

  Widget _buildLegalFooter(BuildContext context) {
    final termsText = context.l10n.auth_login_social_terms;
    final privacyText = context.l10n.auth_login_social_privacy;
    final fullText = context.l10n.auth_login_social_legal_text(
      termsText,
      privacyText,
    );

    // We need to parse the string to find where terms and privacy are located
    // A simple approach is assuming the order or splitting.
    // However, to be robust with arb placeholders, we can just split by the terms/privacy strings
    // But typical RichText in Flutter isn't auto-magically parsed from a single string unless we use a package.
    // Given the constraints and the provided Arb content: "Ao continuar... {terms} ... {privacy}."
    // We will construct the TextSpan manually to ensure correct styling and tap events.

    // NOTE: This implementation assumes the structure "Prefix {Terms} Middle {Privacy} Suffix" roughly.
    // For exact i18n placement with links, usually we'd split the string or use a pattern.
    // Let's optimize for visual and functional correctness.

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
          style: const TextStyle(
            color: Color.fromRGBO(131, 131, 131, 0.9),
            fontSize: 12,
            height: 1.3,
            fontFamily: AppFonts.fontSubTitle,
          ),
          children: _buildLegalTextSpans(
            context,
            fullText,
            termsText,
            privacyText,
          ),
        ),
      ),
    );
  }

  List<TextSpan> _buildLegalTextSpans(
    BuildContext context,
    String fullString,
    String terms,
    String privacy,
  ) {
    List<TextSpan> spans = [];

    // Naive parsing: find terms index and privacy index
    // This handles "Terms... Privacy" order. If order is reversed in some language, we might need a smarter parser.
    // But for PT/ES/EN, typically Terms comes before Privacy or vice versa.

    int termsIndex = fullString.indexOf(terms);
    int privacyIndex = fullString.indexOf(privacy);

    if (termsIndex == -1 || privacyIndex == -1) {
      // Fallback if parsing fails
      return [TextSpan(text: fullString)];
    }

    // Sort indices to handle any order
    Map<int, String> links = {};
    links[termsIndex] = terms;
    links[privacyIndex] = privacy;

    List<int> sortedIndices = links.keys.toList()..sort();

    int currentIndex = 0;

    for (int index in sortedIndices) {
      String linkText = links[index]!;

      // Text before the link
      if (index > currentIndex) {
        spans.add(TextSpan(text: fullString.substring(currentIndex, index)));
      }

      // The link itself
      String url =
          (linkText == terms)
              ? 'https://gloriafinance.com.br/terms-of-use'
              : 'https://gloriafinance.com.br/privacy-policy';

      spans.add(
        TextSpan(
          text: linkText,
          style: const TextStyle(
            color: Color(0xFF502981), // Primary Purple
            fontWeight: FontWeight.w600,
            decoration: TextDecoration.underline,
          ),
          recognizer:
              TapGestureRecognizer()
                ..onTap = () async {
                  final uri = Uri.parse(url);
                  if (await canLaunchUrl(uri)) {
                    await launchUrl(uri, mode: LaunchMode.externalApplication);
                  }
                },
        ),
      );

      currentIndex = index + linkText.length;
    }

    // Remaining text
    if (currentIndex < fullString.length) {
      spans.add(TextSpan(text: fullString.substring(currentIndex)));
    }

    return spans;
  }

  Future<void> _handleLogin(
    AuthSessionStore authStore,
    LoginProvider provider,
  ) async {
    setState(() {
      if (provider == LoginProvider.google) _isGoogleLoading = true;
      if (provider == LoginProvider.microsoft) _isMicrosoftLoading = true;
    });

    try {
      bool success = false;
      if (provider == LoginProvider.google) {
        success = await authStore.loginWithGoogle();
      } else {
        success = await authStore.loginWithMicrosoft();
      }

      if (success) {
        if (mounted) {
          if (authStore.needsPolicyAcceptance()) {
            context.go('/policy-acceptance');
          } else {
            context.go('/dashboard');
          }
        }
      } else {
        if (mounted) _showError(context);
      }
    } catch (e) {
      if (mounted) _showError(context);
    } finally {
      if (mounted) {
        setState(() {
          _isGoogleLoading = false;
          _isMicrosoftLoading = false;
        });
      }
    }
  }

  void _showError(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(context.l10n.auth_login_error_social_failed),
        backgroundColor: Colors.red,
      ),
    );
  }
}

enum LoginProvider { google, microsoft }

class _SocialButton extends StatelessWidget {
  final String text;
  final Color textColor;
  final Color backgroundColor;
  final String iconPath;
  final VoidCallback onPressed;
  final Color? borderColor;
  final Color? iconColor;
  final bool isLoading;
  final bool isDisabled;

  const _SocialButton({
    required this.text,
    required this.textColor,
    required this.backgroundColor,
    required this.iconPath,
    required this.onPressed,
    this.borderColor,
    this.iconColor,
    this.isLoading = false,
    this.isDisabled = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 56,
      child: ElevatedButton(
        onPressed: isDisabled ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          foregroundColor: textColor,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
            side:
                borderColor != null
                    ? BorderSide(color: borderColor!, width: 1)
                    : BorderSide.none,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16),
        ),
        child:
            isLoading
                ? SizedBox(
                  height: 24,
                  width: 24,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.5,
                    valueColor: AlwaysStoppedAnimation<Color>(textColor),
                  ),
                )
                : Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0, right: 16.0),
                      child: SvgPicture.asset(
                        iconPath,
                        width: 24,
                        height: 24,
                        colorFilter:
                            iconColor != null
                                ? ColorFilter.mode(iconColor!, BlendMode.srcIn)
                                : null,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        text,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          fontFamily: AppFonts.fontTitle,
                          color: textColor,
                        ),
                      ),
                    ),
                    // Balance the icon width to ensure text is truly centered
                    const SizedBox(width: 48),
                  ],
                ),
      ),
    );
  }
}
