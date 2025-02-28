import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tech_barter/components/custom_button.dart';
import 'package:tech_barter/utils/route_strings.dart';

class CheckoutDone extends StatefulWidget {
  const CheckoutDone({super.key});

  @override
  State<CheckoutDone> createState() => _CheckoutDoneState();
}

class _CheckoutDoneState extends State<CheckoutDone> {

  @override
  void initState() {
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
                "Completed",
                style: Theme.of(context).textTheme.displayLarge,
              ),
              SizedBox(height: 8),
              Text(
                "Thank you for order",
                style: Theme.of(context).textTheme.displayMedium,
              ),
              SizedBox(height: 20),
              SizedBox(
                width: 200,
                child: CustomBlueButton(
                  label: "Order Page",
                  onPressed: () {
                    GoRouter.of(context).pushReplacement(RouteName.home);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // void _completeOrder() async {
  //   print("complete order called");
  //   await AuthProvider().loadToken();
  //
  //   String? userId = Provider.of<UserProvider>(context, listen: false).user?.id;
  //   print("user id: $userId");
  //   if(userId != null) {
  //     List<CartProduct> cartProducts = Provider.of<CartProvider>(context, listen: false).cartProducts;
  //     await Provider.of<OrderProvider>(context, listen: false).createOrder(userId,cartProducts);
  //     Provider.of<CartProvider>(context, listen: false).clearCart();
  //   }
  // }
}
