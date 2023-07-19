import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SavedUrlProvider extends ChangeNotifier {
  List<String> savedUrl = [];
  bool haveAnything = false;

  loadUrlDb() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    savedUrl = prefs.getStringList('savedUrl') ?? [];

    if (savedUrl.isEmpty) return;
    haveAnything = true;
    notifyListeners();
  }

  saveUrl(String requestUrl) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final sameUrl = savedUrl.any((e) => e == requestUrl);

    if (sameUrl) return;

    savedUrl.add(requestUrl);
    prefs.setStringList('savedUrl', savedUrl);
    haveAnything = true;
    notifyListeners();
  }

  removeUrl(String requestUrl) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    savedUrl.remove(requestUrl);
    prefs.setStringList('savedUrl', savedUrl);

    notifyListeners();

    if (savedUrl.isNotEmpty) return;
    haveAnything = false;
    notifyListeners();
  }

  removeEverything() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    savedUrl.clear();
    prefs.setStringList('savedUrl', savedUrl);

    haveAnything = false;
    notifyListeners();
  }
}
