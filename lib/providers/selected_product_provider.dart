import 'package:flutter/material.dart';
import 'package:mozo_app/models/models.dart';

class SelectedProductProvider extends ChangeNotifier {
  List<SavedProduct> selectedProducts = [];
  int total = 0;
  int qtySelected = 0;

  bool haveAnything = false;

  addProduct(String name, int price, int? promox2, int? promox3) {
    final haveProduct = selectedProducts.any((e) => e.name == name);

    if (haveProduct) {
      final index = selectedProducts.indexWhere((e) => e.name == name);

      if (promox2 != null && (selectedProducts[index].qty + 1) % 2 == 0) {
        selectedProducts[index].qty++;
        selectedProducts[index].price =
            promox2 * (selectedProducts[index].qty ~/ 2);
      } else if (promox3 != null &&
          (selectedProducts[index].qty + 1) % 3 == 0) {
        selectedProducts[index].qty++;
        selectedProducts[index].price =
            promox3 * (selectedProducts[index].qty ~/ 3);
      } else if (promox2 != null &&
          promox3 != null &&
          (selectedProducts[index].qty + 1) % 3 != 0) {
        //tiene ambas promociones y debe contemplar los múltiplos de 2 y 3 para agrupar las promociones
        if ((selectedProducts[index].qty - 1) % 3 == 0) {
          selectedProducts[index].qty++;
          selectedProducts[index].price =
              promox3 * ((selectedProducts[index].qty - 2) ~/ 3) + promox2;
        } else {
          selectedProducts[index].qty++;
          selectedProducts[index].price =
              promox3 * ((selectedProducts[index].qty - 1) ~/ 3) + price;
        }
      } else {
        selectedProducts[index].price += price;
        selectedProducts[index].qty++;
      }
    } else {
      selectedProducts.add(
        SavedProduct(
          name: name,
          price: price,
          promox2: promox2,
          promox3: promox3,
          qty: 1,
        ),
      );
      haveAnything = true;
    }
    sumSelectedProducts();
    notifyListeners();
  }

  removeProduct(String name, int price, int? promox2, int? promox3) {
    final haveProduct = selectedProducts.any((e) => e.name == name);

    if (haveProduct) {
      final index = selectedProducts.indexWhere((e) => e.name == name);
      if (selectedProducts[index].qty - 1 == 0) {
        selectedProducts.remove(selectedProducts[index]);
      } else if (promox2 == null && promox3 == null) {
        // no tiene promos disponibles
        selectedProducts[index].qty--;
        selectedProducts[index].price = price * selectedProducts[index].qty;
      } else if (promox2 != null && promox3 == null) {
        // sólo tiene promo x2
        if ((selectedProducts[index].qty - 1) % 2 == 0) {
          selectedProducts[index].qty--;
          selectedProducts[index].price =
              promox2 * (selectedProducts[index].qty ~/ 2);
        } else {
          selectedProducts[index].qty--;
          selectedProducts[index].price =
              promox2 * ((selectedProducts[index].qty - 1) ~/ 2) + price;
        }
      } else if (promox2 == null && promox3 != null) {
        // sólo tiene promo x3
        if ((selectedProducts[index].qty - 1) % 3 == 0) {
          selectedProducts[index].qty--;
          selectedProducts[index].price =
              promox3 * (selectedProducts[index].qty ~/ 3);
        } else if ((selectedProducts[index].qty - 1) % 3 != 0) {
          if ((selectedProducts[index].qty - 3) % 3 == 0) {
            selectedProducts[index].qty--;
            selectedProducts[index].price =
                promox3 * (selectedProducts[index].qty ~/ 3) + price * 2;
          } else {
            selectedProducts[index].qty--;
            selectedProducts[index].price =
                promox3 * (selectedProducts[index].qty ~/ 3) + price;
          }
        }
      } else {
        //tiene ambas promociones
        if ((selectedProducts[index].qty - 1) % 2 == 0) {
          selectedProducts[index].qty--;
          selectedProducts[index].price =
              promox2! * (selectedProducts[index].qty ~/ 2);
        } else if ((selectedProducts[index].qty - 1) % 3 == 0) {
          selectedProducts[index].qty--;
          selectedProducts[index].price =
              promox3! * (selectedProducts[index].qty ~/ 3);
        } else if ((selectedProducts[index].qty - 1) % 3 != 0) {
          if ((selectedProducts[index].qty - 3) % 3 == 0) {
            selectedProducts[index].qty--;
            selectedProducts[index].price =
                promox3! * (selectedProducts[index].qty ~/ 3) + promox2!;
          } else {
            selectedProducts[index].qty--;
            selectedProducts[index].price =
                promox3! * (selectedProducts[index].qty ~/ 3) + price;
          }
        }
      }
    }

    if (qtySelected - 1 == 0) {
      haveAnything = false;
    }

    sumSelectedProducts();
    notifyListeners();
  }

  sumSelectedProducts() {
    total = selectedProducts.fold(0, (i, j) => i + j.price);
    qtySelected = selectedProducts.fold(0, (i, j) => i + j.qty);
  }

  removeEverything() {
    selectedProducts.clear();
    haveAnything = false;
    total = 0;
    qtySelected = 0;
    notifyListeners();
  }
}
