import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:tech_barter/utils/shared_preference_helper.dart';
import 'package:tech_barter/providers/auth_provider.dart';
import 'package:tech_barter/services/api_service.dart';

class PaymentService {
  static String apiUrl = ApiService.getApiUrl();

  static Future<Map<String, dynamic>?> createPaymentIntent(double amount, String currency) async {
    final url = Uri.parse('$apiUrl/payment/intent?amount=$amount&currency=$currency');

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': AuthProvider.token!,
      },
    );

    if (response.statusCode == 200) {
      dynamic data = jsonDecode(response.body);
      Map<String, dynamic> intentResponse = data;
      intentResponse['paymentIntentId'] = data['paymentIntentId'];
      intentResponse['clientSecret'] = data['clientSecret'];
      return intentResponse;
    }
    return null;
  }

  static Future<bool> confirmPayment(String paymentIntentId) async {
    final url = Uri.parse('$apiUrl/payment/confirm');

    String token = await SPHelper.getData(SPHelper.KEY_TOKEN);

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': token,
      },
      body: paymentIntentId.toString(),
    );

    if (response.statusCode == 200) {
      return true;
    }

    return false;
  }
}
