import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Top Bar
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CircleAvatar(
                    radius: 20,
                    backgroundColor: Colors.grey[300],
                    child: Icon(Icons.person, color: Colors.grey[600]),
                  ),
                  IconButton(
                    icon: Icon(Icons.menu, size: 28),
                    onPressed: () {},
                  ),
                ],
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 4.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // My Pets Section
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'My Pets',
                          style: TextStyle(
                            fontSize: 20.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        TextButton(
                          onPressed: () {},
                          child: Text(
                            'Show all',
                            style: TextStyle(
                              fontSize: 12.sp,
                              color: Color(0xFF00BCD4),
                            ),
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 2.h),

                    // Pets Horizontal List
                    SizedBox(
                      height: 110,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: [
                          _buildPetCard(
                            'Katty',
                            'assets/images/th.jpg', // Replace with your image
                            isActive: true,
                          ),
                          SizedBox(width: 3.w),
                          _buildPetCard('Name', null, isPlaceholder: true),
                          SizedBox(width: 3.w),
                          _buildAddPetButton(),
                        ],
                      ),
                    ),

                    Container(width: 100.w, color: Colors.black, height: 2),
                    SizedBox(height: 3.h),
                    // Pet Emergency Button
                    Center(
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 8.w,
                          vertical: 1.5.h,
                        ),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.red, width: 3),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Text(
                          'PET EMERGENCY',
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.red,
                            letterSpacing: 1,
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: 3.h),

                    // First Row of Services
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildServiceIcon(
                          Icons.medical_services,
                          'Vets',
                          Color(0xFF00BCD4),
                        ),
                        _buildServiceIcon(
                          Icons.pets,
                          'Care Takers',
                          Color(0xFF00BCD4),
                        ),
                        _buildServiceIcon(
                          Icons.restaurant,
                          'Restaurants',
                          Color(0xFF00BCD4),
                        ),
                        _buildServiceIcon(
                          Icons.hotel,
                          'Hotels',
                          Color(0xFF00BCD4),
                        ),
                      ],
                    ),

                    SizedBox(height: 3.h),

                    // Second Row of Services
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildServiceIcon(
                          Icons.home,
                          'Shelters',
                          Color(0xFF00BCD4),
                        ),
                        _buildServiceIcon(
                          Icons.park,
                          'Parks',
                          Color(0xFF00BCD4),
                        ),
                        _buildServiceIcon(
                          Icons.store,
                          'Pet Shop',
                          Color(0xFF00BCD4),
                        ),
                        _buildServiceIcon(
                          Icons.business,
                          'Business\nRegistration',
                          Color(0xFF00BCD4),
                        ),
                      ],
                    ),

                    SizedBox(height: 3.h),
                  ],
                ),
              ),
            ),

            // Bottom Navigation Bar
            Container(
              height: 70,
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 10,
                    offset: Offset(0, -2),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildBottomNavItem(Icons.home, Color(0xFFFF9800), true, 0),
                  _buildBottomNavItem(
                    Icons.favorite,
                    Color(0xFF00BCD4),
                    false,
                    1,
                  ),
                  _buildBottomNavItem(
                    Icons.location_on,
                    Color(0xFF00BCD4),
                    false,
                    2,
                  ),
                  _buildBottomNavItem(Icons.group, Color(0xFF00BCD4), false, 3),
                  _buildBottomNavItem(
                    Icons.qr_code,
                    Color(0xFF00BCD4),
                    false,
                    4,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPetCard(
    String name,
    String? imagePath, {
    bool isActive = false,
    bool isPlaceholder = false,
  }) {
    return Column(
      children: [
        Container(
          width: 70,
          height: 70,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: isActive ? Color(0xFF00BCD4) : Colors.transparent,
              width: 3,
            ),
            color: isPlaceholder ? Colors.grey[300] : Colors.white,
          ),
          child: ClipOval(
            child: isPlaceholder
                ? Icon(Icons.pets, size: 35, color: Colors.grey[500])
                : imagePath != null
                ? Image.asset(imagePath, fit: BoxFit.cover)
                : Icon(Icons.pets, size: 35, color: Colors.grey[500]),
          ),
        ),
        SizedBox(height: 0.5.h),
        Text(
          name,
          style: TextStyle(
            fontSize: 12.sp,
            fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
            color: isPlaceholder ? Colors.grey : Colors.black,
          ),
        ),
      ],
    );
  }

  Widget _buildAddPetButton() {
    return Center(
      child: Column(
        children: [
          Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Color(0xFFFF9800),
            ),
            child: Icon(Icons.add, size: 35, color: Colors.white),
          ),
          SizedBox(height: 0.5.h),
          Text('', style: TextStyle(fontSize: 12.sp)),
        ],
      ),
    );
  }

  Widget _buildServiceIcon(IconData icon, String label, Color color) {
    return Column(
      children: [
        Container(
          width: 65,
          height: 65,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: Color(0xFFFF9800), width: 3),
          ),
          child: Icon(icon, size: 30, color: color),
        ),
        SizedBox(height: 0.8.h),
        SizedBox(
          width: 70,
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 10.sp, color: Colors.black87),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildBottomNavItem(
    IconData icon,
    Color color,
    bool isActive,
    int activeIndex,
  ) {
    return InkWell(
      onTap: () {
        switch (activeIndex) {
          case 0:
            Get.toNamed('/home');
            break;
          case 1:
            Get.toNamed('/appointments');
            break;
          case 2:
            Get.toNamed('/agenda');
            break;
          case 3:
            Get.toNamed('/add-pet');
            break;
          case 4:
            Get.toNamed('/scanner'); // example QR page replace kar
            break;
        }
      },
      child: Container(
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isActive ? color.withOpacity(0.1) : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon, color: color, size: 28),
      ),
    );
  }
}
