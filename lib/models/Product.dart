import 'dart:convert';

import 'package:tech_barter/models/RefType.dart';

class Product {
  String? id;
  String? name;
  String? description;
  double? price;
  int? quantity;
  RefType? category;
  RefType? seller;

  Product(
      {this.id,
        this.name,
        this.description,
        this.price,
        this.quantity,
        this.category,
        this.seller});

  Product.fromJson(Map<String, dynamic> json) {
    try {
      id = json['id'];
      name = json['name'];
      description = json['description'];
      price = json['price'];
      quantity = json['quantity'];
      category = json['category'] != null ? RefType.fromJson(json['category']) : null;
      seller = json['seller'] != null ? RefType.fromJson(json['seller']) : null;
    } catch (e) {
      print("Error in Product.fromJson: $e");
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};

    data['id'] = id;
    data['name'] = name;
    data['description'] = description;
    data['price'] = price;
    data['quantity'] = quantity;
    if (category != null) {
      data['category'] = category!.toJson();
    }
    if (seller != null) {
      data['seller'] = seller!.toJson();
    }
    return data;
  }

  @override
  String toString() {
    return 'Product(id: $id, name: $name, price: $price, quantity: $quantity)';
  }
}
