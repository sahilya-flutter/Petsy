import 'package:get/get.dart';
import 'package:pesty/features/home/binding/home_binding.dart';
import 'package:pesty/features/home/views/home_screen.dart';
import '../../features/auth/bindings/auth_binding.dart';
import '../../features/auth/views/auth_screen.dart';
import 'app_routes.dart';

class AppPages {
  static final routes = [
    GetPage(
      name: AppRoutes.AUTH,
      page: () => const AuthScreen(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: AppRoutes.HOME,
      page: () => const HomeScreen(),
      binding: HomeBinding(),
    ),
  ];
}
