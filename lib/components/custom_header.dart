import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:tech_barter/providers/auth_provider.dart';
import 'package:tech_barter/providers/user_provider.dart';
import 'package:tech_barter/services/api_service.dart';
import 'package:tech_barter/utils/route_strings.dart';
import 'package:url_launcher/url_launcher.dart';


class CustomHeader extends StatefulWidget {
  final int curIndex;
  const CustomHeader({super.key, required this.curIndex});

  @override
  State<CustomHeader> createState() => _CustomHeaderState();
}

class _CustomHeaderState extends State<CustomHeader> {
  Future<void> _launchSellerPanel() async {
    String url = ApiService.sellerUrl;
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not launch seller panel')),
      );
    }
  }

  Color getColorViaIndex(index) {
    if(widget.curIndex == index) {
      return Theme.of(context).primaryColor;
    } else {
      return Colors.black;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text('TECH BARTER',
            style: Theme.of(context).textTheme.bodyMedium,
          ),

          Row(
            children: [
              TextButton(
                  onPressed: () => GoRouter.of(context).go(RouteName.home),
                  child: Text('Home', style: TextStyle(color: getColorViaIndex(0)))
              ),
              TextButton(
                  onPressed: () => GoRouter.of(context).go(RouteName.productCatalogPage),
                  child: Text('Products', style: TextStyle(color: getColorViaIndex(1)))
              ),
              TextButton(
                  onPressed: () => GoRouter.of(context).go(RouteName.contactPage),
                  child: Text('Contact', style: TextStyle(color: getColorViaIndex(2)))
              ),
              TextButton(
                  onPressed: _launchSellerPanel,
                  child: Text('Seller Panel', style: TextStyle(color: getColorViaIndex(3)))
              ),
            ],
          ),

          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.0),
            child: SizedBox(
              width: 300,
              // Search field placeholder
            ),
          ),

          Consumer2<AuthProvider, UserProvider>(
            builder: (context, authProvider, userProvider, child) {
              if (authProvider.isAuthenticated) {
                return Row(
                  children: [
                    IconButton(
                      onPressed: () => GoRouter.of(context).go(RouteName.cartPage),
                      icon: Icon(Icons.shopping_cart, color: getColorViaIndex(4)),
                    ),
                    IconButton(
                      onPressed: () => GoRouter.of(context).go(RouteName.profilePage),
                      icon: Icon(Icons.person, color: getColorViaIndex(5)),
                    ),
                    IconButton(
                      onPressed: () {
                        authProvider.logout();
                        GoRouter.of(context).go(RouteName.login);
                      },
                      icon: Icon(Icons.lock),
                    ),
                  ],
                );
              } else {
                return Row(
                  children: [
                    TextButton(
                        onPressed: () => GoRouter.of(context).go(RouteName.signup),
                        child: Text("SIGN UP", style: TextStyle(color: getColorViaIndex(6)))
                    ),
                    TextButton(
                        onPressed: () => GoRouter.of(context).go(RouteName.login),
                        child: Text("LOGIN", style: TextStyle(color: getColorViaIndex(7)))
                    ),
                  ],
                );
              }
            },
          ),
        ],
      ),
    );
  }
}