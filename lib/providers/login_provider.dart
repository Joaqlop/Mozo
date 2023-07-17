import 'package:flutter/material.dart';

class LoginProvider extends ChangeNotifier {
  GlobalKey<FormState> urlKey = GlobalKey();

  String requestUrl = '';
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  bool isValid() {
    return urlKey.currentState?.validate() ?? false;
  }

  exit() {
    urlKey = GlobalKey();
    requestUrl = '';
    notifyListeners();
  }
}
