import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:firebase_core/firebase_core.dart';
import 'controllers/auth_controller.dart';
import 'screens/splash_screen.dart';
import 'screens/auth/signin_screen.dart';
import 'screens/auth/signup_screen.dart';
import 'screens/home/home_screen.dart';
import 'screens/pets/add_pet_screen.dart';
import 'screens/appointments/appointment_screen.dart';
import 'screens/agenda/agenda_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  Get.put(AuthController());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (context, orientation, deviceType) {
        return GetMaterialApp(
          title: 'Petsy',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primarySwatch: Colors.purple,
            scaffoldBackgroundColor: Colors.white,
            fontFamily: 'Poppins',
          ),
          initialRoute: '/',
          getPages: [
            GetPage(name: '/', page: () => SplashScreen()),
            GetPage(name: '/signin', page: () => SignInScreen()),
            GetPage(name: '/signup', page: () => SignUpScreen()),
            GetPage(name: '/home', page: () => HomeScreen()),
            GetPage(name: '/add-pet', page: () => AddPetScreen()),
            GetPage(name: '/appointments', page: () => AppointmentScreen()),
            GetPage(name: '/agenda', page: () => AgendaScreen()),
          ],
        );
      },
    );
  }
}
