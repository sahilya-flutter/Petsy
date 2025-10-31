import 'package:get/get.dart';
import 'package:pet_management_app/app/data/database/database_helper.dart';
import 'package:pet_management_app/app/data/model/reminder_model.dart';
import '../../auth/controllers/auth_controller.dart';

class ReminderController extends GetxController {
  final _db = DatabaseHelper.instance;
  final _authController = Get.find<AuthController>();

  final RxList<ReminderModel> reminders = <ReminderModel>[].obs;
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadReminders();
  }

  Future<void> loadReminders() async {
    try {
      isLoading.value = true;
      final userId = _authController.currentUser.value?.id;
      if (userId != null) {
        final reminderList = await _db.getRemindersByUserId(userId);
        reminders.value = reminderList;
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to load reminders: $e');
    } finally {
      isLoading.value = false;
    }
  }

  List<ReminderModel> get activeReminders {
    return reminders.where((r) => r.isActive).toList();
  }

  List<ReminderModel> get todayReminders {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final tomorrow = today.add(const Duration(days: 1));

    return activeReminders.where((r) {
      return r.reminderDate.isAfter(today) && r.reminderDate.isBefore(tomorrow);
    }).toList();
  }

  Future<void> addReminder(ReminderModel reminder) async {
    try {
      isLoading.value = true;
      await _db.createReminder(reminder);
      await loadReminders();
      Get.back();
      Get.snackbar('Success', 'Reminder added successfully!');
    } catch (e) {
      Get.snackbar('Error', 'Failed to add reminder: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> toggleActive(ReminderModel reminder) async {
    try {
      final updated = reminder.copyWith(isActive: !reminder.isActive);
      await _db.updateReminder(updated);
      await loadReminders();
    } catch (e) {
      Get.snackbar('Error', 'Failed to update reminder: $e');
    }
  }

  Future<void> deleteReminder(int id) async {
    try {
      await _db.deleteReminder(id);
      await loadReminders();
      Get.snackbar('Success', 'Reminder deleted!');
    } catch (e) {
      Get.snackbar('Error', 'Failed to delete reminder: $e');
    }
  }
}
