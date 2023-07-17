import 'package:flutter/material.dart';

class SavedUrlProvider extends ChangeNotifier {
  List<String> savedUrl = [];
  bool haveAnything = false;

  saveUrl(String requestUrl) {
    final sameUrl = savedUrl.any((e) => e == requestUrl);

    if (sameUrl) return;

    savedUrl.add(requestUrl);
    haveAnything = true;
    notifyListeners();
  }

  removeUrl(String url) {
    savedUrl.remove(url);
    notifyListeners();

    if (savedUrl.isNotEmpty) return;
    haveAnything = false;
    notifyListeners();
  }

  removeEverything() {
    savedUrl.clear();
    haveAnything = false;
    notifyListeners();
  }
}
