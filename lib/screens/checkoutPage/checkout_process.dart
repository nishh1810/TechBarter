import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tech_barter/platforms/payment_element.dart';
import 'package:tech_barter/services/payment_service.dart';
import 'package:tech_barter/utils/route_strings.dart';

class CheckoutProcess extends StatefulWidget {
  const CheckoutProcess({super.key});

  @override
  State<CheckoutProcess> createState() => _CheckoutProcessState();
}

class _CheckoutProcessState extends State<CheckoutProcess> {

  @override
  void initState() {
    _completeOrder();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        height: MediaQuery.of(context).size.height * 0.8,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, color: Colors.red, size: 80),
              SizedBox(height: 16),
              Text(
                "Processing",
                style: Theme.of(context).textTheme.displayLarge,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _completeOrder() async {
    print("complete order called");
    String url = getReturnUrl();
    Uri uri = Uri.parse(url);
    String? paymentIntentId = uri.queryParameters["payment_intent"];
    await PaymentService.confirmPayment(paymentIntentId!).then((value) {
      // print("confirm value : $value");
      context.go(RouteName.checkoutDonePage);
    });

    // String? userId = Provider.of<UserProvider>(context, listen: false).user?.id;
    // print("user id: $userId");
    // if(userId != null) {
    //   List<CartProduct> cartProducts = Provider.of<CartProvider>(context, listen: false).cartProducts;
    //   await Provider.of<OrderProvider>(context, listen: false).createOrder(userId,cartProducts);
    //   Provider.of<CartProvider>(context, listen: false).clearCart();
    // }
  }
}
