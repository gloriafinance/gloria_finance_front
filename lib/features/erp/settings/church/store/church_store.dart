import 'package:flutter/material.dart';
import '../models/church_model.dart';
import '../services/church_service.dart';

class ChurchStore extends ChangeNotifier {
  final ChurchService _service;
  ChurchModel? _church;
  bool _isLoading = false;
  String? _errorMessage;

  ChurchStore(this._service);

  ChurchModel? get church => _church;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> loadChurch(String churchId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _church = await _service.getChurch(churchId);
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateChurch(ChurchModel church) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _service.updateChurch(church);
      _church = church;
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> uploadLogo(dynamic file) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // Assuming file is MultipartFile or can be converted.
      // For simplicity in Store, we expect MultipartFile here.
      // dependent on UI implementation.
      // If we pass File, we convert here?
      // Better to pass MultipartFile from UI to Service?
      // Service takes MultipartFile.

      await _service.uploadLogo(file);
      if (_church != null) {
        // Update local state with new logo URL if church model has logoUrl
        // _church = _church!.copyWith(logoUrl: url);
        // Need to check ChurchModel for logoUrl field.
        // If not present, we might need to reload church or add field.
        // For now, reload church to be safe.
        await loadChurch(_church!.churchId);
      }
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
