import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';
import '../../controllers/appointment_controller.dart';
import '../../controllers/reminder_controller.dart';
import '../../controllers/pet_controller.dart';

class AgendaScreen extends StatelessWidget {
  final AppointmentController appointmentController = Get.put(
    AppointmentController(),
  );
  final ReminderController reminderController = Get.put(ReminderController());
  final PetController petController = Get.find();

  AgendaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final currentDate = DateTime.now();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Get.back(),
        ),
        title: Text(
          'Agenda',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 16.sp,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.menu, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          // 🔹 Date Header
          Container(
            margin: EdgeInsets.symmetric(horizontal: 4.w),
            padding: EdgeInsets.symmetric(vertical: 1.5.h, horizontal: 4.w),
            decoration: BoxDecoration(
              color: const Color(0xFF00BFA6),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Icon(Icons.arrow_back_ios, color: Colors.white, size: 16),
                Text(
                  DateFormat('EEEE, d MMM').format(currentDate),
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.white,
                  size: 16,
                ),
              ],
            ),
          ),
          SizedBox(height: 2.h),

          // 🔹 Agenda box
          Expanded(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 6.w),
              padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
              decoration: BoxDecoration(
                color: const Color(0xFFFFD6A5),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Obx(() {
                final allItems = <Map<String, dynamic>>[];

                for (var apt in appointmentController.appointments) {
                  allItems.add({
                    'time': apt['time'],
                    'title': apt['title'],
                    'date': apt['date'],
                    'type': 'appointment',
                  });
                }
                for (var rem in reminderController.reminders) {
                  allItems.add({
                    'time': rem['time'],
                    'title': rem['title'],
                    'date': rem['date'],
                    'type': 'reminder',
                  });
                }

                allItems.sort((a, b) => a['time'].compareTo(b['time']));

                if (allItems.isEmpty) {
                  return Center(
                    child: Text(
                      'No tasks for today',
                      style: TextStyle(color: Colors.black54, fontSize: 12.sp),
                    ),
                  );
                }

                return ListView.builder(
                  itemCount: allItems.length,
                  itemBuilder: (context, index) {
                    final item = allItems[index];
                    return Padding(
                      padding: EdgeInsets.symmetric(vertical: 1.h),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: 15.w,
                            child: Text(
                              item['time'],
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                                fontSize: 11.sp,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Text(
                              item['title'],
                              style: TextStyle(
                                fontSize: 11.5.sp,
                                color: Colors.black,
                                height: 1.3,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              }),
            ),
          ),

          SizedBox(height: 2.h),

          // 🔹 Add More Button
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 6.w),
            child: ElevatedButton(
              onPressed: () => _showAddDialog(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF00BFA6),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                minimumSize: Size(double.infinity, 6.h),
              ),
              child: Text(
                'Add more',
                style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w600),
              ),
            ),
          ),
          SizedBox(height: 2.h),
        ],
      ),
    );
  }

  // 🔸 Add Dialog for Appointment / Reminder
  void _showAddDialog(BuildContext context) {
    final RxInt selectedTab = 0.obs;

    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: EdgeInsets.all(5.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Add to Agenda',
                style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 3.h),
              Obx(
                () => Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () => selectedTab.value = 0,
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 1.5.h),
                          decoration: BoxDecoration(
                            color: selectedTab.value == 0
                                ? const Color(0xFF00BFA6)
                                : Colors.grey[200],
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Center(
                            child: Text(
                              'Appointment',
                              style: TextStyle(
                                color: selectedTab.value == 0
                                    ? Colors.white
                                    : Colors.black54,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 3.w),
                    Expanded(
                      child: GestureDetector(
                        onTap: () => selectedTab.value = 1,
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 1.5.h),
                          decoration: BoxDecoration(
                            color: selectedTab.value == 1
                                ? const Color(0xFF00BFA6)
                                : Colors.grey[200],
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Center(
                            child: Text(
                              'Reminder',
                              style: TextStyle(
                                color: selectedTab.value == 1
                                    ? Colors.white
                                    : Colors.black54,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 3.h),
              ElevatedButton(
                onPressed: () {
                  Get.back();
                  if (selectedTab.value == 0) {
                    Get.toNamed('/appointments');
                  } else {
                    _showAddReminderForm(context);
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF00BFA6),
                  foregroundColor: Colors.white,
                  minimumSize: Size(double.infinity, 6.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                  ),
                ),
                child: const Text('Continue'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // 🔸 Add Reminder Form
  void _showAddReminderForm(BuildContext context) {
    final TextEditingController titleController = TextEditingController();
    final TextEditingController descController = TextEditingController();
    final Rx<DateTime> selectedDate = DateTime.now().obs;
    final Rx<TimeOfDay> selectedTime = TimeOfDay.now().obs;

    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: EdgeInsets.all(5.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Add Reminder',
                style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 3.h),
              TextField(
                controller: titleController,
                decoration: InputDecoration(
                  labelText: 'Title',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              SizedBox(height: 2.h),
              TextField(
                controller: descController,
                decoration: InputDecoration(
                  labelText: 'Description',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              SizedBox(height: 2.h),
              Row(
                children: [
                  Expanded(
                    child: Obx(
                      () => ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: const Icon(Icons.calendar_today),
                        title: Text(
                          DateFormat('dd MMM yyyy').format(selectedDate.value),
                        ),
                        onTap: () async {
                          final date = await showDatePicker(
                            context: context,
                            initialDate: selectedDate.value,
                            firstDate: DateTime.now(),
                            lastDate: DateTime.now().add(
                              const Duration(days: 365),
                            ),
                          );
                          if (date != null) selectedDate.value = date;
                        },
                      ),
                    ),
                  ),
                  Expanded(
                    child: Obx(
                      () => ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: const Icon(Icons.access_time),
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
                  ),
                ],
              ),
              SizedBox(height: 3.h),
              Align(
                alignment: Alignment.centerRight,
                child: ElevatedButton(
                  onPressed: () {
                    if (titleController.text.isNotEmpty) {
                      reminderController.addReminder(
                        petId: 1,
                        title: titleController.text,
                        description: descController.text,
                        date: DateFormat(
                          'yyyy-MM-dd',
                        ).format(selectedDate.value),
                        time: selectedTime.value.format(context),
                      );
                      Get.back();
                    } else {
                      Get.snackbar('Error', 'Please fill all fields');
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF00BFA6),
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Add'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
