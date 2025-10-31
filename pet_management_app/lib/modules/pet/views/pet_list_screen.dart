import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pet_management_app/app/data/model/pet_model.dart';
import 'package:sizer/sizer.dart';
import 'package:intl/intl.dart';
import '../controllers/pet_controller.dart';
import '../../../routes/app_routes.dart';

class PetListScreen extends StatelessWidget {
  const PetListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final petController = Get.find<PetController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Pets'),
        backgroundColor: Colors.purple,
        elevation: 0,
      ),
      body: Obx(() {
        if (petController.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (petController.pets.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.pets_outlined, size: 80.sp, color: Colors.grey[300]),
                SizedBox(height: 2.h),
                Text(
                  'No pets added yet',
                  style: TextStyle(fontSize: 14.sp, color: Colors.grey[600]),
                ),
                SizedBox(height: 1.h),
                Text(
                  'Tap the + button to add your first pet',
                  style: TextStyle(fontSize: 11.sp, color: Colors.grey[400]),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: EdgeInsets.all(3.w),
          itemCount: petController.pets.length,
          itemBuilder: (context, index) {
            final pet = petController.pets[index];
            return _buildPetCard(pet, petController);
          },
        );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Get.toNamed(AppRoutes.ADD_PET),
        backgroundColor: Colors.purple,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildPetCard(PetModel pet, PetController controller) {
    return Card(
      margin: EdgeInsets.only(bottom: 2.h),
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: InkWell(
        onTap: () => _showPetDetails(pet, controller),
        borderRadius: BorderRadius.circular(15),
        child: Padding(
          padding: EdgeInsets.all(4.w),
          child: Row(
            children: [
              // Pet Avatar
              CircleAvatar(
                radius: 30.sp,
                backgroundColor: Colors.purple.shade100,
                child: Icon(Icons.pets, size: 35.sp, color: Colors.purple),
              ),

              SizedBox(width: 4.w),

              // Pet Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      pet.name,
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 0.5.h),
                    Row(
                      children: [
                        Icon(Icons.category, size: 12.sp, color: Colors.grey),
                        SizedBox(width: 1.w),
                        Text(
                          '${pet.species} • ${pet.breed}',
                          style: TextStyle(
                            fontSize: 10.sp,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 0.5.h),
                    Row(
                      children: [
                        Icon(Icons.cake, size: 12.sp, color: Colors.grey),
                        SizedBox(width: 1.w),
                        Text(
                          '${pet.age} years old',
                          style: TextStyle(
                            fontSize: 10.sp,
                            color: Colors.grey[600],
                          ),
                        ),
                        SizedBox(width: 3.w),
                        Icon(
                          Icons.calendar_today,
                          size: 12.sp,
                          color: Colors.grey,
                        ),
                        SizedBox(width: 1.w),
                        Text(
                          DateFormat('MMM dd, yyyy').format(pet.birthday),
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

              // Menu Button
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
                    _confirmDelete(pet, controller);
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showPetDetails(PetModel pet, PetController controller) {
    Get.bottomSheet(
      Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        padding: EdgeInsets.all(5.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 30.sp,
                  backgroundColor: Colors.purple.shade100,
                  child: Icon(Icons.pets, size: 35.sp, color: Colors.purple),
                ),
                SizedBox(width: 4.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        pet.name,
                        style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '${pet.species} • ${pet.breed}',
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            SizedBox(height: 3.h),
            Divider(),
            SizedBox(height: 2.h),

            _buildDetailRow(
              icon: Icons.cake,
              label: 'Birthday',
              value: DateFormat('MMMM dd, yyyy').format(pet.birthday),
            ),
            SizedBox(height: 2.h),

            _buildDetailRow(
              icon: Icons.timer,
              label: 'Age',
              value: '${pet.age} years old',
            ),

            if (pet.notes != null && pet.notes!.isNotEmpty) ...[
              SizedBox(height: 2.h),
              _buildDetailRow(
                icon: Icons.notes,
                label: 'Notes',
                value: pet.notes!,
              ),
            ],
          ],
        ),
      ),
      isScrollControlled: true,
    );
  }

  Widget _buildDetailRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20.sp, color: Colors.purple),
        SizedBox(width: 3.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 10.sp,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 0.5.h),
              Text(
                value,
                style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _confirmDelete(PetModel pet, PetController controller) {
    Get.dialog(
      AlertDialog(
        title: const Text('Delete Pet'),
        content: Text('Are you sure you want to delete ${pet.name}?'),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              Get.back();
              controller.deletePet(pet.id!);
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
