import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../providers/auth_provider.dart';
import '../providers/user_provider.dart';
import '../utils/route_strings.dart';

class CustomHeader extends StatefulWidget {
  const CustomHeader({super.key});

  @override
  State<CustomHeader> createState() => _CustomHeaderState();
}

class _CustomHeaderState extends State<CustomHeader> {
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
              TextButton(onPressed: () {
                GoRouter.of(context).go(RouteName.home);
              }, child: Text('Home', style: TextStyle(color: Theme.of(context).primaryColor))),
              TextButton(onPressed: () {

              }, child: Text('Contact', style: TextStyle(color: Colors.black))),
              TextButton(onPressed: () {

              }, child: Text('About', style: TextStyle(color: Colors.black))),
            ],
          ),

          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.0),
            child: SizedBox(
              width: 300,
              // child: TextField(
              //   style: Theme.of(context).textTheme.bodySmall,
              //   decoration: InputDecoration(
              //     hintText: 'What are you looking for?',
              //     prefixIcon: Icon(Icons.search),
              //     border: OutlineInputBorder(borderRadius: BorderRadius.circular(4)),
              //   ),
              // ),
            ),
          ),

          Consumer2<AuthProvider, UserProvider>(
            builder: (context, authProvider, userProvider, child) {

              if (authProvider.isAuthenticated) {
                return Row(
                  children: [

                    IconButton(
                      onPressed: () {
                        GoRouter.of(context).go(RouteName.cartPage);
                      },
                      icon: Icon(Icons.shopping_cart,
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        GoRouter.of(context).go(RouteName.profilePage);
                      },
                      icon: Icon(Icons.person),
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
              }else {
                return Row(
                  children: [
                    TextButton(
                        onPressed: () {
                          GoRouter.of(context).go(RouteName.signup);
                        },
                        child: Text("SIGN UP")
                    ),
                    TextButton(
                        onPressed: () {
                          GoRouter.of(context).go(RouteName.login);
                        },
                        child: Text("LOGIN")
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
