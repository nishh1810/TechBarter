import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tech_barter/components/custom_button.dart';
import 'package:tech_barter/utils/route_strings.dart';

class CheckoutDone extends StatelessWidget {
  const CheckoutDone({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.green.shade100,
                  shape: BoxShape.circle,
                ),
                padding: const EdgeInsets.all(24),
                child: const Icon(
                  Icons.check_circle_outline,
                  color: Colors.green,
                  size: 80,
                ),
              ),
              const SizedBox(height: 32),
              Text(
                "Order Completed!",
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.green.shade800,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                "Thank you for your purchase",
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: Colors.grey.shade600,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                "Your order has been successfully placed",
                style: Theme.of(context).textTheme.bodyLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: 200,
                child: CustomBlueButton(
                  label: "View Orders",
                  onPressed: () {
                    GoRouter.of(context).pushReplacement(RouteName.orderPage);
                  },
                ),
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () {
                  GoRouter.of(context).pushReplacement(RouteName.home);
                },
                child: const Text("Continue Shopping"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}