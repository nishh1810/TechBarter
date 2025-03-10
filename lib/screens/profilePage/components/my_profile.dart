import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tech_barter/components/custom_container.dart';
import 'package:tech_barter/components/custom_text_field.dart';
import 'package:tech_barter/providers/user_provider.dart';
import 'package:tech_barter/screens/profilePage/components/profile_image_uploader.dart';
import 'package:tech_barter/utils/validators.dart';

class MyProfile extends StatefulWidget {
  const MyProfile({super.key});

  @override
  State<MyProfile> createState() => _MyProfileState();
}

class _MyProfileState extends State<MyProfile> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  UserProvider? userProvider;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    userProvider = Provider.of<UserProvider>(context, listen: false);
    _nameController.text = userProvider?.user?.name ?? "";
    _emailController.text = userProvider?.user?.email ?? "";

    if (userProvider == null) return Container();

    return SizedBox(
      height: MediaQuery.of(context).size.height,
      child: SingleChildScrollView(
        child: CustomContainer(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "My Profile",
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).primaryColor,
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 32),

                // Profile Image Section
                Center(
                  child: Column(
                    children: [
                      const ProfileImageUploader(),
                      const SizedBox(height: 16),
                      Text(
                        "Change Profile Photo",
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 40),

                // Form Fields
                Text(
                  "Personal Information",
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 24),

                CustomTextField(
                  label: "Full Name",
                  hintText: "Enter your full name",
                  controller: _nameController,
                  validator: (value) => Validators.validateText(value, "Name"),
                  readOnly: true,
                ),
                const SizedBox(height: 20),

                CustomTextField(
                  label: "Email Address",
                  hintText: "Enter your email",
                  controller: _emailController,
                  validator: (value) => Validators.validateEmail(value),
                  readOnly: true,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}