import 'package:church_finance_bk/features/auth/auth_persistence.dart';
import 'package:flutter/material.dart';

import '../models/trend_model.dart';
import '../services/trend_service.dart';

class TrendStore extends ChangeNotifier {
  final TrendService _service = TrendService();

  TrendResponse? _trendResponse;
  bool _isLoading = false;
  String? _error;

  TrendResponse? get trendResponse => _trendResponse;

  bool get isLoading => _isLoading;

  String? get error => _error;

  Future<void> fetchTrends() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final session = await AuthPersistence().restore();
      if (session.churchId.isEmpty) {
        _isLoading = false;
        notifyListeners();
        return;
      }

      final now = DateTime.now();
      _trendResponse = await _service.getTrends(
        churchId: session.churchId,
        year: now.year,
        month: now.month,
      );
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
