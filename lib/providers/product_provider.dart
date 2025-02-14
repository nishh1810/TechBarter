import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:tech_barter/models/Product.dart';
import 'package:tech_barter/services/api_service.dart';
import 'package:http/http.dart' as http;

class ProductProvider extends ChangeNotifier {
  String apiUrl = ApiService.getApiUrl();

  List<Product> _bestSellingProducts = [];
  List<Product> get getBestSellingProducts => _bestSellingProducts ?? [];

  List<Product> _relatedProducts = [];
  List<Product> get relatedProducts => _relatedProducts ?? [];

  List<Product> _randomProducts = [];
  List<Product> get randomProducts => _randomProducts ?? [];

  Product? _selectedProduct;
  Product? get getSelectedProduct => _selectedProduct;
  void setSelectedProduct(Product product) => _selectedProduct = product;


  Future<void> loadBestSellingProducts() async {
    try {

      final url = '$apiUrl/products';

      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if(response.statusCode == 200) {
        final data = json.decode(response.body);
        _bestSellingProducts = (data as List<dynamic>)
            .map((item) => Product.fromJson(item))
            .toList();
        notifyListeners();
      } else {
        throw Exception("Failed to load products");
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> getRandomProducts(int count) async {
    try {
      final url = '$apiUrl/products/random/$count';

      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if(response.statusCode == 200) {
        final data = json.decode(response.body);
        _randomProducts = (data as List<dynamic>)
            .map((item) => Product.fromJson(item))
            .toList();
        notifyListeners();
      } else {
        throw Exception("Failed to load related products");
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> getRelatedProducts(String productId) async {
    try {
      final url = '$apiUrl/products/related/$productId';

      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if(response.statusCode == 200) {
        final data = json.decode(response.body);
        _relatedProducts = (data as List<dynamic>)
            .map((item) => Product.fromJson(item))
            .toList();
        notifyListeners();
      } else {
        throw Exception("Failed to load related products");
      }
    } catch (e) {
      print(e);
    }
  }
}