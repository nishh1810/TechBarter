import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiService {

  static String apiUrl = dotenv.env['API_URL'] ?? 'https://default.com';

  static String getApiUrl() {
    return "$apiUrl/api";
  }

  static void printEnv() {
    print('API URL: $apiUrl');
  }
}