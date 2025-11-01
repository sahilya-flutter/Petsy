// Appointment screen
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:intl/intl.dart';
import '../../controllers/appointment_controller.dart';
import '../../controllers/pet_controller.dart';

class AppointmentScreen extends StatelessWidget {
  final AppointmentController appointmentController = Get.put(
    AppointmentController(),
  );
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
          'Appointments',
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.add, color: Colors.white),
            onPressed: () => _showAddAppointmentDialog(context),
          ),
        ],
      ),
      body: Obx(() {
        if (appointmentController.isLoading.value) {
          return Center(child: CircularProgressIndicator());
        }

        if (appointmentController.appointments.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.calendar_today_outlined,
                  size: 60.sp,
                  color: Colors.grey[300],
                ),
                SizedBox(height: 2.h),
                Text(
                  'No appointments yet',
                  style: TextStyle(fontSize: 14.sp, color: Colors.grey[600]),
                ),
                SizedBox(height: 1.h),
                ElevatedButton.icon(
                  onPressed: () => _showAddAppointmentDialog(context),
                  icon: Icon(Icons.add),
                  label: Text('Book Appointment'),
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
          itemCount: appointmentController.appointments.length,
          itemBuilder: (context, index) {
            final appointment = appointmentController.appointments[index];
            return _buildAppointmentCard(appointment);
          },
        );
      }),
    );
  }

  Widget _buildAppointmentCard(Map<String, dynamic> appointment) {
    final date = DateTime.parse(appointment['date']);
    final typeColors = {
      'Veterinary': Colors.blue,
      'Grooming': Colors.purple,
      'Training': Colors.orange,
      'Other': Colors.green,
    };

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
                  padding: EdgeInsets.symmetric(
                    horizontal: 3.w,
                    vertical: 0.5.h,
                  ),
                  decoration: BoxDecoration(
                    color: (typeColors[appointment['type']] ?? Colors.grey)
                        .withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    appointment['type'],
                    style: TextStyle(
                      fontSize: 10.sp,
                      color: typeColors[appointment['type']] ?? Colors.grey,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Spacer(),
                IconButton(
                  icon: Icon(Icons.delete_outline, color: Colors.red),
                  onPressed: () {
                    Get.defaultDialog(
                      title: 'Delete Appointment',
                      middleText: 'Are you sure?',
                      textConfirm: 'Delete',
                      textCancel: 'Cancel',
                      confirmTextColor: Colors.white,
                      onConfirm: () {
                        appointmentController.deleteAppointment(
                          appointment['id'],
                        );
                        Get.back();
                      },
                    );
                  },
                ),
              ],
            ),
            SizedBox(height: 1.h),
            Text(
              appointment['title'],
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 1.h),
            Row(
              children: [
                Icon(
                  Icons.calendar_today,
                  size: 14.sp,
                  color: Colors.grey[600],
                ),
                SizedBox(width: 2.w),
                Text(
                  DateFormat('dd MMM yyyy').format(date),
                  style: TextStyle(fontSize: 11.sp, color: Colors.grey[600]),
                ),
                SizedBox(width: 4.w),
                Icon(Icons.access_time, size: 14.sp, color: Colors.grey[600]),
                SizedBox(width: 2.w),
                Text(
                  appointment['time'],
                  style: TextStyle(fontSize: 11.sp, color: Colors.grey[600]),
                ),
              ],
            ),
            if (appointment['location'] != null &&
                appointment['location'].isNotEmpty) ...[
              SizedBox(height: 1.h),
              Row(
                children: [
                  Icon(Icons.location_on, size: 14.sp, color: Colors.grey[600]),
                  SizedBox(width: 2.w),
                  Expanded(
                    child: Text(
                      appointment['location'],
                      style: TextStyle(
                        fontSize: 11.sp,
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

  void _showAddAppointmentDialog(BuildContext context) {
    final TextEditingController titleController = TextEditingController();
    final TextEditingController locationController = TextEditingController();
    final TextEditingController notesController = TextEditingController();
    final RxString selectedType = 'Veterinary'.obs;
    final Rx<DateTime> selectedDate = DateTime.now().obs;
    final Rx<TimeOfDay> selectedTime = TimeOfDay.now().obs;
    final Rx<int?> selectedPetId = Rx<int?>(null);

    final List<String> appointmentTypes = [
      'Veterinary',
      'Grooming',
      'Training',
      'Other',
    ];

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
                  'Book an Appointment',
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
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                SizedBox(height: 2.h),

                // Type
                Text('Type', style: TextStyle(fontWeight: FontWeight.bold)),
                SizedBox(height: 1.h),
                Obx(
                  () => Wrap(
                    spacing: 2.w,
                    children: appointmentTypes.map((type) {
                      return ChoiceChip(
                        label: Text(type),
                        selected: selectedType.value == type,
                        onSelected: (selected) {
                          if (selected) selectedType.value = type;
                        },
                        selectedColor: Color(0xFF7B2CBF),
                        labelStyle: TextStyle(
                          color: selectedType.value == type
                              ? Colors.white
                              : Colors.black,
                        ),
                      );
                    }).toList(),
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
                SizedBox(height: 2.h),

                // Location
                TextField(
                  controller: locationController,
                  decoration: InputDecoration(
                    labelText: 'Location (Optional)',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                SizedBox(height: 2.h),

                // Notes
                TextField(
                  controller: notesController,
                  maxLines: 3,
                  decoration: InputDecoration(
                    labelText: 'Notes (Optional)',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
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
                          appointmentController.addAppointment(
                            petId: selectedPetId.value!,
                            title: titleController.text,
                            type: selectedType.value,
                            date: DateFormat(
                              'yyyy-MM-dd',
                            ).format(selectedDate.value),
                            time: selectedTime.value.format(context),
                            location: locationController.text,
                            notes: notesController.text,
                          );
                        } else {
                          Get.snackbar('Error', 'Please fill required fields');
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF7B2CBF),
                        foregroundColor: Colors.white,
                      ),
                      child: Text('Book'),
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
