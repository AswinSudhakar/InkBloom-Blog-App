import 'package:flutter/material.dart';
import 'package:inkbloom/service/categoryservice.dart';

class CategoryProvider extends ChangeNotifier {
  bool _isUpdating = false;
  String? _error;
  String? _successMessage;
  List<String> usercategory = [];

  bool get isUpdating => _isUpdating;
  String? get error => _error;
  String? get successMessage => _successMessage;

  Future<List<String>?> fetchusercategory() async {
    _error = null;
    notifyListeners();

    try {
      List<String>? result = await Categoryservice().getuserCAtegory();
      usercategory = result ?? [];

      return usercategory;
    } catch (e) {
      _error = "Failed to fetch usercategories: $e";
    }

    notifyListeners();
    return null;
  }

  Future<void> updateUserCategories(List<String> selectedCategories) async {
    _isUpdating = true;
    _error = null;
    _successMessage = null;
    notifyListeners();

    try {
      final responseMessage =
          await Categoryservice().updateCategories(selectedCategories);
      _successMessage = responseMessage ?? "Updated successfully!";
    } catch (e) {
      _error = "Failed to update categories: $e";
    }

    _isUpdating = false;
    notifyListeners();
  }

  void clearStatus() {
    _error = null;
    _successMessage = null;
    notifyListeners();
  }
}
