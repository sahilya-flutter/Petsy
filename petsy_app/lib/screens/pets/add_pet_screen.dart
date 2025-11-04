import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:intl/intl.dart';
import '../../controllers/pet_controller.dart';

class AddPetScreen extends StatelessWidget {
  final PetController petController = Get.find();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController breedController = TextEditingController();

  final RxString selectedSpecies = ''.obs;
  final RxString selectedGender = ''.obs;
  final Rx<DateTime?> selectedBirthday = Rx<DateTime?>(null);

  final List<String> speciesList = [
    'Dog',
    'Cat',
    'Bird',
    'Rabbit',
    'Fish',
    'Hamster',
    'Other',
  ];
  final List<String> genderList = ['Male', 'Female'];

  AddPetScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      // 🔹 Book Appointment style AppBar
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Get.back(),
        ),
        title: Text(
          'Add Your Pet',
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

      // 🔹 Main Body
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 1.h),

            // 🐾 Icon
            Center(
              child: Container(
                width: 24.w,
                height: 24.w,
                decoration: BoxDecoration(
                  color: const Color(0xFFE8DEF8),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.pets,
                  size: 50.sp,
                  color: const Color(0xFF6750A4),
                ),
              ),
            ),

            SizedBox(height: 2.h),

            // 📋 Heading
            Center(
              child: Text(
                'Enter Your Pet Details',
                style: TextStyle(
                  fontSize: 13.sp,
                  color: Colors.black87,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            SizedBox(height: 2.h),

            // 🐶 Pet Name
            _buildLabel('Pet Name'),
            SizedBox(height: 1.h),
            _buildTextField(
              controller: nameController,
              hintText: 'Enter pet name',
            ),

            SizedBox(height: 2.5.h),

            // 🐕 Pet Species
            _buildLabel('Pet Species'),
            SizedBox(height: 1.h),
            Obx(
              () => _buildDropdown(
                hint: 'Select species',
                items: speciesList,
                selectedValue: selectedSpecies.value,
                onChanged: (val) => selectedSpecies.value = val,
              ),
            ),

            SizedBox(height: 1.5.h),

            // 🐩 Pet Breed
            _buildLabel('Pet Breed'),
            SizedBox(height: 1.h),
            _buildTextField(
              controller: breedController,
              hintText: 'Enter breed',
            ),

            SizedBox(height: 1.5.h),

            // 🧬 Gender
            _buildLabel('Pet Gender'),
            SizedBox(height: 1.h),
            Obx(
              () => _buildDropdown(
                hint: 'Select gender',
                items: genderList,
                selectedValue: selectedGender.value,
                onChanged: (val) => selectedGender.value = val,
              ),
            ),

            SizedBox(height: 1.5.h),

            // 🎂 Birthday
            _buildLabel("Pet's Birthday"),
            SizedBox(height: 1.h),
            Obx(
              () => InkWell(
                onTap: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: selectedBirthday.value ?? DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime.now(),
                    builder: (context, child) {
                      return Theme(
                        data: Theme.of(context).copyWith(
                          colorScheme: const ColorScheme.light(
                            primary: Color(0xFF6750A4),
                            onPrimary: Colors.white,
                            onSurface: Colors.black,
                          ),
                        ),
                        child: child!,
                      );
                    },
                  );
                  if (picked != null) selectedBirthday.value = picked;
                },
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 4.w,
                    vertical: 1.8.h,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.grey[50],
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey[300]!),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        selectedBirthday.value == null
                            ? 'Select date'
                            : DateFormat(
                                'dd MMM yyyy',
                              ).format(selectedBirthday.value!),
                        style: TextStyle(
                          fontSize: 12.5.sp,
                          color: selectedBirthday.value == null
                              ? Colors.grey[400]
                              : Colors.black87,
                        ),
                      ),
                      Icon(
                        Icons.calendar_today_outlined,
                        size: 18.sp,
                        color: Colors.grey[600],
                      ),
                    ],
                  ),
                ),
              ),
            ),

            SizedBox(height: 3.h),

            // 🔘 Next Button
            Obx(
              () => SizedBox(
                width: double.infinity,
                height: 6.h,
                child: ElevatedButton(
                  onPressed: petController.isLoading.value
                      ? null
                      : () {
                          if (nameController.text.isEmpty ||
                              breedController.text.isEmpty ||
                              selectedSpecies.value.isEmpty ||
                              selectedGender.value.isEmpty ||
                              selectedBirthday.value == null) {
                            Get.snackbar(
                              'Error',
                              'Please fill all fields',
                              snackPosition: SnackPosition.BOTTOM,
                              backgroundColor: Colors.redAccent,
                              colorText: Colors.white,
                            );
                            return;
                          }

                          petController.addPet(
                            name: nameController.text,
                            species: selectedSpecies.value,
                            breed: breedController.text,
                            gender: selectedGender.value,
                            birthday: DateFormat(
                              'yyyy-MM-dd',
                            ).format(selectedBirthday.value!),
                          );

                          Get.snackbar(
                            'Pet Added',
                            'Your pet has been added successfully!',
                            snackPosition: SnackPosition.BOTTOM,
                            backgroundColor: const Color(
                              0xFF00BFA6,
                            ).withOpacity(0.9),
                            colorText: Colors.white,
                          );
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF00BFA6),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(100),
                    ),
                    elevation: 0,
                  ),
                  child: petController.isLoading.value
                      ? const CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        )
                      : Text(
                          'Next',
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                ),
              ),
            ),

            SizedBox(height: 1.h),
          ],
        ),
      ),
    );
  }

  // 🔹 Reusable Label Widget
  Widget _buildLabel(String text) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 13.sp,
        fontWeight: FontWeight.w600,
        color: Colors.black87,
      ),
    );
  }

  // 🔹 Reusable TextField
  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
  }) {
    return TextField(
      controller: controller,
      style: TextStyle(fontSize: 13.sp),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(color: Colors.grey[400]),
        filled: true,
        fillColor: Colors.grey[50],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFF6750A4), width: 2),
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.8.h),
      ),
    );
  }

  // 🔹 Reusable Dropdown
  Widget _buildDropdown({
    required String hint,
    required List<String> items,
    required String selectedValue,
    required Function(String) onChanged,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4.w),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: selectedValue.isEmpty ? null : selectedValue,
          hint: Text(hint, style: TextStyle(color: Colors.grey[400])),
          isExpanded: true,
          icon: Icon(Icons.keyboard_arrow_down, color: Colors.grey[600]),
          items: items.map((val) {
            return DropdownMenuItem(
              value: val,
              child: Text(val, style: TextStyle(fontSize: 13.sp)),
            );
          }).toList(),
          onChanged: (val) => onChanged(val!),
        ),
      ),
    );
  }
}
