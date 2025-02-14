import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../components/custom_app_bar.dart';
import '../providers/auth_provider.dart';
import '../utils/route_strings.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  String? _errorMessage;

  void _signup() async {
    setState(() => _errorMessage = null);

    try {
      Provider.of<AuthProvider>(context, listen: false).signup(
          nameController.text, emailController.text,
          usernameController.text, passwordController.text);
      GoRouter.of(context).go(RouteName.login);
    } catch(e) {
      setState(() => _errorMessage = "Something went wrong");
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: CustomAppBar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            TextField(controller: nameController, decoration: InputDecoration(labelText: "Name")),
            TextField(controller: emailController, decoration: InputDecoration(labelText: "Email")),
            TextField(controller: usernameController, decoration: InputDecoration(labelText: "Username")),
            TextField(controller: passwordController, decoration: InputDecoration(labelText: "Password"), obscureText: true),
            TextField(controller: confirmPasswordController, decoration: InputDecoration(labelText: "Confirm Password"), obscureText: true),
            if (_errorMessage != null) Text(_errorMessage!, style: TextStyle(color: Colors.red)),
            ElevatedButton(onPressed: _signup, child: Text("signup")),
          ],
        ),
      ),
    );

  }
}
