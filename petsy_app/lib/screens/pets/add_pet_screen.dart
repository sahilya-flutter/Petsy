// Add Pet screen
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:intl/intl.dart';
import '../../controllers/pet_controller.dart';

class AddPetScreen extends StatelessWidget {
  final PetController petController = Get.find();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController breedController = TextEditingController();

  final RxString selectedSpecies = 'Dog'.obs;
  final RxString selectedGender = 'Male'.obs;
  final Rx<DateTime> selectedBirthday = DateTime.now().obs;

  final List<String> speciesList = [
    'Dog',
    'Cat',
    'Bird',
    'Rabbit',
    'Fish',
    'Other',
  ];
  final List<String> genderList = ['Male', 'Female'];

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
          'Add Pet',
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(5.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Pet Icon
            Center(
              child: Container(
                padding: EdgeInsets.all(6.w),
                decoration: BoxDecoration(
                  color: Color(0xFF7B2CBF).withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.pets, size: 50.sp, color: Color(0xFF7B2CBF)),
              ),
            ),
            SizedBox(height: 4.h),

            // Pet Name
            Text(
              'Pet Name',
              style: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 1.h),
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                hintText: 'Enter pet name',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: Colors.grey[300]!),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: Colors.grey[300]!),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: Color(0xFF7B2CBF)),
                ),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 4.w,
                  vertical: 2.h,
                ),
              ),
            ),
            SizedBox(height: 2.h),

            // Pet Species
            Text(
              'Pet Species',
              style: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 1.h),
            Obx(
              () => Container(
                padding: EdgeInsets.symmetric(horizontal: 4.w),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey[300]!),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: DropdownButton<String>(
                  value: selectedSpecies.value,
                  isExpanded: true,
                  underline: SizedBox(),
                  items: speciesList.map((String species) {
                    return DropdownMenuItem<String>(
                      value: species,
                      child: Text(species),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    if (newValue != null) {
                      selectedSpecies.value = newValue;
                    }
                  },
                ),
              ),
            ),
            SizedBox(height: 2.h),

            // Pet Breed
            Text(
              'Pet Breed',
              style: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 1.h),
            TextField(
              controller: breedController,
              decoration: InputDecoration(
                hintText: 'Enter pet breed',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: Colors.grey[300]!),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: Colors.grey[300]!),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: Color(0xFF7B2CBF)),
                ),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 4.w,
                  vertical: 2.h,
                ),
              ),
            ),
            SizedBox(height: 2.h),

            // Pet Gender
            Text(
              'Pet Gender',
              style: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 1.h),
            Obx(
              () => Container(
                padding: EdgeInsets.symmetric(horizontal: 4.w),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey[300]!),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: DropdownButton<String>(
                  value: selectedGender.value,
                  isExpanded: true,
                  underline: SizedBox(),
                  items: genderList.map((String gender) {
                    return DropdownMenuItem<String>(
                      value: gender,
                      child: Text(gender),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    if (newValue != null) {
                      selectedGender.value = newValue;
                    }
                  },
                ),
              ),
            ),
            SizedBox(height: 2.h),

            // Pet Birthday
            Text(
              "Select Pet's Birthday",
              style: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 1.h),
            Obx(
              () => InkWell(
                onTap: () async {
                  final DateTime? picked = await showDatePicker(
                    context: context,
                    initialDate: selectedBirthday.value,
                    firstDate: DateTime(2000),
                    lastDate: DateTime.now(),
                    builder: (context, child) {
                      return Theme(
                        data: Theme.of(context).copyWith(
                          colorScheme: ColorScheme.light(
                            primary: Color(0xFF7B2CBF),
                          ),
                        ),
                        child: child!,
                      );
                    },
                  );
                  if (picked != null) {
                    selectedBirthday.value = picked;
                  }
                },
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey[300]!),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        DateFormat(
                          'dd MMM yyyy',
                        ).format(selectedBirthday.value),
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: Colors.black87,
                        ),
                      ),
                      Icon(Icons.calendar_today, color: Color(0xFF7B2CBF)),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: 4.h),

            // Next Button
            Obx(
              () => SizedBox(
                width: double.infinity,
                height: 6.h,
                child: ElevatedButton(
                  onPressed: petController.isLoading.value
                      ? null
                      : () {
                          if (nameController.text.isNotEmpty &&
                              breedController.text.isNotEmpty) {
                            petController.addPet(
                              name: nameController.text,
                              species: selectedSpecies.value,
                              breed: breedController.text,
                              gender: selectedGender.value,
                              birthday: DateFormat(
                                'yyyy-MM-dd',
                              ).format(selectedBirthday.value),
                            );
                          } else {
                            Get.snackbar(
                              'Error',
                              'Please fill all fields',
                              snackPosition: SnackPosition.BOTTOM,
                            );
                          }
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF7B2CBF),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: petController.isLoading.value
                      ? CircularProgressIndicator(color: Colors.white)
                      : Text(
                          'Next',
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
