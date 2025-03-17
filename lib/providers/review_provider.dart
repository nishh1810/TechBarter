import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:tech_barter/models/review.dart';
import 'package:http/http.dart' as http;
import 'package:tech_barter/providers/auth_provider.dart';
import 'package:tech_barter/services/api_service.dart';
import 'package:tech_barter/utils/shared_preference_helper.dart';

class ReviewProvider extends ChangeNotifier {
  String apiUrl = ApiService.getApiUrl();

  double _averageRating = 0.0;
  double get averageRating => _averageRating;

  List<Review> _reviews = [];
  List<Review> get reviews => _reviews;

  ReviewProvider() {
    SPHelper.getData(SPHelper.KEY_SELECTED_PRODUCT_REVIEWS).then((value) {
      if(value != null) {
        final data = json.decode(value);
        _reviews = (data as List<dynamic>)
            .map((item) => Review.fromJson(item))
            .toList();
      }
    });
  }

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
          'Authorization': AuthProvider.token!,
        },
        body: body,
      ).then((response) {
        print("statuscode: ${response.statusCode}");
        print("body: ${response.body}");
        if(response.statusCode == 201) {
          getReviews(productId);
        }
      });
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
          'Authorization': AuthProvider.token!,
        },
      );
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        _reviews = (data as List<dynamic>)
            .map((item) => Review.fromJson(item))
            .toList();
        SPHelper.setData(SPHelper.KEY_SELECTED_PRODUCT_REVIEWS, json.encode(_reviews));
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
          'Authorization': AuthProvider.token!,
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