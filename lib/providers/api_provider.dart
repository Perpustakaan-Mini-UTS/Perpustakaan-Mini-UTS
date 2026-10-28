import 'package:flutter/material.dart';
import '../models/catalog_model.dart';
import '../services/api_service.dart';
import 'view_state.dart';

class ApiProvider extends ChangeNotifier {
  final ApiService _apiService = ApiService();

  ViewState _state = ViewState.loading;
  List<CatalogModel> _catalogs = [];
  String? _errorMessage;

  ViewState get state => _state;
  List<CatalogModel> get catalogs => _catalogs;
  String? get errorMessage => _errorMessage;

  ApiProvider() {
    fetchCatalogs();
  }

  Future<void> fetchCatalogs() async {
    _state = ViewState.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      final data = await _apiService.fetchCatalog();
      _catalogs = data;
      if (_catalogs.isEmpty) {
        _state = ViewState.empty;
      } else {
        _state = ViewState.loaded;
      }
    } catch (e) {
      _state = ViewState.error;
      _errorMessage = e.toString().replaceAll('Exception: ', '');
    } finally {
      notifyListeners();
    }
  }
}
