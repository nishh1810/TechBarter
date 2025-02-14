import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:go_router/go_router.dart';
import 'package:tech_barter/utils/route_strings.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 5), () {
      GoRouter.of(context).go(RouteName.home);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            AnimatedTextKit(
              animatedTexts: [
                TyperAnimatedText(
                  'Tech Barter',
                  textStyle: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue, // Customize color
                  ),
                  speed: Duration(milliseconds: 100), // Adjust speed
                ),
                TyperAnimatedText(
                  'Barter, Buy, Sell Tech', // Tagline
                  textStyle: TextStyle(
                    fontSize: 18,
                    color: Colors.grey, // Customize color
                  ),
                  speed: Duration(milliseconds: 100), // Adjust speed
                ),
              ],
              isRepeatingAnimation: false,
              // Only play once
              pause: Duration(milliseconds: 500), // Pause between animations
              displayFullTextOnTap: false,
            ),
            SizedBox(height: 30),
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
            ),
          ],
        ),
      ),
      backgroundColor: Colors.white,
    );
  }
}