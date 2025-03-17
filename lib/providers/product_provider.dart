import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:tech_barter/models/Product.dart';
import 'package:tech_barter/services/api_service.dart';
import 'package:http/http.dart' as http;
import 'package:tech_barter/utils/shared_preference_helper.dart';

class ProductProvider extends ChangeNotifier {
  String apiUrl = ApiService.getApiUrl();

  List<Product> _bestSellingProducts = [];
  List<Product> get getBestSellingProducts => _bestSellingProducts;

  List<Product> _relatedProducts = [];
  List<Product> get relatedProducts => _relatedProducts;

  List<Product> _recyclableProduct = [];
  List<Product> get recyclableProducts => _recyclableProduct;

  List<Product> _randomProducts = [];
  List<Product> get randomProducts => _randomProducts;

  List<Product> _searchProducts = [];
  List<Product> get searchProducts => _searchProducts;

  Product? _selectedProduct;
  Product? get getSelectedProduct => _selectedProduct;
  void setSelectedProduct(Product product) => _selectedProduct = product;

  ProductProvider() {
    loadProductProvider();
    loadAllProducts();
  }

  void loadProductProvider() {
    SPHelper.getData(SPHelper.KEY_SELECTED_PRODUCT).then((value) {
      if(value != null) {
        _selectedProduct = Product.fromJson(json.decode(value));
      }
    });
  }

  Future<void> loadAllProducts() async {
    SPHelper.getData(SPHelper.KEY_PRODUCTS).then((value) {
      if(value != null) {
        _searchProducts = (json.decode(value) as List<dynamic>)
            .map((item) => Product.fromJson(item))
            .toList();
      }
    });
  }

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

  Future<void> getRecyclableProducts() async {
    try {
      final url = '$apiUrl/products/recyclable';

      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if(response.statusCode == 200) {
        final data = json.decode(response.body);
        _recyclableProduct = (data as List<dynamic>)
            .map((item) => Product.fromJson(item))
            .toList();
        notifyListeners();
      } else {
        throw Exception("Failed to load recyclable products");
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> getProducts() async {
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
        _searchProducts = (data as List<dynamic>)
            .map((item) => Product.fromJson(item))
            .toList();
        SPHelper.setData(SPHelper.KEY_PRODUCTS, json.encode(_searchProducts));
        notifyListeners();
      } else {
        throw Exception("Failed to load search products");
      }
    } catch (e) {
      print(e);
    }
  }

  Future<String> loadProductImage(String? id) async {
    try {
      // throw Exception("Don't use firebase"); /// TODO: Comment this line to load real product Image
      if(id == null || id.isEmpty) throw Exception("Invalid product id");
      final url = '$apiUrl/image/$id';

      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/String'
        },
      );

      if(response.statusCode == 200) {
        // print("loadProductImage: ${response.body}");
        return response.body;
      } else {
        throw Exception("Failed to load related products");
      }
    } catch(e) {
      print(e);
      return "https://picsum.photos/id/${Random().nextInt(500)}/3000/2000";
    }
  }
}