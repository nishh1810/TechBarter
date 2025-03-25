import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:tech_barter/providers/cart_provider.dart';
import 'package:tech_barter/providers/auth_provider.dart';
import 'package:tech_barter/providers/order_provider.dart';
import 'package:tech_barter/providers/product_provider.dart';
import 'package:tech_barter/providers/review_provider.dart';
import 'package:tech_barter/providers/user_provider.dart';
import 'package:tech_barter/screens/cartPage/cart_page.dart';
import 'package:tech_barter/screens/checkoutPage/checkout.dart';
import 'package:tech_barter/screens/checkoutPage/checkout_done.dart';
import 'package:tech_barter/screens/checkoutPage/checkout_process.dart';
import 'package:tech_barter/screens/homePage/home.dart';
import 'package:tech_barter/screens/login.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:tech_barter/screens/page_not_found.dart';
import 'package:tech_barter/screens/productPage/product_page.dart';
import 'package:tech_barter/screens/profilePage/address_page.dart';
import 'package:tech_barter/screens/profilePage/order_page.dart';
import 'package:tech_barter/screens/profilePage/profile_page.dart';
import 'package:tech_barter/screens/signup.dart';
import 'package:tech_barter/screens/splash_screen.dart';
import 'package:tech_barter/themes/text_theme.dart';
import 'package:tech_barter/utils/route_strings.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName:"../.env");

  Stripe.publishableKey = dotenv.env['STRIPE_PUBLISHABLE_KEY']!;
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AuthProvider()),
        ChangeNotifierProvider(create: (context) => UserProvider()),
        ChangeNotifierProvider(create: (context) => ProductProvider()),
        ChangeNotifierProvider(create: (context) => CartProvider()),
        ChangeNotifierProvider(create: (context) => ReviewProvider()),
        ChangeNotifierProvider(create: (context) => OrderProvider()),
        // ChangeNotifierProvider(create: (context) => CheckoutProvider()),
      ],
      child: MyApp(),
    )
  );
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final _router = GoRouter(
      navigatorKey: navigatorKey,
      initialLocation: RouteName.splash,
      routes: [
        GoRoute(path: RouteName.splash, builder: (context, state) => SplashScreen()),
        GoRoute(path: RouteName.login, builder: (context, state) => Login()),
        GoRoute(path: RouteName.signup, builder: (context, state) => SignUp()),
        GoRoute(path: RouteName.home, builder: (context, state) => Home()),
        GoRoute(path: RouteName.productPage, builder: (context, state) => ProductPage()),
        GoRoute(path: RouteName.cartPage, builder: (context, state) => CartPage()),
        GoRoute(path: RouteName.orderPage, builder: (context, state) => OrderPage()),
        GoRoute(path: RouteName.profilePage, builder: (context, state) => ProfilePage()),
        GoRoute(path: RouteName.addressPage, builder: (context, state) => AddressPage()),
        GoRoute(path: RouteName.checkoutPage, builder: (context, state) => CheckoutPage()),
        GoRoute(path: RouteName.checkoutProcessPage, builder: (context, state) => CheckoutProcess()),
        GoRoute(path: RouteName.checkoutDonePage, builder: (context, state) => CheckoutDone())
      ],
      errorBuilder: (context, state) => NotFoundPage(),
  );

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Tech Barter',
      theme: ThemeData(
        colorScheme: ThemeData().colorScheme.copyWith(
          primary: Color(0xFF2563eb),
          secondary: Color(0xFF2563eb),
        ),
        useMaterial3: true,
        textTheme: customTextTheme,
      ),
      routerConfig: _router,
      debugShowCheckedModeBanner: false,
    );
  }
}

