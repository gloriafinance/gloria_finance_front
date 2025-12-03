import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Store responsável por gerenciar o locale atual da aplicação.
///
/// Mantém a lista de idiomas suportados e persiste a escolha do usuário
/// utilizando [SharedPreferences].
class LocaleStore extends ChangeNotifier {
  static const _prefsKey = 'app_locale';

  LocaleStore() {
    _loadSavedLocale();
  }

  final List<Locale> supportedLocales = const [
    Locale('pt', 'BR'),
    Locale('es'),
    Locale('en'),
  ];

  Locale _locale = const Locale('pt', 'BR');

  Locale get locale => _locale;

  Future<void> setLocale(Locale newLocale) async {
    if (!supportedLocales.contains(newLocale)) return;

    _locale = newLocale;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_prefsKey, _encodeLocale(newLocale));
  }

  Future<void> _loadSavedLocale() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getString(_prefsKey);
    if (saved == null) return;

    final parsed = _decodeLocale(saved);
    if (parsed != null && supportedLocales.contains(parsed)) {
      _locale = parsed;
      notifyListeners();
    }
  }

  String _encodeLocale(Locale locale) {
    return locale.countryCode == null || locale.countryCode!.isEmpty
        ? locale.languageCode
        : '${locale.languageCode}_${locale.countryCode}';
  }

  Locale? _decodeLocale(String value) {
    final parts = value.split('_');
    if (parts.isEmpty || parts[0].isEmpty) return null;
    if (parts.length == 1) return Locale(parts[0]);
    return Locale(parts[0], parts[1]);
  }
}

