import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tech_barter/components/custom_button.dart';
import 'package:tech_barter/components/custom_scaffold.dart';
import 'package:tech_barter/utils/route_strings.dart';

class NotFoundPage extends StatelessWidget {
  const NotFoundPage({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      body: SizedBox(
        height: MediaQuery.of(context).size.height * 0.8,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, color: Colors.red, size: 80),
              SizedBox(height: 16),
              Text(
                "404",
                style: Theme.of(context).textTheme.displayLarge,
              ),
              SizedBox(height: 8),
              Text(
                "Oops! Page not found",
                style: Theme.of(context).textTheme.displayMedium,
              ),
              SizedBox(height: 20),
              SizedBox(
                width: 200,
                child: CustomBlueButton(
                  label: "Go Home",
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
}
