// Agenda screen
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:intl/intl.dart';
import '../../controllers/reminder_controller.dart';
import '../../controllers/pet_controller.dart';

class AgendaScreen extends StatelessWidget {
  final ReminderController reminderController = Get.put(ReminderController());
  final PetController petController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF7B2CBF),
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Get.back(),
        ),
        title: Text(
          'Agenda',
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.add, color: Colors.white),
            onPressed: () => _showAddReminderDialog(context),
          ),
        ],
      ),
      body: Column(
        children: [
          // Calendar Header
          Container(
            padding: EdgeInsets.all(4.w),
            color: Color(0xFF7B2CBF).withOpacity(0.1),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  DateFormat('MMMM yyyy').format(DateTime.now()),
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.chevron_left),
                      onPressed: () {},
                    ),
                    IconButton(
                      icon: Icon(Icons.chevron_right),
                      onPressed: () {},
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Reminders List
          Expanded(
            child: Obx(() {
              if (reminderController.isLoading.value) {
                return Center(child: CircularProgressIndicator());
              }

              if (reminderController.reminders.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.alarm_off,
                        size: 60.sp,
                        color: Colors.grey[300],
                      ),
                      SizedBox(height: 2.h),
                      Text(
                        'No reminders yet',
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: Colors.grey[600],
                        ),
                      ),
                      SizedBox(height: 1.h),
                      ElevatedButton.icon(
                        onPressed: () => _showAddReminderDialog(context),
                        icon: Icon(Icons.add),
                        label: Text('Add Reminder'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF7B2CBF),
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ],
                  ),
                );
              }

              return ListView.builder(
                padding: EdgeInsets.all(4.w),
                itemCount: reminderController.reminders.length,
                itemBuilder: (context, index) {
                  final reminder = reminderController.reminders[index];
                  return _buildReminderCard(reminder);
                },
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildReminderCard(Map<String, dynamic> reminder) {
    final date = DateTime.parse(reminder['date']);
    final isCompleted = reminder['isCompleted'] == 1;

    return Card(
      margin: EdgeInsets.only(bottom: 2.h),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: EdgeInsets.all(4.w),
        child: Row(
          children: [
            Obx(
              () => Checkbox(
                value: isCompleted,
                onChanged: (value) {
                  reminderController.toggleReminderCompletion(
                    reminder['id'],
                    value ?? false,
                  );
                },
                activeColor: Color(0xFF7B2CBF),
              ),
            ),
            SizedBox(width: 2.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    reminder['title'],
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                      decoration: isCompleted
                          ? TextDecoration.lineThrough
                          : null,
                    ),
                  ),
                  if (reminder['description'] != null &&
                      reminder['description'].isNotEmpty) ...[
                    SizedBox(height: 0.5.h),
                    Text(
                      reminder['description'],
                      style: TextStyle(
                        fontSize: 11.sp,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                  SizedBox(height: 1.h),
                  Row(
                    children: [
                      Icon(
                        Icons.calendar_today,
                        size: 12.sp,
                        color: Colors.grey[600],
                      ),
                      SizedBox(width: 1.w),
                      Text(
                        DateFormat('dd MMM').format(date),
                        style: TextStyle(
                          fontSize: 10.sp,
                          color: Colors.grey[600],
                        ),
                      ),
                      SizedBox(width: 3.w),
                      Icon(
                        Icons.access_time,
                        size: 12.sp,
                        color: Colors.grey[600],
                      ),
                      SizedBox(width: 1.w),
                      Text(
                        reminder['time'],
                        style: TextStyle(
                          fontSize: 10.sp,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            IconButton(
              icon: Icon(Icons.delete_outline, color: Colors.red),
              onPressed: () {
                Get.defaultDialog(
                  title: 'Delete Reminder',
                  middleText: 'Are you sure?',
                  textConfirm: 'Delete',
                  textCancel: 'Cancel',
                  confirmTextColor: Colors.white,
                  onConfirm: () {
                    reminderController.deleteReminder(reminder['id']);
                    Get.back();
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showAddReminderDialog(BuildContext context) {
    final TextEditingController titleController = TextEditingController();
    final TextEditingController descriptionController = TextEditingController();
    final Rx<DateTime> selectedDate = DateTime.now().obs;
    final Rx<TimeOfDay> selectedTime = TimeOfDay.now().obs;
    final Rx<int?> selectedPetId = Rx<int?>(null);

    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(5.w),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Add a Reminder',
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 3.h),

                // Select Pet
                Text(
                  'Select Pet',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 1.h),
                Obx(
                  () => DropdownButtonFormField<int>(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    hint: Text('Choose a pet'),
                    value: selectedPetId.value,
                    items: petController.pets.map((pet) {
                      return DropdownMenuItem<int>(
                        value: pet['id'],
                        child: Text(pet['name']),
                      );
                    }).toList(),
                    onChanged: (value) => selectedPetId.value = value,
                  ),
                ),
                SizedBox(height: 2.h),

                // Title
                TextField(
                  controller: titleController,
                  decoration: InputDecoration(
                    labelText: 'Title',
                    hintText: 'e.g., Give medication',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                SizedBox(height: 2.h),

                // Description
                TextField(
                  controller: descriptionController,
                  maxLines: 2,
                  decoration: InputDecoration(
                    labelText: 'Description (Optional)',
                    hintText: 'Add details...',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                SizedBox(height: 2.h),

                // Date
                Obx(
                  () => ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: Icon(
                      Icons.calendar_today,
                      color: Color(0xFF7B2CBF),
                    ),
                    title: Text(
                      DateFormat('dd MMM yyyy').format(selectedDate.value),
                    ),
                    onTap: () async {
                      final date = await showDatePicker(
                        context: context,
                        initialDate: selectedDate.value,
                        firstDate: DateTime.now(),
                        lastDate: DateTime.now().add(Duration(days: 365)),
                      );
                      if (date != null) selectedDate.value = date;
                    },
                  ),
                ),

                // Time
                Obx(
                  () => ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: Icon(Icons.access_time, color: Color(0xFF7B2CBF)),
                    title: Text(selectedTime.value.format(context)),
                    onTap: () async {
                      final time = await showTimePicker(
                        context: context,
                        initialTime: selectedTime.value,
                      );
                      if (time != null) selectedTime.value = time;
                    },
                  ),
                ),
                SizedBox(height: 3.h),

                // Buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Get.back(),
                      child: Text('Cancel'),
                    ),
                    SizedBox(width: 2.w),
                    ElevatedButton(
                      onPressed: () {
                        if (titleController.text.isNotEmpty &&
                            selectedPetId.value != null) {
                          reminderController.addReminder(
                            petId: selectedPetId.value!,
                            title: titleController.text,
                            description: descriptionController.text,
                            date: DateFormat(
                              'yyyy-MM-dd',
                            ).format(selectedDate.value),
                            time: selectedTime.value.format(context),
                          );
                        } else {
                          Get.snackbar('Error', 'Please fill required fields');
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF7B2CBF),
                        foregroundColor: Colors.white,
                      ),
                      child: Text('Add'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
