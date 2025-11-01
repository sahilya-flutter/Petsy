import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pesty/features/home/controller/home_controller.dart';
import 'package:pesty/features/home/views/widget/bottom_nav_bar.dart';
import 'package:pesty/features/home/views/widget/pet_card.dart';
import 'package:pesty/features/home/views/widget/service_grid.dart';
import 'package:sizer/sizer.dart';

class HomeScreen extends GetView<HomeController> {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: Padding(
          padding: EdgeInsets.all(2.w),
          child: CircleAvatar(
            backgroundColor: Colors.grey[200],
            child: Icon(Icons.person, color: Colors.grey[600], size: 5.w),
          ),
        ),
        actions: [
          PopupMenuButton(
            icon: Icon(Icons.menu, color: Colors.black, size: 6.w),
            itemBuilder: (context) => [
              PopupMenuItem(
                child: const Text('Profile', style: TextStyle(fontSize: 16)),
                onTap: () {},
              ),
              PopupMenuItem(
                child: const Text('Settings', style: TextStyle(fontSize: 16)),
                onTap: () {},
              ),
              PopupMenuItem(
                child: const Text('Logout', style: TextStyle(fontSize: 16)),
                onTap: () {
                  Future.delayed(
                    const Duration(seconds: 0),
                    () => controller.logout(),
                  );
                },
              ),
            ],
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // My Pets Section
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'My Pets',
                      style: TextStyle(
                        fontSize: 22, // 18.sp वरून 22.sp केले
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Get.snackbar('Info', 'See all pets coming soon!');
                      },
                      child: Text(
                        'See all',
                        style: TextStyle(
                          fontSize: 14, // 18.sp वरून 14.sp केले (readable)
                          color: Colors.blue,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Pets List
              SizedBox(
                height: 12.h,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: EdgeInsets.symmetric(horizontal: 4.w),
                  itemCount: controller.pets.length + 1,
                  itemBuilder: (context, index) {
                    if (index == controller.pets.length) {
                      return _buildAddPetCard();
                    }
                    return Padding(
                      padding: EdgeInsets.only(right: 4.w),
                      child: PetCard(
                        pet: controller.pets[index],
                        onTap: () {
                          Get.snackbar(
                            'Pet Info',
                            '${controller.pets[index].name} - ${controller.pets[index].breed}',
                          );
                        },
                      ),
                    );
                  },
                ),
              ),

              SizedBox(height: 2.h),

              // Emergency Button
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 4.w),
                child: GestureDetector(
                  onTap: controller.navigateToEmergency,
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(vertical: 2.h),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.red, width: 3),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Center(
                      child: Text(
                        'PET EMERGENCY',
                        style: TextStyle(
                          fontSize: 18, // 16.sp वरून 18.sp केले
                          fontWeight: FontWeight.bold,
                          color: Colors.red,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              SizedBox(height: 3.h),

              // Services Grid
              ServiceGrid(
                services: [
                  ServiceItem(
                    icon: Icons.medical_services,
                    label: 'Vets',
                    color: Colors.teal,
                    onTap: () => controller.navigateToService('Vets'),
                  ),
                  ServiceItem(
                    icon: Icons.accessibility_new,
                    label: 'Care Takers',
                    color: Colors.orange,
                    onTap: () => controller.navigateToService('Care Takers'),
                  ),
                  ServiceItem(
                    icon: Icons.restaurant,
                    label: 'Restaurants',
                    color: Colors.blue,
                    onTap: () => controller.navigateToService('Restaurants'),
                  ),
                  ServiceItem(
                    icon: Icons.hotel,
                    label: 'Hotels',
                    color: Colors.purple,
                    onTap: () => controller.navigateToService('Hotels'),
                  ),
                  ServiceItem(
                    icon: Icons.home,
                    label: 'Shelters',
                    color: Colors.teal,
                    onTap: () => controller.navigateToService('Shelters'),
                  ),
                  ServiceItem(
                    icon: Icons.park,
                    label: 'Parks',
                    color: Colors.green,
                    onTap: () => controller.navigateToService('Parks'),
                  ),
                  ServiceItem(
                    icon: Icons.shopping_bag,
                    label: 'Pet Shop',
                    color: Colors.orange,
                    onTap: () => controller.navigateToService('Pet Shop'),
                  ),
                  ServiceItem(
                    icon: Icons.business,
                    label: 'Business Registration',
                    color: Colors.blue,
                    onTap: () =>
                        controller.navigateToService('Business Registration'),
                  ),
                ],
              ),

              SizedBox(height: 2.h),
            ],
          ),
        );
      }),
      bottomNavigationBar: Obx(
        () => CustomBottomNavBar(
          currentIndex: controller.selectedBottomNavIndex.value,
          onTap: controller.changeBottomNavIndex,
        ),
      ),
    );
  }

  Widget _buildAddPetCard() {
    return GestureDetector(
      onTap: () {
        Get.snackbar(
          'Add Pet',
          'Add new pet feature coming soon!',
          backgroundColor: Colors.orange.withOpacity(0.8),
          colorText: Colors.white,
        );
      },
      child: Column(
        children: [
          Container(
            width: 16.w,
            height: 16.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.orange.withOpacity(0.15),
              border: Border.all(color: Colors.orange, width: 2),
            ),
            child: Icon(Icons.add, size: 8.w, color: Colors.orange),
          ),
          SizedBox(height: 1.h),
          Text(
            'None',
            style: TextStyle(
              fontSize: 13, // 10.sp वरून 12.sp केले
              fontWeight: FontWeight.w600,
              color: Colors.black54,
            ),
          ),
        ],
      ),
    );
  }
}
