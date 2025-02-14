import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:tech_barter/providers/CartProvider.dart';
import 'package:tech_barter/providers/auth_provider.dart';
import 'package:tech_barter/providers/product_provider.dart';
import 'package:tech_barter/providers/user_provider.dart';
import 'package:tech_barter/screens/homePage/home.dart';
import 'package:tech_barter/screens/login.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:tech_barter/screens/page_not_found.dart';
import 'package:tech_barter/screens/productPage/product_page.dart';
import 'package:tech_barter/screens/signup.dart';
import 'package:tech_barter/screens/splash_screen.dart';
import 'package:tech_barter/themes/text_theme.dart';
import 'package:tech_barter/utils/route_strings.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName:"../.env");
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AuthProvider()),
        ChangeNotifierProvider(create: (context) => UserProvider()),
        ChangeNotifierProvider(create: (context) => ProductProvider()),
        ChangeNotifierProvider(create: (context) => CartProvider()),
      ],
      child: MyApp(),
    )
  );
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final _router = GoRouter(
      initialLocation: RouteName.splash,
      routes: [
        GoRoute(path: RouteName.splash, builder: (context, state) => SplashScreen()),
        GoRoute(path: RouteName.login, builder: (context, state) => Login()),
        GoRoute(path: RouteName.signup, builder: (context, state) => SignUp()),
        GoRoute(path: RouteName.home, builder: (context, state) => Home()),
        GoRoute(path: RouteName.productPage, builder: (context, state) => ProductPage()),
      ],
      errorBuilder: (context, state) => NotFoundPage(),
  );

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Tech Barter',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Theme.of(context).primaryColor),
        useMaterial3: true,
        textTheme: customTextTheme,
      ),
      routerConfig: _router,
      debugShowCheckedModeBanner: false,
    );
  }
}

