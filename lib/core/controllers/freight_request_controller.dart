import 'package:flutter/material.dart';
import 'package:levvu_client/core/models/cargo_item_model.dart';
import 'package:levvu_client/core/models/freight_request_model.dart';
import 'package:levvu_client/core/repositories/freight_repository.dart';

class FreightRequestController extends ChangeNotifier {
  final FreightRepository _repository;
  bool _isLoading = false;
  String? _error;
  String? _successMessage;
  final List<CargoItemModel> _cargoItems = [];
  final List<String> _photoUrls = [];
  final List<String> _imageUrls = [];

  FreightRequestController(this._repository);

  bool get isLoading => _isLoading;
  String? get error => _error;
  String? get successMessage => _successMessage;
  List<CargoItemModel> get cargoItems => List.unmodifiable(_cargoItems);
  List<String> get photoUrls => List.unmodifiable(_photoUrls);
  List<String> get imageUrls => List.unmodifiable(_imageUrls);

  void addCargoItem(CargoItemModel item) {
    _cargoItems.add(item);
    notifyListeners();
  }

  void removeCargoItem(int index) {
    if (index >= 0 && index < _cargoItems.length) {
      _cargoItems.removeAt(index);
      notifyListeners();
    }
  }

  void addPhoto(String url) {
    _photoUrls.add(url);
    notifyListeners();
  }

  void removePhoto(int index) {
    if (index >= 0 && index < _photoUrls.length) {
      _photoUrls.removeAt(index);
      notifyListeners();
    }
  }

  void addImage(String url) {
    _imageUrls.add(url);
    notifyListeners();
  }

  void removeImage(int index) {
    if (index >= 0 && index < _imageUrls.length) {
      _imageUrls.removeAt(index);
      notifyListeners();
    }
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }

  void clearSuccessMessage() {
    _successMessage = null;
    notifyListeners();
  }

  Future<bool> createFreightRequest(FreightRequestModel request) async {
    try {
      _isLoading = true;
      _error = null;
      _successMessage = null;
      notifyListeners();

      final response = await _repository.createFreightRequest(request);
      if (response.isSuccess) {
        _successMessage = 'Solicitação de frete criada com sucesso!';
        _cargoItems.clear();
        _photoUrls.clear();
        _imageUrls.clear();
      }
      return response.isSuccess;
    } catch (e) {
      _error = e.toString();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
