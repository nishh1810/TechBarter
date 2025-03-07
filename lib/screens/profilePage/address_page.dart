import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tech_barter/components/custom_button.dart';
import 'package:tech_barter/components/custom_container.dart';
import 'package:tech_barter/components/custom_scaffold.dart';
import 'package:tech_barter/components/custom_text_field.dart';
import 'package:tech_barter/models/address.dart';
import 'package:tech_barter/providers/user_provider.dart';
import 'package:tech_barter/utils/validators.dart';
import 'components/profile_side_menu.dart';

class AddressPage extends StatefulWidget {
  const AddressPage({super.key});

  @override
  State<AddressPage> createState() => _AddressPageState();
}

class _AddressPageState extends State<AddressPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  UserProvider? userProvider;
  final TextEditingController _streetController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _stateController = TextEditingController();
  final TextEditingController _countryController = TextEditingController();
  final TextEditingController _zipController = TextEditingController();

  void onUpdate() {
    if (_formKey.currentState!.validate()) {
      Address address = Address(
        street: _streetController.text,
        city: _cityController.text,
        state: _stateController.text,
        country: _countryController.text,
        zipCode: _zipController.text,
      );
      Provider.of<UserProvider>(context, listen: false).updateAddress(address);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Address updated successfully!'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    userProvider = Provider.of<UserProvider>(context, listen: false);
    _streetController.text = userProvider?.user?.address?.street ?? "";
    _cityController.text = userProvider?.user?.address?.city ?? "";
    _stateController.text = userProvider?.user?.address?.state ?? "";
    _countryController.text = userProvider?.user?.address?.country ?? "";
    _zipController.text = userProvider?.user?.address?.zipCode ?? "";

    return CustomScaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 64, vertical: 32),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Side Menu
            Expanded(
              flex: 2,
              child: const ProfileSideMenu( index: 1,),
            ),

            // Main Content
            Expanded(
              flex: 8,
              child: CustomContainer(
                padding: const EdgeInsets.all(32),
                child: SingleChildScrollView(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Address Information",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.edit_location_alt_outlined),
                              tooltip: 'Edit Address',
                              onPressed: () {},
                            ),
                          ],
                        ),
                        const SizedBox(height: 32),

                        // Address Form
                        Text(
                          "Shipping Address",
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 24),

                        CustomTextField(
                          label: "Street Address",
                          hintText: "Enter your street address",
                          controller: _streetController,
                          validator: (value) =>
                              Validators.validateText(value, "Street"),
                        ),
                        const SizedBox(height: 20),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            CustomTextField(
                              label: "City",
                              hintText: "Enter your city",
                              controller: _cityController,
                              validator: (value) =>
                                  Validators.validateText(value, "City"),
                            ),
                            const SizedBox(width: 20),
                            CustomTextField(
                              label: "State/Province",
                              hintText: "Enter your state",
                              controller: _stateController,
                              validator: (value) =>
                                  Validators.validateText(value, "State"),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            CustomTextField(
                              label: "Country",
                              hintText: "Enter your country",
                              controller: _countryController,
                              validator: (value) =>
                                  Validators.validateText(value, "Country"),
                            ),
                            const SizedBox(width: 20),
                            CustomTextField(
                              label: "ZIP/Postal Code",
                              hintText: "Enter postal code",
                              controller: _zipController,
                              validator: (value) =>
                                  Validators.validateText(value, "Zip Code"),
                            ),
                          ],
                        ),
                        const SizedBox(height: 40),

                        // Update Button
                        Align(
                          alignment: Alignment.centerLeft,
                          child: SizedBox(
                            width: 280,
                            child: CustomBlueButton(
                              label: "SAVE ADDRESS",
                              onPressed: onUpdate,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}