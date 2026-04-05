import 'package:flutter/material.dart';

class LoadingProvider with ChangeNotifier {
  bool _isLoading = false;
  String _message = 'جاري المعالجة...';

  bool get isLoading => _isLoading;
  String get message => _message;

  void show([String message = 'جاري المعالجة...']) {
    _message = message;
    _isLoading = true;
    notifyListeners();
  }

  void hide() {
    _isLoading = false;
    notifyListeners();
  }
}
