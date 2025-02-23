import 'package:flutter/material.dart';
import 'package:tech_barter/platforms/payment_element.dart';
import 'package:tech_barter/services/payment_service.dart';

import 'loading_button.dart';

class PaymentExample extends StatefulWidget {
  const PaymentExample({super.key});

  @override
  State<PaymentExample> createState() => _PaymentExampleState();
}

class _PaymentExampleState extends State<PaymentExample> {

  String? clientSecret;

  @override
  void initState() {
    _getPaymentIntent();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Flutter Stripe Integration'),
      ),
      body: Column(
        children: [
          Container(
              child: clientSecret != null
                  ? PlatformPaymentElement(clientSecret)
                  : Center(child: CircularProgressIndicator())),
          LoadingButton(onPressed: pay, text: 'Pay'),
        ],
      ),
    );
  }

  void _getPaymentIntent() async {
    try {
      Map<String, dynamic>? data = await PaymentService.createPaymentIntent(1000, "USD");
      setState(() {
        clientSecret = data!['clientSecret'];
      });
    } catch(e) {
      print(e);
    }
  }
}
