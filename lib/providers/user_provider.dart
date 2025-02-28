import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:tech_barter/models/address.dart';
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

  Future<void> updateAddress(Address address) async {
    try {
      await AuthProvider.waitTillTokenLoaded();
      final url = Uri.parse('$apiUrl/user/address');
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': AuthProvider.token!
        },
        body: json.encode(address.toJson()),
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


  Future<void> updateProfileImage(dynamic image) async {
    try {
      final url = '$apiUrl/user/profile-image';

      var request = http.MultipartRequest("POST", Uri.parse(url),);

      request.headers['Authorization'] = AuthProvider.token!;
      request.files.add(
        http.MultipartFile.fromBytes(
          'file',
          image as List<int>,
          filename: "image_${DateTime.now().millisecondsSinceEpoch}.jpg",
          contentType: MediaType('image', 'jpeg'),
        ),
      );

      var response = await request.send();

      if (response.statusCode == 200) {
        print("User image updated successfully");
      } else {
        throw Exception("Failed to update user image");
      }
    } catch (e) {
      print("Error fetching user profile: $e");
    }
  }
}