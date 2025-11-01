// Appointments logic
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../database/db_helper.dart';
import 'auth_controller.dart';

class AppointmentController extends GetxController {
  final AuthController authController = Get.find();
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  RxList<Map<String, dynamic>> appointments = <Map<String, dynamic>>[].obs;
  RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadAppointments();
  }

  Future<void> loadAppointments() async {
    try {
      isLoading.value = true;
      final userId = authController.firebaseUser.value?.uid;
      if (userId != null) {
        final appointmentsList = await _dbHelper.getAppointments(userId);
        appointments.value = appointmentsList;
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to load appointments: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> addAppointment({
    required int petId,
    required String title,
    required String type,
    required String date,
    required String time,
    String? location,
    String? notes,
  }) async {
    try {
      isLoading.value = true;
      final userId = authController.firebaseUser.value?.uid;

      if (userId != null) {
        await _dbHelper.insertAppointment({
          'userId': userId,
          'petId': petId,
          'title': title,
          'type': type,
          'date': date,
          'time': time,
          'location': location ?? '',
          'notes': notes ?? '',
          'createdAt': DateTime.now().toIso8601String(),
        });

        Get.snackbar(
          'Success',
          'Appointment added successfully!',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Get.theme.primaryColor,
          colorText: Colors.white,
        );

        await loadAppointments();
        Get.back();
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to add appointment: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> deleteAppointment(int appointmentId) async {
    try {
      await _dbHelper.deleteAppointment(appointmentId);
      Get.snackbar(
        'Success',
        'Appointment deleted successfully',
        snackPosition: SnackPosition.BOTTOM,
      );
      await loadAppointments();
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to delete appointment: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }
}
