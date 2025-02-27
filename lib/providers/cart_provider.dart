import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:tech_barter/models/Items.dart';
import 'package:tech_barter/models/cart_product.dart';
import 'package:tech_barter/providers/auth_provider.dart';
import 'package:tech_barter/services/api_service.dart';
import 'package:http/http.dart' as http;

class CartProvider extends ChangeNotifier {
  String apiUrl = ApiService.getApiUrl();

  List<Items> _cartItems = [];
  List<Items> get cartItems => _cartItems;

  List<CartProduct> _cartProducts = [];
  List<CartProduct> get cartProducts => _cartProducts;

  double _totalAmount = 0.0;
  double get totalAmount {
    _totalAmount = 0.0;
    for (var cartProduct in _cartProducts) {
      _totalAmount += cartProduct.total!;
    }
    return _totalAmount;
  }

  double _taxAmount = 0.0;
  double get taxAmount {
    _taxAmount = _totalAmount * 0.13;
    return _taxAmount;
  }

  double _finalAmount = 0.0;
  double get finalAmount {
    _finalAmount = totalAmount + taxAmount;
    return _finalAmount;
  }

  CartProvider() {
    getCartItems();
  }

  Future<void> addToCart(String productId, String userId, int quantity) async {
    // try {
      final url = '$apiUrl/cart';

      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': AuthProvider.token!,
        },
        body: jsonEncode({
          'userId': userId,
          'productId': productId,
          'quantity': quantity,
        }),
      );

      if(response.statusCode == 201) {
        await getCartItems();
        notifyListeners();
      }else {
        print("response : ${response.body.toString()}");
        throw Exception("Failed to add to cart");
      }
    // }catch(e) {
    //   print(e.toString());
    // }
  }

  Future<void> getCartItems() async {
    try {
      final url = '$apiUrl/cart';
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': AuthProvider.token!,
          },
      );
      if(response.statusCode == 200) {
        final data = json.decode(response.body);
        _cartProducts = (data as List<dynamic>)
            .map((item) => CartProduct.fromJson(item))
            .toList();
        totalAmount;
        notifyListeners();
      } else {
        throw Exception("Failed to load cart items");
      }
    }catch(e) {
      print(e.toString());
    }
  }

  Future<void> removeFromCart(String productId) async {
    try {
      final url = '$apiUrl/cart/removeProduct/$productId';
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': AuthProvider.token!,
        },
      );
      if(response.statusCode == 200) {
        await getCartItems();
        notifyListeners();
      } else {
        throw Exception("Failed to remove product from cart");
      }
    }catch(e) {
      print(e.toString());
    }
  }

  Future<void> clearCart() async {
    try {
      final url = '$apiUrl/cart/remove';
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': AuthProvider.token!,
        },
      );
      if(response.statusCode == 200) {
        cartItems.clear();
        print("cart clear response : ${response.body.toString()}");
        notifyListeners();
      } else {
        throw Exception("Failed to load cart items");
      }
    }catch(e) {
      print(e.toString());
    }
  }


}