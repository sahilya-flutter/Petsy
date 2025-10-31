import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pet_management_app/app/binding/initial_binding.dart';
import 'package:pet_management_app/routes/app_pages.dart';
import 'package:pet_management_app/routes/app_routes.dart';
import 'package:sizer/sizer.dart';
import 'app/data/database/database_helper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize database
  await DatabaseHelper.instance.database;

  runApp(const PetsyApp());
}

class PetsyApp extends StatelessWidget {
  const PetsyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (context, orientation, deviceType) {
        return GetMaterialApp(
          title: 'Petsy',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primarySwatch: Colors.purple,
            scaffoldBackgroundColor: const Color(0xFFF5F5F5),
            fontFamily: 'Roboto',
          ),
          initialBinding: InitialBinding(), // Add this
          initialRoute: AppRoutes.SIGNIN,
          getPages: AppPages.pages,
        );
      },
    );
  }
}
