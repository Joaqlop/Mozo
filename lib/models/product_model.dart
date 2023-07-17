import 'dart:convert';

class Product {
  String? id;
  String name;
  int price;
  int? promox2;
  int? promox3;

  Product({
    this.id,
    required this.name,
    required this.price,
    this.promox2,
    this.promox3,
  });

  factory Product.fromRawJson(String str) => Product.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Product.fromJson(Map<String, dynamic> json) => Product(
        name: json["name"],
        price: json["price"],
        promox2: json["promox2"],
        promox3: json["promox3"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "price": price,
        "promox2": promox2,
        "promox3": promox3,
      };
}
