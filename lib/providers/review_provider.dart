import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:tech_barter/models/review.dart';
import 'package:http/http.dart' as http;
import 'package:tech_barter/providers/auth_provider.dart';
import 'package:tech_barter/services/api_service.dart';

class ReviewProvider extends ChangeNotifier {
  String apiUrl = ApiService.getApiUrl();

  double _averageRating = 0.0;
  double get averageRating => _averageRating;

  List<Review> _reviews = [];
  List<Review> get reviews => _reviews;

  Future addReview({
    required String productId,
    required String comment,
    required double rating,
  }) async {
    try {
      final uri = Uri.parse('$apiUrl/reviews');
      final body = jsonEncode({
        'productId': productId,
        'comment': comment,
        'rating': rating,
      });

      await http.post(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${AuthProvider.token!}',
        },
        body: body,
      );
    } catch (e) {
      print(e.toString());
    }
  }


  // Get reviews for a product
  Future getReviews(String productId) async {
    try {
      final uri = Uri.parse('$apiUrl/reviews/$productId');
      final response = await http.get(
        uri,
        headers: {
          'Authorization': 'Bearer ${AuthProvider.token!}',
        },
      );
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        _reviews = (data as List<dynamic>)
            .map((item) => Review.fromJson(item))
            .toList();
        notifyListeners();
      }
    } catch (e) {
      print(e.toString());
    }
  }


  Future getAverageRating(String productId) async {
    try{
      final uri = Uri.parse('$apiUrl/reviews/$productId/average-rating');
      final response = await http.get(
        uri,
        headers: {
          'Authorization': 'Bearer ${AuthProvider.token!}',
        },
      );
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        _averageRating = data['averageRating'];
        notifyListeners();
      }
    } catch(e) {
      print(e.toString());
    }
  }

}