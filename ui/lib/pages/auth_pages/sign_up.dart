import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import '../../Utils/show_toast.dart';
import '../../constants/routes.dart';
import '../../controllers/auth_controllers/auth_methods.dart';
import 'login_page.dart';

class SignupPage extends StatefulWidget {
  static String route_name = signup_route;
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final fullNameController = TextEditingController();
  final AuthController authController=Get.find();

  final ImagePicker _picker = ImagePicker();
  XFile? _profileImage;
  XFile? _coverImage;

  bool passwordVisible = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  Future<void> _pickProfileImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _profileImage = image;
      });
    }
  }

  Future<void> _pickDocumentImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _coverImage = image;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      child: SafeArea(
        child: Scaffold(
          resizeToAvoidBottomInset: true,
          body: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.purple.withOpacity(0.6), // Cyan/Turquoise
                        const Color(0x00FFFFFF),
                      ],
                      begin: const AlignmentDirectional(0.0, -1.0),
                      end: const AlignmentDirectional(0, 1.3),
                      stops: const [0.0, 1.0],
                    ),
                  ),
                  width: double.infinity,
                  height: 300,
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 100.0,
                        height: 100.0,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16.0),
                        ),
                        child: const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Icon(
                            Icons.app_registration,
                            color: Colors.blue,
                            size: 44.0,
                          ),
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(
                          0.0,
                          12.0,
                          0.0,
                          0.0,
                        ),
                        child: Text(
                          'Sign Up',
                          style: TextStyle(
                            fontSize: 23,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.0,
                          ),
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(
                          0.0,
                          4.0,
                          0.0,
                          0.0,
                        ),
                        child: Text(
                          'Create an account to sign in',
                          style: TextStyle(letterSpacing: 0.0),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 16,
                    horizontal: 32,
                  ),
                  child: Column(
                    children: [
                      // Email or Username field
                      TextFormField(
                        controller: emailController,
                        decoration: const InputDecoration(
                          icon: Icon(Icons.email),
                          labelText: 'Email or Username',
                        ),
                        onChanged: (value) {
                          setState(() {});
                        },
                      ),
                      const SizedBox(height: 20), // Space between fields
                      // Password field
                      TextFormField(
                        controller: passwordController,
                        obscureText: !passwordVisible,
                        decoration: InputDecoration(
                          icon: const Icon(Icons.lock),
                          labelText: 'Password',
                          suffixIcon: IconButton(
                            icon: Icon(
                              passwordVisible
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                            ),
                            onPressed: () {
                              setState(() {
                                passwordVisible = !passwordVisible;
                              });
                            },
                          ),
                        ),
                        onChanged: (value) {
                          setState(() {});
                        },
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        controller: fullNameController,
                        decoration: InputDecoration(
                          icon: const Icon(Icons.drive_file_rename_outline),
                          labelText: 'FullName',
                        ),
                        onChanged: (value) {
                          setState(() {});
                        },
                      ), // Space between fields
                      // Forgot Password button
                      SizedBox.fromSize(size: const Size(23, 23)),

                      // Profile Image Picker
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            _profileImage == null
                                ? const Text('No avatar image selected.')
                                : Image.file(
                                  File(_profileImage!.path),
                                  width: 100,
                                  height: 100,
                                ),
                            ElevatedButton(
                              onPressed: _pickProfileImage,
                              child: const Text('Select Avatar Image'),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 10),

                      // Document Image Picker
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            _coverImage == null
                                ? const Text('No document image selected.')
                                : Image.file(
                                  File(_coverImage!.path),
                                  width: 100,
                                  height: 100,
                                ),
                            const SizedBox(width: 10),
                            ElevatedButton(
                              onPressed: _pickDocumentImage,
                              child: const Text('Select Cover Image'),
                            ),
                          ],
                        ),
                      ),

                      TextButton.icon(
                        onPressed: () async {
                          //go to email ver pg
                          //signup
                          var regSuccess=await authController.registerUser(
                            context,
                            emailController.text,
                            passwordController.text,
                            emailController.text,
                            fullNameController.text,
                            _profileImage,
                            _coverImage,
                          );
                          if(regSuccess){
                            showToast("Pls login!", Colors.blue);
                            Navigator.of(context).pushReplacementNamed(login_route);
                          }
                        },
                        icon: const Icon(Icons.login),
                        label: Container(
                          alignment: Alignment.center,
                          width: 150,
                          height: 45,
                          decoration: const BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.all(Radius.circular(23)),
                          ),
                          child: const Text(
                            'Sign Up',
                            style: TextStyle(fontSize: 18, color: Colors.white),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10), // Space between buttons
                      // Sign Up link
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text('Already Have an Accout?'),
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pushReplacementNamed(
                                LoginPage.route_name,
                              );
                            },
                            child: const Text(
                              'Login',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
