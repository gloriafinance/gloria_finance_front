import 'package:flutter/material.dart';
import 'package:gloria_finance/features/erp/settings/integrations/services/integrations_service.dart';

class WhatsappTestMessageStore extends ChangeNotifier {
  final IntegrationsService _service;
  bool _isSending = false;

  WhatsappTestMessageStore(this._service);

  bool get isSending => _isSending;

  Future<bool> send(String recipient) async {
    if (_isSending) {
      return false;
    }

    _isSending = true;
    notifyListeners();

    try {
      await _service.sendWhatsappTestMessage(to: recipient);
      return true;
    } catch (_) {
      return false;
    } finally {
      _isSending = false;
      notifyListeners();
    }
  }
}
