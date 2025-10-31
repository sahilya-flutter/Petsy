import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pet_management_app/app/data/model/appointment_model.dart';
import 'package:pet_management_app/modules/widget/custom_button.dart';
import 'package:pet_management_app/modules/widget/custom_textfield.dart';
import 'package:sizer/sizer.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';
import 'package:intl/intl.dart';
import '../controllers/appointment_controller.dart';
import '../../auth/controllers/auth_controller.dart';
import '../../pet/controllers/pet_controller.dart';

class AddAppointmentScreen extends StatefulWidget {
  const AddAppointmentScreen({Key? key}) : super(key: key);

  @override
  State<AddAppointmentScreen> createState() => _AddAppointmentScreenState();
}

class _AddAppointmentScreenState extends State<AddAppointmentScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _locationController = TextEditingController();
  final _descriptionController = TextEditingController();

  DateTime _appointmentDate = DateTime.now().add(const Duration(hours: 1));
  int? _selectedPetId;

  @override
  void dispose() {
    _titleController.dispose();
    _locationController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appointmentController = Get.find<AppointmentController>();
    final authController = Get.find<AuthController>();
    final petController = Get.find<PetController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('New Appointment'),
        backgroundColor: Colors.purple,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(5.w),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Appointment Icon
              Center(
                child: Container(
                  padding: EdgeInsets.all(5.w),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade100,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.calendar_month,
                    size: 50.sp,
                    color: Colors.blue,
                  ),
                ),
              ),

              SizedBox(height: 3.h),

              // Title
              CustomTextField(
                controller: _titleController,
                label: 'Appointment Title',
                prefixIcon: Icons.title,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter appointment title';
                  }
                  return null;
                },
              ),

              SizedBox(height: 2.h),

              // Pet Selection
              Obx(() {
                final pets = petController.pets;

                if (pets.isEmpty) {
                  return Card(
                    child: Padding(
                      padding: EdgeInsets.all(3.w),
                      child: Text(
                        'Please add a pet first',
                        style: TextStyle(color: Colors.grey[600]),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  );
                }

                return DropdownButtonFormField<int>(
                  value: _selectedPetId,
                  decoration: InputDecoration(
                    labelText: 'Select Pet',
                    prefixIcon: const Icon(Icons.pets),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    filled: true,
                    fillColor: Colors.grey[50],
                  ),
                  items: pets.map((pet) {
                    return DropdownMenuItem(
                      value: pet.id,
                      child: Text(pet.name),
                    );
                  }).toList(),
                  validator: (value) {
                    if (value == null) {
                      return 'Please select a pet';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    setState(() {
                      _selectedPetId = value;
                    });
                  },
                );
              }),

              SizedBox(height: 2.h),

              // Date & Time Picker
              InkWell(
                onTap: () => _selectDateTime(),
                child: InputDecorator(
                  decoration: InputDecoration(
                    labelText: 'Date & Time',
                    prefixIcon: const Icon(Icons.access_time),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    filled: true,
                    fillColor: Colors.grey[50],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        DateFormat(
                          'MMM dd, yyyy • hh:mm a',
                        ).format(_appointmentDate),
                        style: TextStyle(fontSize: 12.sp),
                      ),
                      const Icon(Icons.calendar_today, size: 20),
                    ],
                  ),
                ),
              ),

              SizedBox(height: 2.h),

              // Location
              CustomTextField(
                controller: _locationController,
                label: 'Location',
                prefixIcon: Icons.location_on,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter location';
                  }
                  return null;
                },
              ),

              SizedBox(height: 2.h),

              // Description
              CustomTextField(
                controller: _descriptionController,
                label: 'Description (Optional)',
                prefixIcon: Icons.description,
                maxLines: 3,
              ),

              SizedBox(height: 4.h),

              // Submit Button
              Obx(
                () => CustomButton(
                  text: 'Schedule Appointment',
                  isLoading: appointmentController.isLoading.value,
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      final userId = authController.currentUser.value?.id;
                      if (userId != null && _selectedPetId != null) {
                        final appointment = AppointmentModel(
                          userId: userId,
                          petId: _selectedPetId!,
                          title: _titleController.text.trim(),
                          description:
                              _descriptionController.text.trim().isEmpty
                              ? null
                              : _descriptionController.text.trim(),
                          appointmentDate: _appointmentDate,
                          location: _locationController.text.trim(),
                        );
                        appointmentController.addAppointment(appointment);
                      }
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _selectDateTime() {
    DatePicker.showDateTimePicker(
      context,
      showTitleActions: true,
      minTime: DateTime.now(),
      maxTime: DateTime.now().add(const Duration(days: 365)),
      currentTime: _appointmentDate,
      locale: LocaleType.en,
      onConfirm: (date) {
        setState(() {
          _appointmentDate = date;
        });
      },
    );
  }
}
