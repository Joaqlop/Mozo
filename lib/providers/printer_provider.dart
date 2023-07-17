import 'package:flutter/material.dart';

class PrinterProvider extends ChangeNotifier {
  String savedPrinter = '';
  bool havePrinter = false;
  bool isPrinting = false;

  addSavedPrinter(String printer) {
    savedPrinter = printer;
    havePrinter = true;
    notifyListeners();
  }

  removeSavedPrinter() {
    savedPrinter = '';
    havePrinter = false;
    notifyListeners();
  }

  printing() {
    isPrinting = true;
    notifyListeners();
  }

  endPrinting() {
    isPrinting = false;
    notifyListeners();
  }
}
