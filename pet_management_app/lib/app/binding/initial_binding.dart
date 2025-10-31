import 'package:get/get.dart';
import 'package:pet_management_app/modules/appointment/controllers/appointment_controller.dart';
import 'package:pet_management_app/modules/auth/controllers/auth_controller.dart';
import 'package:pet_management_app/modules/pet/controllers/pet_controller.dart';
import 'package:pet_management_app/modules/reminder/controllers/reminder_controller.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => AuthController(), fenix: true);
    Get.lazyPut(() => PetController(), fenix: true);
    Get.lazyPut(() => AppointmentController(), fenix: true);
    Get.lazyPut(() => ReminderController(), fenix: true);
  }
}
