// Home screen
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import '../../controllers/auth_controller.dart';
import '../../controllers/pet_controller.dart';

class HomeScreen extends StatelessWidget {
  final AuthController authController = Get.find();
  final PetController petController = Get.put(PetController());

  @override
  Widget build(BuildContext context) {
    petController.loadPets();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF7B2CBF),
        elevation: 0,
        title: Text(
          'Petsy',
          style: TextStyle(
            fontSize: 20.sp,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.notifications_outlined, color: Colors.white),
            onPressed: () {},
          ),
          PopupMenuButton(
            icon: Icon(Icons.more_vert, color: Colors.white),
            itemBuilder: (context) => [
              PopupMenuItem(child: Text('Profile'), value: 'profile'),
              PopupMenuItem(child: Text('Settings'), value: 'settings'),
              PopupMenuItem(child: Text('Logout'), value: 'logout'),
            ],
            onSelected: (value) {
              if (value == 'logout') {
                authController.signOut();
              }
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Section
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(5.w),
              decoration: BoxDecoration(
                color: Color(0xFF7B2CBF),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Welcome Back! 👋',
                    style: TextStyle(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 1.h),
                  Text(
                    'Manage your pets with ease',
                    style: TextStyle(fontSize: 12.sp, color: Colors.white70),
                  ),
                ],
              ),
            ),

            // Quick Actions
            Padding(
              padding: EdgeInsets.all(5.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Quick Actions',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildQuickAction(
                        icon: Icons.calendar_today,
                        label: 'Appointments',
                        color: Colors.blue,
                        onTap: () => Get.toNamed('/appointments'),
                      ),
                      _buildQuickAction(
                        icon: Icons.alarm,
                        label: 'Agenda',
                        color: Colors.orange,
                        onTap: () => Get.toNamed('/agenda'),
                      ),
                      _buildQuickAction(
                        icon: Icons.qr_code_scanner,
                        label: 'Scanner',
                        color: Colors.green,
                        onTap: () {
                          Get.snackbar('Scanner', 'Coming soon!');
                        },
                      ),
                      _buildQuickAction(
                        icon: Icons.emergency,
                        label: 'Emergency',
                        color: Colors.red,
                        onTap: () {
                          Get.snackbar(
                            'Emergency',
                            'Calling emergency services...',
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // My Pets Section
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 5.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'My Pets',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  TextButton.icon(
                    onPressed: () => Get.toNamed('/add-pet'),
                    icon: Icon(Icons.add_circle_outline, size: 18.sp),
                    label: Text('Add Pet', style: TextStyle(fontSize: 11.sp)),
                    style: TextButton.styleFrom(
                      foregroundColor: Color(0xFF7B2CBF),
                    ),
                  ),
                ],
              ),
            ),

            // Pets List
            Obx(() {
              if (petController.isLoading.value) {
                return Center(
                  child: Padding(
                    padding: EdgeInsets.all(5.h),
                    child: CircularProgressIndicator(),
                  ),
                );
              }

              if (petController.pets.isEmpty) {
                return Center(
                  child: Padding(
                    padding: EdgeInsets.all(5.h),
                    child: Column(
                      children: [
                        Icon(Icons.pets, size: 60.sp, color: Colors.grey[300]),
                        SizedBox(height: 2.h),
                        Text(
                          'No pets added yet',
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: Colors.grey[600],
                          ),
                        ),
                        SizedBox(height: 1.h),
                        ElevatedButton.icon(
                          onPressed: () => Get.toNamed('/add-pet'),
                          icon: Icon(Icons.add),
                          label: Text('Add Your First Pet'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFF7B2CBF),
                            foregroundColor: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }

              return ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                padding: EdgeInsets.symmetric(horizontal: 5.w),
                itemCount: petController.pets.length,
                itemBuilder: (context, index) {
                  final pet = petController.pets[index];
                  return _buildPetCard(pet);
                },
              );
            }),
            SizedBox(height: 3.h),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNavBar(),
    );
  }

  Widget _buildQuickAction({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Icon(icon, size: 25.sp, color: color),
          ),
          SizedBox(height: 1.h),
          Text(
            label,
            style: TextStyle(fontSize: 10.sp, color: Colors.black87),
          ),
        ],
      ),
    );
  }

  Widget _buildPetCard(Map<String, dynamic> pet) {
    return Card(
      margin: EdgeInsets.only(bottom: 2.h),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: EdgeInsets.all(4.w),
        child: Row(
          children: [
            CircleAvatar(
              radius: 30.sp,
              backgroundColor: Color(0xFF7B2CBF).withOpacity(0.2),
              child: Icon(Icons.pets, size: 30.sp, color: Color(0xFF7B2CBF)),
            ),
            SizedBox(width: 4.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    pet['name'] ?? 'Unknown',
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: 0.5.h),
                  Text(
                    '${pet['species']} • ${pet['breed']}',
                    style: TextStyle(fontSize: 11.sp, color: Colors.grey[600]),
                  ),
                  SizedBox(height: 0.5.h),
                  Text(
                    'Gender: ${pet['gender']}',
                    style: TextStyle(fontSize: 10.sp, color: Colors.grey[500]),
                  ),
                ],
              ),
            ),
            IconButton(
              icon: Icon(Icons.delete_outline, color: Colors.red),
              onPressed: () {
                Get.defaultDialog(
                  title: 'Delete Pet',
                  middleText: 'Are you sure you want to delete ${pet['name']}?',
                  textConfirm: 'Delete',
                  textCancel: 'Cancel',
                  confirmTextColor: Colors.white,
                  onConfirm: () {
                    petController.deletePet(pet['id']);
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

  Widget _buildBottomNavBar() {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      selectedItemColor: Color(0xFF7B2CBF),
      unselectedItemColor: Colors.grey,
      currentIndex: 0,
      items: [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
        BottomNavigationBarItem(
          icon: Icon(Icons.calendar_today),
          label: 'Appointments',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.qr_code_scanner),
          label: 'Scanner',
        ),
        BottomNavigationBarItem(icon: Icon(Icons.forum), label: 'Forum'),
      ],
      onTap: (index) {
        if (index == 1) {
          Get.toNamed('/appointments');
        } else if (index == 3) {
          Get.snackbar('Forum', 'Coming soon!');
        }
      },
    );
  }
}
