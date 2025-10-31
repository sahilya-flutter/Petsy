import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pet_management_app/app/data/model/reminder_model.dart';
import 'package:sizer/sizer.dart';
import 'package:intl/intl.dart';
import '../controllers/reminder_controller.dart';
import '../../pet/controllers/pet_controller.dart';
import '../../../routes/app_routes.dart';

class ReminderScreen extends StatelessWidget {
  const ReminderScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final reminderController = Get.find<ReminderController>();
    final petController = Get.find<PetController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Reminders & Agenda'),
        backgroundColor: Colors.purple,
      ),
      body: Obx(() {
        if (reminderController.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (reminderController.reminders.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.alarm_outlined,
                  size: 80.sp,
                  color: Colors.grey[300],
                ),
                SizedBox(height: 2.h),
                Text(
                  'No reminders set',
                  style: TextStyle(fontSize: 14.sp, color: Colors.grey[600]),
                ),
                SizedBox(height: 1.h),
                Text(
                  'Tap the + button to create a reminder',
                  style: TextStyle(fontSize: 11.sp, color: Colors.grey[400]),
                ),
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: () => reminderController.loadReminders(),
          child: ListView.builder(
            padding: EdgeInsets.all(3.w),
            itemCount: reminderController.reminders.length,
            itemBuilder: (context, index) {
              final reminder = reminderController.reminders[index];
              final pet = reminder.petId != null
                  ? petController.pets.firstWhereOrNull(
                      (p) => p!.id == reminder.petId,
                    )
                  : null;

              return _buildReminderCard(
                reminder,
                pet?.name,
                reminderController,
              );
            },
          ),
        );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Get.toNamed(AppRoutes.ADD_REMINDER),
        backgroundColor: Colors.purple,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildReminderCard(
    ReminderModel reminder,
    String? petName,
    ReminderController controller,
  ) {
    final isPast = reminder.reminderDate.isBefore(DateTime.now());

    return Card(
      margin: EdgeInsets.only(bottom: 2.h),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: EdgeInsets.all(4.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: EdgeInsets.all(2.w),
                  decoration: BoxDecoration(
                    color: reminder.isActive
                        ? Colors.orange.shade100
                        : Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    reminder.isActive ? Icons.alarm_on : Icons.alarm_off,
                    color: reminder.isActive ? Colors.orange : Colors.grey,
                    size: 24.sp,
                  ),
                ),
                SizedBox(width: 3.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        reminder.title,
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.bold,
                          decoration: !reminder.isActive
                              ? TextDecoration.lineThrough
                              : null,
                        ),
                      ),
                      if (petName != null) ...[
                        SizedBox(height: 0.5.h),
                        Row(
                          children: [
                            Icon(Icons.pets, size: 12.sp, color: Colors.grey),
                            SizedBox(width: 1.w),
                            Text(
                              petName,
                              style: TextStyle(
                                fontSize: 10.sp,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),

                // Active/Inactive Toggle
                Switch(
                  value: reminder.isActive,
                  onChanged: (value) {
                    controller.toggleActive(reminder);
                  },
                  activeColor: Colors.orange,
                ),

                PopupMenuButton(
                  icon: const Icon(Icons.more_vert),
                  itemBuilder: (context) => [
                    const PopupMenuItem(
                      value: 'delete',
                      child: Row(
                        children: [
                          Icon(Icons.delete, color: Colors.red),
                          SizedBox(width: 8),
                          Text('Delete', style: TextStyle(color: Colors.red)),
                        ],
                      ),
                    ),
                  ],
                  onSelected: (value) {
                    if (value == 'delete') {
                      _confirmDelete(reminder, controller);
                    }
                  },
                ),
              ],
            ),

            SizedBox(height: 2.h),
            Divider(),
            SizedBox(height: 1.h),

            // Date & Time
            Row(
              children: [
                Icon(
                  isPast ? Icons.history : Icons.access_time,
                  size: 14.sp,
                  color: Colors.purple,
                ),
                SizedBox(width: 2.w),
                Text(
                  DateFormat(
                    'MMM dd, yyyy • hh:mm a',
                  ).format(reminder.reminderDate),
                  style: TextStyle(
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w500,
                    color: isPast ? Colors.grey : null,
                  ),
                ),
              ],
            ),

            SizedBox(height: 1.h),

            // Frequency
            Row(
              children: [
                Icon(Icons.repeat, size: 14.sp, color: Colors.purple),
                SizedBox(width: 2.w),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 3.w,
                    vertical: 0.5.h,
                  ),
                  decoration: BoxDecoration(
                    color: _getFrequencyColor(reminder.frequency),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    reminder.frequency.toUpperCase(),
                    style: TextStyle(
                      fontSize: 9.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),

            if (reminder.description != null &&
                reminder.description!.isNotEmpty) ...[
              SizedBox(height: 1.h),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.notes, size: 14.sp, color: Colors.purple),
                  SizedBox(width: 2.w),
                  Expanded(
                    child: Text(
                      reminder.description!,
                      style: TextStyle(
                        fontSize: 10.sp,
                        color: Colors.grey[600],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Color _getFrequencyColor(String frequency) {
    switch (frequency.toLowerCase()) {
      case 'daily':
        return Colors.green;
      case 'weekly':
        return Colors.blue;
      case 'monthly':
        return Colors.purple;
      default:
        return Colors.grey;
    }
  }

  void _confirmDelete(ReminderModel reminder, ReminderController controller) {
    Get.dialog(
      AlertDialog(
        title: const Text('Delete Reminder'),
        content: Text('Are you sure you want to delete "${reminder.title}"?'),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              Get.back();
              controller.deleteReminder(reminder.id!);
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}

extension on Object {
  get id => null;
}
