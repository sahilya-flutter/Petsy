import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';
import '../../controllers/appointment_controller.dart';
import '../../controllers/pet_controller.dart';

class AppointmentScreen extends StatelessWidget {
  final AppointmentController appointmentController = Get.put(
    AppointmentController(),
  );
  final PetController petController = Get.find();

  AppointmentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Get.back(),
        ),
        title: Text(
          'Book an Appointment',
          style: TextStyle(
            color: Colors.black,
            fontSize: 16.sp,
            fontWeight: FontWeight.bold,
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

      // ✅ BODY
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'WHAT WOULD YOU LIKE TO\nBOOK AN APPOINTMENT FOR?',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 11.sp,
                fontWeight: FontWeight.w500,
                color: Colors.black54,
                letterSpacing: 0.5,
              ),
            ),
            SizedBox(height: 4.h),

            // 🔹 Option Buttons vertically
            _buildOptionCard(
              icon: Icons.medical_services_outlined,
              title: 'Veterinaries',
              color: Colors.teal,
            ),
            SizedBox(height: 2.h),
            _buildOptionCard(
              icon: Icons.people_outline,
              title: 'Care Takers',
              color: Colors.orange,
            ),
            SizedBox(height: 2.h),
            _buildOptionCard(
              icon: Icons.restaurant_menu,
              title: 'Restaurants',
              color: Colors.purple,
            ),
            SizedBox(height: 2.h),
            _buildOptionCard(
              icon: Icons.hotel_outlined,
              title: 'Hotels',
              color: Colors.indigo,
            ),
          ],
        ),
      ),
    );
  }

  // 🔹 Option Card Widget
  Widget _buildOptionCard({
    required IconData icon,
    required String title,
    required Color color,
  }) {
    return GestureDetector(
      onTap: () => _showBookingDialog(title, color),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 25,
              backgroundColor: color.withOpacity(0.1),
              child: Icon(icon, size: 28, color: color),
            ),
            SizedBox(width: 4.w),
            Text(
              title,
              style: TextStyle(
                fontSize: 13.sp,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 🔹 Booking Dialog
  void _showBookingDialog(String serviceType, Color themeColor) {
    final TextEditingController titleController = TextEditingController();
    final TextEditingController locationController = TextEditingController();
    final Rx<DateTime> selectedDate = DateTime.now().obs;
    final Rx<TimeOfDay> selectedTime = TimeOfDay.now().obs;
    final Rx<int?> selectedPetId = Rx<int?>(null);

    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: EdgeInsets.all(5.w),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Book $serviceType Appointment',
                  style: TextStyle(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.bold,
                    color: themeColor,
                  ),
                ),
                SizedBox(height: 3.h),

                // 🔸 Select Pet Dropdown
                Obx(
                  () => DropdownButtonFormField<int>(
                    decoration: InputDecoration(
                      labelText: 'Select Pet',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
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

                // 🔸 Title Field
                TextField(
                  controller: titleController,
                  decoration: InputDecoration(
                    labelText: 'Appointment Title',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                SizedBox(height: 2.h),

                // 🔸 Date and Time picker
                Row(
                  children: [
                    Expanded(
                      child: Obx(
                        () => InkWell(
                          onTap: () async {
                            final picked = await showDatePicker(
                              context: Get.context!,
                              initialDate: selectedDate.value,
                              firstDate: DateTime.now(),
                              lastDate: DateTime.now().add(
                                const Duration(days: 365),
                              ),
                            );
                            if (picked != null) selectedDate.value = picked;
                          },
                          child: InputDecorator(
                            decoration: InputDecoration(
                              labelText: 'Date',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: Text(
                              DateFormat(
                                'dd MMM yyyy',
                              ).format(selectedDate.value),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 3.w),
                    Expanded(
                      child: Obx(
                        () => InkWell(
                          onTap: () async {
                            final picked = await showTimePicker(
                              context: Get.context!,
                              initialTime: selectedTime.value,
                            );
                            if (picked != null) selectedTime.value = picked;
                          },
                          child: InputDecorator(
                            decoration: InputDecoration(
                              labelText: 'Time',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: Text(
                              selectedTime.value.format(Get.context!),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 2.h),

                // 🔸 Location
                TextField(
                  controller: locationController,
                  decoration: InputDecoration(
                    labelText: 'Location',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                SizedBox(height: 3.h),

                // 🔹 Buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Get.back(),
                      child: const Text('Cancel'),
                    ),
                    SizedBox(width: 2.w),
                    ElevatedButton(
                      onPressed: () {
                        if (titleController.text.isEmpty ||
                            selectedPetId.value == null) {
                          Get.snackbar(
                            'Error',
                            'Please fill all fields',
                            snackPosition: SnackPosition.BOTTOM,
                          );
                          return;
                        }

                        appointmentController.addAppointment(
                          petId: selectedPetId.value!,
                          title: titleController.text,
                          type: serviceType,
                          date: DateFormat(
                            'yyyy-MM-dd',
                          ).format(selectedDate.value),
                          time: selectedTime.value.format(Get.context!),
                          location: locationController.text,
                          notes: '',
                        );

                        Get.back();
                        Get.snackbar(
                          'Success',
                          '$serviceType appointment booked successfully!',
                          snackPosition: SnackPosition.BOTTOM,
                          backgroundColor: themeColor.withOpacity(0.8),
                          colorText: Colors.white,
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: themeColor,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50),
                        ),
                        padding: EdgeInsets.symmetric(
                          horizontal: 6.w,
                          vertical: 1.5.h,
                        ),
                      ),
                      child: const Text('Book'),
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
