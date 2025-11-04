import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

class ScannerScreen extends StatelessWidget {
  const ScannerScreen({Key? key}) : super(key: key);

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
                    // Scanner Title
                    Text(
                      'Scanner',
                      style: TextStyle(
                        fontSize: 24.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),

                    SizedBox(height: 4.h),

                    // NFC Icon
                    Center(
                      child: Container(
                        width: 150,
                        height: 150,
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Icon(Icons.nfc, size: 100, color: Colors.black),
                      ),
                    ),

                    SizedBox(height: 3.h),

                    // Description Text
                    Center(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 6.w),
                        child: Text(
                          'Discover your pet or lost pet easily by scanning their microchips with Petsy.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 13.sp,
                            color: Colors.grey[700],
                            height: 1.5,
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: 4.h),

                    // Loading/Placeholder bars
                    Center(
                      child: Column(
                        children: [
                          Container(
                            width: 80.w,
                            height: 8,
                            decoration: BoxDecoration(
                              color: Colors.grey[300],
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          SizedBox(height: 1.h),
                          Container(
                            width: 60.w,
                            height: 8,
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 3.h),

                    // Info Text
                    Center(
                      child: Text(
                        'Easily discover when the microchip\nwas implanted',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 11.sp,
                          color: Colors.grey[400],
                        ),
                      ),
                    ),

                    SizedBox(height: 4.h),

                    // Scan Now Button
                    SizedBox(
                      width: double.infinity,
                      height: 6.h,
                      child: ElevatedButton(
                        onPressed: () {
                          Get.snackbar(
                            'Scanner',
                            'NFC Scanner येणार लवकरच!',
                            snackPosition: SnackPosition.BOTTOM,
                            backgroundColor: Color(0xFF00BFA6),
                            colorText: Colors.white,
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF00BFA6),
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(100),
                          ),
                        ),
                        child: Text(
                          'Scan Now',
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: 2.h),

                    // Scan History Button
                    SizedBox(
                      width: double.infinity,
                      height: 6.h,
                      child: OutlinedButton(
                        onPressed: () {
                          Get.snackbar(
                            'Scan History',
                            'Scan history येणार लवकरच!',
                            snackPosition: SnackPosition.BOTTOM,
                          );
                        },
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(color: Color(0xFF00BFA6), width: 2),
                          foregroundColor: Color(0xFF00BFA6),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(100),
                          ),
                        ),
                        child: Text(
                          'Scan History',
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: 3.h),
                  ],
                ),
              ),
            ),

            // Bottom Navigation
            // _buildBottomNav(3),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomNav(int activeIndex) {
    return Container(
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
          _buildNavItem(Icons.home, 0, activeIndex, '/home'),
          _buildNavItem(Icons.forum, 1, activeIndex, '/forum'),
          _buildNavItem(Icons.favorite, 2, activeIndex, '/care'),
          _buildNavItem(Icons.qr_code_scanner, 3, activeIndex, '/scanner'),
          _buildNavItem(Icons.chat, 4, activeIndex, '/chat'),
        ],
      ),
    );
  }

  Widget _buildNavItem(
    IconData icon,
    int index,
    int activeIndex,
    String route,
  ) {
    bool isActive = index == activeIndex;
    return InkWell(
      onTap: () => Get.toNamed(route),
      child: Container(
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isActive
              ? Color(0xFF00BFA6).withOpacity(0.1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(
          icon,
          color: isActive ? Color(0xFF00BFA6) : Colors.grey,
          size: 28,
        ),
      ),
    );
  }
}
