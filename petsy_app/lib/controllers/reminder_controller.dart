// Reminders logic
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../database/db_helper.dart';
import 'auth_controller.dart';

class ReminderController extends GetxController {
  final AuthController authController = Get.find();
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  RxList<Map<String, dynamic>> reminders = <Map<String, dynamic>>[].obs;
  RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadReminders();
  }

  Future<void> loadReminders() async {
    try {
      isLoading.value = true;
      final userId = authController.currentUser.value?.uid;
      if (userId != null) {
        final remindersList = await _dbHelper.getReminders(userId);
        reminders.value = remindersList;
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to load reminders: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> addReminder({
    required int petId,
    required String title,
    required String description,
    required String date,
    required String time,
  }) async {
    try {
      isLoading.value = true;
      final userId = authController.currentUser.value?.uid;

      if (userId != null) {
        await _dbHelper.insertReminder({
          'userId': userId,
          'petId': petId,
          'title': title,
          'description': description,
          'date': date,
          'time': time,
          'isCompleted': 0,
          'createdAt': DateTime.now().toIso8601String(),
        });

        Get.snackbar(
          'Success',
          'Reminder added successfully!',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Get.theme.primaryColor,
          colorText: Colors.white,
        );

        await loadReminders();
        Get.back();
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to add reminder: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> toggleReminderCompletion(
    int reminderId,
    bool isCompleted,
  ) async {
    try {
      await _dbHelper.updateReminder(reminderId as String, {
        'isCompleted': isCompleted ? 1 : 0,
      });
      await loadReminders();
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to update reminder: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  Future<void> deleteReminder(int reminderId) async {
    try {
      await _dbHelper.deleteReminder(reminderId as String);
      Get.snackbar(
        'Success',
        'Reminder deleted successfully',
        snackPosition: SnackPosition.BOTTOM,
      );
      await loadReminders();
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to delete reminder: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }
}
