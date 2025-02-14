import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../providers/auth_provider.dart';
import '../providers/user_provider.dart';
import '../utils/route_strings.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      toolbarHeight: 200,
      title: Text('TECH BARTER',
          style: Theme.of(context).textTheme.bodyMedium,
      ),
      backgroundColor: Colors.white,
      elevation: 0,
      actions: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 100.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Row(
                children: [
                  TextButton(onPressed: () {}, child: Text('Home', style: TextStyle(color: Colors.blue))),
                  TextButton(onPressed: () {}, child: Text('Contact', style: TextStyle(color: Colors.black))),
                  TextButton(onPressed: () {}, child: Text('About', style: TextStyle(color: Colors.black))),
                ],
              ),

              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.0),
                child: SizedBox(
                  width: 200,
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'What are you looking for?',
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
                    ),
                  ),
                ),
              ),

              Consumer<AuthProvider>(
                builder: (context, authProvider, child) {

                  if (authProvider.isAuthenticated) {
                    return Row(
                      children: [
                        Text("Hello! ${Provider.of<UserProvider>(context).user?.username ?? "UNKNOWN"}"),
                        TextButton(
                            onPressed: () {
                              Provider.of<AuthProvider>(context).logout();
                              GoRouter.of(context).go(RouteName.login);
                            },
                            child: Text("LOGOUT")
                        ),
                      ],
                    );
                  }else {
                    return Row(
                      children: [
                        TextButton(
                            onPressed: () {
                              // print("clicked on signup");
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
        ),
      ],
    );
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => const Size.fromHeight(100);
}
