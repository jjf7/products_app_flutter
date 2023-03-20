// To parse this JSON data, do
//
//     final products = productsFromJson(jsonString);

import 'dart:convert';

Map<String, Product> productsFromJson(String str) => Map.from(json.decode(str))
    .map((k, v) => MapEntry<String, Product>(k, Product.fromJson(v)));

String productsToJson(Map<String, Product> data) => json.encode(
    Map.from(data).map((k, v) => MapEntry<String, dynamic>(k, v.toJson())));

class Product {
  Product({
    required this.available,
    required this.name,
    this.picture,
    required this.price,
    this.id,
  });

  bool available;
  String name;
  String? picture;
  double price;
  String? id;

  factory Product.fromJson(Map<String, dynamic> json) => Product(
        available: json["available"],
        name: json["name"],
        picture: json["picture"],
        price: json["price"]?.toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "available": available,
        "name": name,
        "picture": picture,
        "price": price,
      };

  Product copy() => Product(
        available: available,
        name: name,
        picture: picture,
        price: price,
        id: id,
      );
}
