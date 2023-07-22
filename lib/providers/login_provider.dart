import 'package:flutter/material.dart';

class LoginProvider extends ChangeNotifier {
  GlobalKey<FormState> urlKey = GlobalKey();

  String requestUrl = '';

  bool isValid() {
    return urlKey.currentState?.validate() ?? false;
  }
}
