import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/member_registration_link_model.dart';
import '../services/member_registration_link_service.dart';

class MemberRegistrationLinkStore extends ChangeNotifier {
  final MemberRegistrationLinkService _service;

  bool loading = false;
  String? error;
  MemberRegistrationLinkModel? link;

  MemberRegistrationLinkStore({MemberRegistrationLinkService? service})
      : _service = service ?? MemberRegistrationLinkService();

  Future<void> load() async {
    loading = true;
    error = null;
    link = null;
    notifyListeners();

    try {
      link = await _service.getRegistrationLink();
      loading = false;
      notifyListeners();
    } on DioException catch (e) {
      loading = false;
      final statusCode = e.response?.statusCode;
      if (statusCode == 401 || statusCode == 403) {
        error = 'permission';
      } else {
        error = 'generic';
      }
      notifyListeners();
    } catch (e) {
      loading = false;
      error = 'generic';
      notifyListeners();
    }
  }

  Future<void> copyLink() async {
    if (link == null) return;
    await Clipboard.setData(ClipboardData(text: link!.registrationUrl));
  }

  Future<bool> shareOnWhatsApp(String message) async {
    if (link == null) return false;
    final encodedText = Uri.encodeComponent(message);
    final url = Uri.parse('https://wa.me/?text=$encodedText');
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
      return true;
    }
    return false;
  }
}
