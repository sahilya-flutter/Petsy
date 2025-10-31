import 'package:get/get.dart';
import 'package:pet_management_app/app/data/database/database_helper.dart';
import 'package:pet_management_app/app/data/model/appointment_model.dart';
import '../../auth/controllers/auth_controller.dart';

class AppointmentController extends GetxController {
  final _db = DatabaseHelper.instance;
  final _authController = Get.find<AuthController>();

  final RxList<AppointmentModel> appointments = <AppointmentModel>[].obs;
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadAppointments();
  }

  Future<void> loadAppointments() async {
    try {
      isLoading.value = true;
      final userId = _authController.currentUser.value?.id;
      if (userId != null) {
        final appointmentList = await _db.getAppointmentsByUserId(userId);
        appointments.value = appointmentList;
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to load appointments: $e');
    } finally {
      isLoading.value = false;
    }
  }

  List<AppointmentModel> get upcomingAppointments {
    final now = DateTime.now();
    return appointments
        .where((apt) => apt.appointmentDate.isAfter(now) && !apt.isCompleted)
        .toList();
  }

  List<AppointmentModel> get pastAppointments {
    final now = DateTime.now();
    return appointments
        .where((apt) => apt.appointmentDate.isBefore(now) || apt.isCompleted)
        .toList();
  }

  Future<void> addAppointment(AppointmentModel appointment) async {
    try {
      isLoading.value = true;
      await _db.createAppointment(appointment);
      await loadAppointments();
      Get.back();
      Get.snackbar('Success', 'Appointment added successfully!');
    } catch (e) {
      Get.snackbar('Error', 'Failed to add appointment: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> toggleComplete(AppointmentModel appointment) async {
    try {
      final updated = appointment.copyWith(
        isCompleted: !appointment.isCompleted,
      );
      await _db.updateAppointment(updated);
      await loadAppointments();
    } catch (e) {
      Get.snackbar('Error', 'Failed to update appointment: $e');
    }
  }

  Future<void> deleteAppointment(int id) async {
    try {
      await _db.deleteAppointment(id);
      await loadAppointments();
      Get.snackbar('Success', 'Appointment deleted!');
    } catch (e) {
      Get.snackbar('Error', 'Failed to delete appointment: $e');
    }
  }
}
