

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import 'constants/routes.dart';
import 'controllers/auth_controllers/auth_methods.dart';
import 'controllers/settings_controller/setting_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Ensure SettingsController is initialized before running the app
  Get.put(SettingsController());
  Get.put(AuthController());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final SettingsController sc = Get.find(); // Get the controller instance

    return Obx(() => GetMaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        textTheme: GoogleFonts.aBeeZeeTextTheme().apply(
          bodyColor: sc.darkMode.value ? Colors.white : Colors.black,  // White text in dark mode
          displayColor: sc.darkMode.value ? Colors.white : Colors.black,
        ),

        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: sc.darkMode.value ? Brightness.dark : Brightness.light, // Dynamic Theme
        ),
        useMaterial3: true,
      ),
      initialRoute: login_route,
      routes: routes,
    ));
  }
}