import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

import 'package:mozo_app/models/models.dart';

class ProductProvider extends ChangeNotifier {
  List<Product> productList = [];
  bool isLoading = false;

  Future<List<Product>> getProducts(String requestUrl) async {
    isLoading = true;
    notifyListeners();

    final rawUrl = Uri.parse(requestUrl);

    final url = Uri.https(rawUrl.host, rawUrl.path);
    final response = await http.get(url);

    final Map<String, dynamic> productMap = json.decode(response.body);
    productMap.forEach((key, value) {
      final product = Product.fromJson(value);
      product.id = key;
      productList.add(product);
    });

    isLoading = false;
    notifyListeners();
    return productList;
    //! HACER UNA VALIDACIÓN PARA LAS URL QUE NO ARROJEN NADA O SEAN ERRONEAS
  }

  exit() {
    productList = [];
    isLoading = false;
    notifyListeners();
  }
}
