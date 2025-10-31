import 'package:get/get.dart';
import 'package:pet_management_app/modules/appointment/views/add_appointment_screen.dart';
import 'package:pet_management_app/modules/appointment/views/appointment_list_screen.dart';
import 'package:pet_management_app/modules/auth/views/signin_screen.dart';
import 'package:pet_management_app/modules/auth/views/signup_screen.dart';
import 'package:pet_management_app/modules/home/views/home_screen.dart';
import 'package:pet_management_app/modules/pet/views/add_pet_screen.dart';
import 'package:pet_management_app/modules/pet/views/pet_list_screen.dart';
import 'package:pet_management_app/modules/reminder/views/add_reminder_screen.dart';
import 'package:pet_management_app/modules/reminder/views/reminder_screen.dart';
import 'app_routes.dart';

class AppPages {
  static final pages = [
    GetPage(name: AppRoutes.SIGNIN, page: () => SignInScreen()),
    GetPage(name: AppRoutes.SIGNUP, page: () => SignUpScreen()),
    GetPage(name: AppRoutes.HOME, page: () => const HomeScreen()),
    GetPage(name: AppRoutes.PET_LIST, page: () => const PetListScreen()),
    GetPage(name: AppRoutes.ADD_PET, page: () => const AddPetScreen()),
    GetPage(
      name: AppRoutes.APPOINTMENTS,
      page: () => const AppointmentListScreen(),
    ),
    GetPage(
      name: AppRoutes.ADD_APPOINTMENT,
      page: () => const AddAppointmentScreen(),
    ),
    GetPage(name: AppRoutes.REMINDERS, page: () => const ReminderScreen()),
    GetPage(
      name: AppRoutes.ADD_REMINDER,
      page: () => const AddReminderScreen(),
    ),
  ];
}
