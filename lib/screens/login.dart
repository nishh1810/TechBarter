import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:tech_barter/components/custom_button.dart';
import 'package:tech_barter/providers/user_provider.dart';
import 'package:tech_barter/utils/route_strings.dart';

import '../components/custom_header.dart';
import '../providers/auth_provider.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {

  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  String? _errorMessage;

  void _login() async {
    setState(() => _errorMessage = null);

    try {
      await Provider.of<AuthProvider>(context, listen: false).login(usernameController.text, passwordController.text);
      await Provider.of<UserProvider>(context, listen: false).fetchUserProfile();
      GoRouter.of(context).go(RouteName.home);
    } catch (e) {
      setState(() => _errorMessage = "Invalid Credentials");
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Column(
        children: [
          CustomHeader(),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Image.network(
                          "https://images.unsplash.com/photo-1601598851547-4302969d0614?q=80&w=1964&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
                            fit: BoxFit.cover,
                          height: 800,
                        )
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 300),
                          child: Column(
                            children: [
                              TextField(controller: usernameController, decoration: InputDecoration(labelText: "Username")),
                              TextField(controller: passwordController, decoration: InputDecoration(labelText: "Password"), obscureText: true),
                              if (_errorMessage != null) Text(_errorMessage!, style: TextStyle(color: Colors.red)),
                              // ElevatedButton(onPressed: _login, child: Text("Login")),
                              SizedBox(height: 20),
                              CustomBlueButton(label: "LOGIN", onPressed: _login)
                            ],
                          ),
                        )
                      ),
                    ]
                  ),
                  _buildFooter()
                ],
              ),
            ),
          ),
        ],
      ),

    );

  }


  Widget _buildFooter() {
    return Container(
      padding: EdgeInsets.all(20),
      color: Colors.black,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("TECH BARTER",
              style: Theme.of(context).textTheme.bodyLarge
          ),
          SizedBox(height: 10),
          TextField(
            decoration: InputDecoration(
              hintText: "Enter your email",
              filled: true,
              fillColor: Colors.white,
              suffixIcon: Icon(Icons.send),
              border: OutlineInputBorder(),
            ),
          ),
          SizedBox(height: 20),
          Text("Support", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          Text("111 Bijoy sarani, Dhaka, Bangladesh", style: TextStyle(color: Colors.white)),
          Text("exclusive@gmail.com", style: TextStyle(color: Colors.white)),
          Text("+88015-88888-9999", style: TextStyle(color: Colors.white)),
          SizedBox(height: 20),
          Text("Account", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          Text("My Account", style: TextStyle(color: Colors.white)),
          Text("Cart", style: TextStyle(color: Colors.white)),
          Text("Wishlist", style: TextStyle(color: Colors.white)),
          Text("Shop", style: TextStyle(color: Colors.white)),
          SizedBox(height: 20),
          Text("Quick Links", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          Text("Privacy Policy", style: TextStyle(color: Colors.white)),
          Text("Terms of Use", style: TextStyle(color: Colors.white)),
          Text("FAQ", style: TextStyle(color: Colors.white)),
          Text("Seller Login", style: TextStyle(color: Colors.white)),
          SizedBox(height: 20),
          Center(
            child: Text("© Copyright TECH BARTER 2024. All rights reserved", style: TextStyle(color: Colors.white)),
          )
        ],
      ),
    );
  }
}
