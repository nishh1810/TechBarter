import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:tech_barter/models/Items.dart';
import 'package:tech_barter/models/Product.dart';
import 'package:tech_barter/providers/auth_provider.dart';
import 'package:tech_barter/services/api_service.dart';
import 'package:http/http.dart' as http;

class CartProvider extends ChangeNotifier {
  String apiUrl = ApiService.getApiUrl();

  List<Items> _cartItems = [];
  List<Items> get cartItems => _cartItems;

  List<Product> _products = [];
  List<Product> get products => _products;

  Future<void> addToCart(Product product, String userId) async {
    try {
      final url = '$apiUrl/cart';

      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': AuthProvider.token!,
        },
        body: jsonEncode({
          'userId': userId,
          'productId': product.id,
          'quantity': 1,
        }),
      );

      if(response.statusCode == 200) {
        _products.add(product);
        notifyListeners();
      }else {
        throw Exception("Failed to add to cart");
      }
    }catch(e) {
      print(e.toString());
    }
  }

  Future<void> getCartItems(String userId) async {
    try {
      final url = '$apiUrl/cart/$userId';
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': AuthProvider.token!,
          },
      );
      if(response.statusCode == 200) {
        final data = json.decode(response.body);
        _cartItems = (data as List<dynamic>)
            .map((item) => Items.fromJson(item))
            .toList();
        notifyListeners();
      } else {
        throw Exception("Failed to load cart items");
      }
    }catch(e) {
      print(e.toString());
    }
  }
}