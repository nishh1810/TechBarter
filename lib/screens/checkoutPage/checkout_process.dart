import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:tech_barter/platforms/payment_element.dart';
import 'package:tech_barter/providers/cart_provider.dart';
import 'package:tech_barter/providers/order_provider.dart';
import 'package:tech_barter/providers/user_provider.dart';
import 'package:tech_barter/services/payment_service.dart';
import 'package:tech_barter/utils/route_strings.dart';

class CheckoutProcess extends StatefulWidget {
  const CheckoutProcess({super.key});

  @override
  State<CheckoutProcess> createState() => _CheckoutProcessState();
}

class _CheckoutProcessState extends State<CheckoutProcess> {
  bool _isProcessing = true;
  bool _errorOccurred = false;

  @override
  void initState() {
    _completeOrder();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: _errorOccurred
                    ? const Icon(Icons.error_outline,
                    color: Colors.red, size: 80)
                    : const CircularProgressIndicator(
                  strokeWidth: 6,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                  semanticsLabel: 'Processing',
                ),
              ),
              const SizedBox(height: 32),
              Text(
                _errorOccurred ? "Payment Failed" : "Processing Payment",
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: _errorOccurred ? Colors.red : Colors.blue,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                _errorOccurred
                    ? "We encountered an issue processing your payment. Please try again."
                    : "Please wait while we process your payment...",
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Colors.grey.shade600,
                ),
              ),
              if (_errorOccurred) ...[
                const SizedBox(height: 32),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _errorOccurred = false;
                      _isProcessing = true;
                    });
                    _completeOrder();
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 32, vertical: 16),
                  ),
                  child: const Text("Try Again"),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _completeOrder() async {
    try {
      final url = getReturnUrl();
      final uri = Uri.parse(url);
      final paymentIntentId = uri.queryParameters["payment_intent"];

      if (paymentIntentId == null) {
        throw Exception("Payment intent ID not found");
      }

      await PaymentService.confirmPayment(paymentIntentId);

      final userId = Provider.of<UserProvider>(context, listen: false).user?.id;
      if (userId != null) {
        final cartProducts =
            Provider.of<CartProvider>(context, listen: false).cartProducts;
        await Provider.of<OrderProvider>(context, listen: false)
            .createOrder(userId, cartProducts);
        Provider.of<CartProvider>(context, listen: false).clearCart();
      }

      if (mounted) {
        context.go(RouteName.checkoutDonePage);
      }
    } catch (e) {
      debugPrint("Error completing order: $e");
      if (mounted) {
        setState(() {
          _isProcessing = false;
          _errorOccurred = true;
        });
      }
    }
  }
}