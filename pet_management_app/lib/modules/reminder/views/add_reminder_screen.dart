import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pet_management_app/app/data/model/reminder_model.dart';
import 'package:pet_management_app/modules/widget/custom_button.dart';
import 'package:pet_management_app/modules/widget/custom_textfield.dart';
import 'package:sizer/sizer.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';
import 'package:intl/intl.dart';
import '../controllers/reminder_controller.dart';
import '../../auth/controllers/auth_controller.dart';
import '../../pet/controllers/pet_controller.dart';

class AddReminderScreen extends StatefulWidget {
  const AddReminderScreen({Key? key}) : super(key: key);

  @override
  State<AddReminderScreen> createState() => _AddReminderScreenState();
}

class _AddReminderScreenState extends State<AddReminderScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

  DateTime _reminderDate = DateTime.now().add(const Duration(hours: 1));
  int? _selectedPetId;
  String _selectedFrequency = 'once';

  final List<Map<String, dynamic>> _frequencies = [
    {'value': 'once', 'label': 'Once', 'icon': Icons.looks_one},
    {'value': 'daily', 'label': 'Daily', 'icon': Icons.today},
    {'value': 'weekly', 'label': 'Weekly', 'icon': Icons.view_week},
    {'value': 'monthly', 'label': 'Monthly', 'icon': Icons.calendar_month},
  ];

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final reminderController = Get.find<ReminderController>();
    final authController = Get.find<AuthController>();
    final petController = Get.find<PetController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('New Reminder'),
        backgroundColor: Colors.purple,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(5.w),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Reminder Icon
              Center(
                child: Container(
                  padding: EdgeInsets.all(5.w),
                  decoration: BoxDecoration(
                    color: Colors.orange.shade100,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.alarm_add,
                    size: 50.sp,
                    color: Colors.orange,
                  ),
                ),
              ),

              SizedBox(height: 3.h),

              // Title
              CustomTextField(
                controller: _titleController,
                label: 'Reminder Title',
                prefixIcon: Icons.title,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter reminder title';
                  }
                  return null;
                },
              ),

              SizedBox(height: 2.h),

              // Pet Selection (Optional)
              Obx(() {
                final pets = petController.pets;

                if (pets.isEmpty) {
                  return const SizedBox.shrink();
                }

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Link to Pet (Optional)',
                      style: TextStyle(
                        fontSize: 11.sp,
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 1.h),
                    DropdownButtonFormField<int?>(
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
                      items: [
                        const DropdownMenuItem(
                          value: null,
                          child: Text('None'),
                        ),
                        ...pets.map((pet) {
                          return DropdownMenuItem(
                            value: pet.id,
                            child: Text(pet.name),
                          );
                        }).toList(),
                      ],
                      onChanged: (value) {
                        setState(() {
                          _selectedPetId = value;
                        });
                      },
                    ),
                    SizedBox(height: 2.h),
                  ],
                );
              }),

              // Date & Time Picker
              InkWell(
                onTap: () => _selectDateTime(),
                child: InputDecorator(
                  decoration: InputDecoration(
                    labelText: 'Reminder Date & Time',
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
                        ).format(_reminderDate),
                        style: TextStyle(fontSize: 12.sp),
                      ),
                      const Icon(Icons.calendar_today, size: 20),
                    ],
                  ),
                ),
              ),

              SizedBox(height: 2.h),

              // Frequency Selection
              Text(
                'Frequency',
                style: TextStyle(
                  fontSize: 11.sp,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 1.h),

              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 2.w,
                  mainAxisSpacing: 2.w,
                  childAspectRatio: 2.5,
                ),
                itemCount: _frequencies.length,
                itemBuilder: (context, index) {
                  final freq = _frequencies[index];
                  final isSelected = _selectedFrequency == freq['value'];

                  return InkWell(
                    onTap: () {
                      setState(() {
                        _selectedFrequency = freq['value'];
                      });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: isSelected ? Colors.purple : Colors.grey[200],
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isSelected
                              ? Colors.purple
                              : Colors.transparent,
                          width: 2,
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            freq['icon'],
                            color: isSelected ? Colors.white : Colors.grey[700],
                            size: 18.sp,
                          ),
                          SizedBox(width: 2.w),
                          Text(
                            freq['label'],
                            style: TextStyle(
                              fontSize: 11.sp,
                              color: isSelected
                                  ? Colors.white
                                  : Colors.grey[700],
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
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
                  text: 'Set Reminder',
                  isLoading: reminderController.isLoading.value,
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      final userId = authController.currentUser.value?.id;
                      if (userId != null) {
                        final reminder = ReminderModel(
                          userId: userId,
                          petId: _selectedPetId,
                          title: _titleController.text.trim(),
                          description:
                              _descriptionController.text.trim().isEmpty
                              ? null
                              : _descriptionController.text.trim(),
                          reminderDate: _reminderDate,
                          frequency: _selectedFrequency,
                        );
                        reminderController.addReminder(reminder);
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
      currentTime: _reminderDate,
      locale: LocaleType.en,
      onConfirm: (date) {
        setState(() {
          _reminderDate = date;
        });
      },
    );
  }
}
