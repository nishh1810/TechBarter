import 'dart:math';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class ApiService {

  static String apiUrl = dotenv.env['API_URL'] ?? "";

  static String getApiUrl() {
    return "$apiUrl/api";
  }

  static void printEnv() {
    print('API URL: $apiUrl');
  }


  static Future<String> loadImage(String? id) async {
    try {
      // throw Exception("Don't use firebase"); /// TODO: Comment this line to load real product Image
      if(id == null || id.isEmpty) throw Exception("Invalid product id");
      final url = '$apiUrl/api/image/$id';

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
        throw Exception(e.toString());
      }
    } catch(e) {
      print(e);
      return "https://picsum.photos/id/${Random().nextInt(500)}/3000/2000";
    }
  }
}