import 'dart:convert';


import 'package:flutter/material.dart';
import 'package:tech_barter/models/cart_product.dart';
import 'package:tech_barter/models/order.dart';
import 'package:tech_barter/models/order_response.dart';
import 'package:tech_barter/providers/auth_provider.dart';
import 'package:tech_barter/services/api_service.dart';
import 'package:http/http.dart' as http;

class OrderProvider with ChangeNotifier {
  String apiUrl = ApiService.getApiUrl();

  List<Order> _orders = [];
  List<Order> get orders => _orders;

  List<OrderResponse> _orderResponses = [];
  List<OrderResponse> get orderResponses => _orderResponses;


  Future<void> fetchOrders() async {
    try {
      final url = '$apiUrl/orders/customer';

      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': AuthProvider.token!,
        },
      );

      if(response.statusCode == 200) {
        final data = json.decode(response.body);
        _orderResponses = (data as List<dynamic>)
            .map((item) => OrderResponse.fromJson(item))
            .toList();
        notifyListeners();
      } else {
        throw Exception("Failed to load customer Orders");
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> createOrder(String customerId, List<CartProduct> cartProducts) async {
    try {
      print("create order started");
      final api = '$apiUrl/orders';

      List<Map<String, dynamic>> products = [];
      for(CartProduct cartProduct in cartProducts) {
        products.add({
          "id": cartProduct.productId,
          "quantity": cartProduct.cartQuantity,
        });
      }

      // Request body
      final Map<String, dynamic> requestBody = {
        "customerId": customerId,
        "products": products
      };

      final response = await http.post(
        Uri.parse(api),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': AuthProvider.token!,
        },
        body: jsonEncode(requestBody),
      );

      if (response.statusCode == 200) {
        print('Response body: ${response.body}');
      } else {
        throw Exception("Order request Failed");
      }
    } catch (e) {
      print('Error s: $e');
    }
  }

  Future<void> cancelOrder(String orderId) async {
    try {
      final url = '$apiUrl/orders/$orderId/cancel';

      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': AuthProvider.token!,
        }
      );

      if(response.statusCode == 200) {
        await fetchOrders();
        notifyListeners();
      } else {
        throw Exception("Failed to Cancel the order.");
      }
    } catch (e) {
      print(e.toString());
    }
  }



}