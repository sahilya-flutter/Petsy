import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pet_management_app/app/data/model/pet_model.dart';
import 'package:pet_management_app/modules/widget/custom_button.dart';
import 'package:pet_management_app/modules/widget/custom_textfield.dart';
import 'package:sizer/sizer.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';
import 'package:intl/intl.dart';
import '../controllers/pet_controller.dart';
import '../../auth/controllers/auth_controller.dart';

class AddPetScreen extends StatefulWidget {
  const AddPetScreen({Key? key}) : super(key: key);

  @override
  State<AddPetScreen> createState() => _AddPetScreenState();
}

class _AddPetScreenState extends State<AddPetScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _breedController = TextEditingController();
  final _notesController = TextEditingController();

  String _selectedSpecies = 'Dog';
  DateTime _birthday = DateTime.now();

  final List<String> _speciesList = [
    'Dog',
    'Cat',
    'Bird',
    'Fish',
    'Rabbit',
    'Hamster',
    'Guinea Pig',
    'Other',
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _breedController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final petController = Get.find<PetController>();
    final authController = Get.find<AuthController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Add New Pet'),
        backgroundColor: Colors.purple,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(5.w),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Pet Avatar Placeholder
              Center(
                child: Stack(
                  children: [
                    CircleAvatar(
                      radius: 50.sp,
                      backgroundColor: Colors.purple.shade100,
                      child: Icon(
                        Icons.pets,
                        size: 60.sp,
                        color: Colors.purple,
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: CircleAvatar(
                        radius: 15.sp,
                        backgroundColor: Colors.purple,
                        child: Icon(
                          Icons.camera_alt,
                          size: 15.sp,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 4.h),

              // Pet Name
              CustomTextField(
                controller: _nameController,
                label: 'Pet Name',
                prefixIcon: Icons.pets,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter pet name';
                  }
                  return null;
                },
              ),

              SizedBox(height: 2.h),

              // Species Dropdown
              DropdownButtonFormField<String>(
                value: _selectedSpecies,
                decoration: InputDecoration(
                  labelText: 'Species',
                  prefixIcon: const Icon(Icons.category),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: Colors.grey[50],
                ),
                items: _speciesList.map((species) {
                  return DropdownMenuItem(value: species, child: Text(species));
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedSpecies = value!;
                  });
                },
              ),

              SizedBox(height: 2.h),

              // Breed
              CustomTextField(
                controller: _breedController,
                label: 'Breed',
                prefixIcon: Icons.info_outline,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter breed';
                  }
                  return null;
                },
              ),

              SizedBox(height: 2.h),

              // Birthday Picker
              InkWell(
                onTap: () => _selectBirthday(),
                child: InputDecorator(
                  decoration: InputDecoration(
                    labelText: 'Birthday',
                    prefixIcon: const Icon(Icons.cake),
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
                        DateFormat('MMMM dd, yyyy').format(_birthday),
                        style: TextStyle(fontSize: 12.sp),
                      ),
                      const Icon(Icons.calendar_today, size: 20),
                    ],
                  ),
                ),
              ),

              SizedBox(height: 2.h),

              // Notes
              CustomTextField(
                controller: _notesController,
                label: 'Notes (Optional)',
                prefixIcon: Icons.notes,
                maxLines: 3,
              ),

              SizedBox(height: 4.h),

              // Submit Button
              Obx(
                () => CustomButton(
                  text: 'Add Pet',
                  isLoading: petController.isLoading.value,
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      final userId = authController.currentUser.value?.id;
                      if (userId != null) {
                        final pet = PetModel(
                          userId: userId,
                          name: _nameController.text.trim(),
                          species: _selectedSpecies,
                          breed: _breedController.text.trim(),
                          birthday: _birthday,
                          notes: _notesController.text.trim().isEmpty
                              ? null
                              : _notesController.text.trim(),
                        );
                        petController.addPet(pet);
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

  void _selectBirthday() {
    DatePicker.showDatePicker(
      context,
      showTitleActions: true,
      minTime: DateTime(1990, 1, 1),
      maxTime: DateTime.now(),
      currentTime: _birthday,
      locale: LocaleType.en,
      onConfirm: (date) {
        setState(() {
          _birthday = date;
        });
      },
    );
  }
}
