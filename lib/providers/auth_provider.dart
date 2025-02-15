import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:tech_barter/utils/shared_preference_helper.dart';

import '../services/api_service.dart';

class AuthProvider extends ChangeNotifier {
  static String? _token;
  bool get isAuthenticated => _token != null;
  static String? get token => _token;
  String apiUrl = ApiService.getApiUrl();

  AuthProvider() {
    _loadToken();
  }

  Future<void> _loadToken() async {
    _token = await SPHelper.getData(SPHelper.KEY_TOKEN);
    if(token != null) {
      await validateToken().then((value) {
        if (!value) {
          logout();
        }
      });
    }
    notifyListeners();
  }

  Future<bool> validateToken() async {
    try {
      final url = Uri.parse('$apiUrl/user/validate-token');
      final response = await http.post(
        url,
        headers: {'Authorization': AuthProvider.token!},
      );
      if (response.statusCode == 200) {
        bool valid = json.decode(response.body);
        if (valid) {
          print("Token is valid");
          return true;
        }
      } else {
        throw Exception("Invalid token");
      }
    } catch (e) {
      print("Error validating token: $e");
    }
    return false;
  }

  static Future<void> waitTillTokenLoaded() async {
    if (AuthProvider.token == null) {
      print("Waiting for token...");
      await Future.doWhile(() async {
        await Future.delayed(Duration(milliseconds: 500));
        return AuthProvider.token == null;
      }).timeout(Duration(seconds: 3));
    }
    return;
  }

  Future<void> signup(String name, String email, String username, String password) async {
    final url = Uri.parse('$apiUrl/auth/register');

    Map<String, String> requestBody = {
      "name":name,
      "email":email,
      "username":username,
      "password":password
    };

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode(requestBody),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      print("Message: ${data['message']}");
      notifyListeners();
    } else {
      throw Exception("Invalid credentials");
    }
  }

  Future<void> login(String username, String password) async {
    final url = Uri.parse('$apiUrl/auth/login');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'username': username, 'password': password}),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      _token = data['token'];

      await SPHelper.setData(SPHelper.KEY_TOKEN, _token);
      notifyListeners();
    } else {
      throw Exception("Invalid credentials");
    }
  }

  Future<void> logout() async {
    await SPHelper.removeData(SPHelper.KEY_TOKEN);
    await SPHelper.removeData(SPHelper.KEY_SELECTED_PRODUCT);
    _token = null;
    notifyListeners();
  }
}