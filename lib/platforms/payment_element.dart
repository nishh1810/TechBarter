import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_stripe_web/flutter_stripe_web.dart';
import 'package:web/web.dart' as web;

String getUrlPort() => web.window.location.port;

String getReturnUrl() => "${web.window.location.href}/process";



Future<void> pay() async {
  print(getReturnUrl());
  await WebStripe.instance.confirmPaymentElement(
    ConfirmPaymentElementOptions(
      confirmParams: ConfirmPaymentParams(
        return_url: getReturnUrl(),
      ),
    ),
  ).timeout(Duration(seconds: 10), onTimeout: () {
    throw TimeoutException("Stripe confirmation timed out");
  });
}

class PlatformPaymentElement extends StatelessWidget {
  const PlatformPaymentElement(this.clientSecret, {super.key});

  final String? clientSecret;

  @override
  Widget build(BuildContext context) {
    return PaymentElement(
      autofocus: true,
      enablePostalCode: false,
      onCardChanged: (_) {},
      clientSecret: clientSecret ?? '',
    );
  }
}