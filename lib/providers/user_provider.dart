import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:tech_barter/services/api_service.dart';

import '../models/user.dart';
import 'auth_provider.dart';

class UserProvider with ChangeNotifier {
  String apiUrl = ApiService.getApiUrl();
  User? _user;
  User? get user => _user;

  UserProvider() {
    fetchUserProfile();
  }

  Future<void> fetchUserProfile() async {
    try {
      await AuthProvider.waitTillTokenLoaded();
      final url = Uri.parse('$apiUrl/user/profile');
      final response = await http.post(
        url,
        headers: {'Authorization': AuthProvider.token!},
      );
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        _user = User.fromJson(data);
        notifyListeners();
      } else {
        throw Exception("Failed to load user profile");
      }
    } catch (e) {
      print("Error fetching user profile: $e");
    }
  }
}