import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../constants/routes.dart';
import '../../controllers/auth_controllers/auth_methods.dart';

class EditPasswordPage extends StatelessWidget {
  final _oldPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  static const route_name=edit_password;
  final AuthController userController = Get.find<AuthController>();

  EditPasswordPage({super.key});

  void _showConfirmationDialog(BuildContext context) {
    Get.defaultDialog(
      title: "Are you sure?",
      middleText: "Do you want to change your password?",
      textCancel: "No",
      textConfirm: "Yes",
      confirmTextColor: Colors.white,
      onConfirm: () async {
        Get.back(); // Close dialog first
        await _submitPasswordChange(context); // Then submit
      },
    );
  }

  Future<void> _submitPasswordChange(BuildContext context) async {
    final success = await userController.updatePassword(
      context,
      _oldPasswordController.text.trim(),
      _newPasswordController.text.trim(),
    );

    if (success) {
      Get.defaultDialog(
        title: "Success 🎉",
        middleText: "Your password has been updated!",
        confirm: ElevatedButton(
          onPressed: () {
            Get.back(); // Close dialog
            Get.back(); // Go back to previous screen
          },
          child: const Text("OK"),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Change Password"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              /// Old Password
              TextFormField(
                controller: _oldPasswordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: "Old Password",
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                value == null || value.isEmpty ? "Enter old password" : null,
              ),
              const SizedBox(height: 20),

              /// New Password
              TextFormField(
                controller: _newPasswordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: "New Password",
                  border: OutlineInputBorder(),
                ),
                validator: (value) => value == null || value.length < 6
                    ? "Password must be at least 6 characters"
                    : null,
              ),
              const SizedBox(height: 30),

              /// Submit Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _showConfirmationDialog(context);
                    }
                  },
                  child: const Text("Update Password"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
