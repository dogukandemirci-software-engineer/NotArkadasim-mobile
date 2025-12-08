import 'package:flutter/material.dart';

class PhotoProvider with ChangeNotifier {
  String? _photoPath;

  String? get photoPath => _photoPath;

  void setPhoto(String path) {
    _photoPath = path;
    notifyListeners();
  }

  void clearPhoto() {
    _photoPath = null;
    notifyListeners();
  }
}