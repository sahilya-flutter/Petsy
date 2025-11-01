import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:sizer/sizer.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'app/routes/app_pages.dart';
import 'app/routes/app_routes.dart';
import 'app/theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  // Check if user is logged in
  final prefs = await SharedPreferences.getInstance();
  final isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

  runApp(PetsyApp(isLoggedIn: isLoggedIn));
}

class PetsyApp extends StatelessWidget {
  final bool isLoggedIn;

  const PetsyApp({Key? key, required this.isLoggedIn}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (context, orientation, deviceType) {
        return GetMaterialApp(
          title: 'Petsy',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          initialRoute: isLoggedIn ? AppRoutes.HOME : AppRoutes.AUTH,
          getPages: AppPages.routes,
        );
      },
    );
  }
}
