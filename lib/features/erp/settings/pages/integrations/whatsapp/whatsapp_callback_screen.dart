import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:gloria_finance/core/theme/app_fonts.dart';
import 'package:gloria_finance/core/toast.dart';
import 'package:gloria_finance/core/utils/app_localizations_ext.dart';
import 'package:gloria_finance/features/erp/settings/integrations/services/integrations_service.dart';
import 'package:gloria_finance/features/auth/pages/login/store/auth_session_store.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class WhatsappCallbackScreen extends StatefulWidget {
  final Map<String, String> queryParameters;

  const WhatsappCallbackScreen({super.key, required this.queryParameters});

  @override
  State<WhatsappCallbackScreen> createState() => _WhatsappCallbackScreenState();
}

class _WhatsappCallbackScreenState extends State<WhatsappCallbackScreen> {
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _processCallback();
  }

  Future<void> _processCallback() async {
    final code = widget.queryParameters['code'];

    if (code == null) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _errorMessage =
              context
                  .l10n
                  .settings_integrations_whatsapp_callback_error_missing;
        });
      }
      return;
    }

    try {
      final authStore = context.read<AuthSessionStore>();
      final service = IntegrationsService(
        tokenAPI: authStore.state.session.token,
      );

      // If we only have 'code', we need the redirectUri to participate in the exchange
      final String redirectUri =
          widget.queryParameters['redirect_uri'] ??
          Uri.base.origin + Uri.base.path;

      await service.setWhatsappCredentials(
        code: code,
        redirectUri: redirectUri,
      );

      if (mounted) {
        Toast.showMessage(
          context.l10n.settings_integrations_whatsapp_success,
          ToastType.success,
        );
        context.go('/church-profile');
      }
    } on DioException catch (e) {
      if (mounted) {
        final dynamic data = e.response?.data;
        String? backendMessage;
        if (data is Map) {
          backendMessage = data['message']?.toString();
        }

        setState(() {
          _isLoading = false;
          _errorMessage =
              backendMessage ??
              '${context.l10n.settings_integrations_whatsapp_callback_error_generic} ${e.message}';
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _errorMessage =
              '${context.l10n.settings_integrations_whatsapp_callback_error_generic} ${e.toString()}';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (_isLoading) ...[
              const CircularProgressIndicator(),
              const SizedBox(height: 24),
              Text(
                context.l10n.settings_integrations_whatsapp_callback_loading,
                style: const TextStyle(fontFamily: AppFonts.fontText),
              ),
            ] else if (_errorMessage != null) ...[
              const Icon(Icons.error_outline, color: Colors.red, size: 48),
              const SizedBox(height: 16),
              Text(
                _errorMessage!,
                style: const TextStyle(
                  fontFamily: AppFonts.fontText,
                  color: Colors.red,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () => context.go('/church-profile'),
                child: Text(
                  context
                      .l10n
                      .settings_integrations_whatsapp_callback_button_back,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
