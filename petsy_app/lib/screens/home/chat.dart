import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({Key? key}) : super(key: key);

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
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.chat_bubble_outline,
                      size: 100,
                      color: Color(0xFF00BCD4),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      'Community Chat',
                      style: TextStyle(
                        fontSize: 24.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: 1.h),
                    Text(
                      'Coming Soon!',
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Bottom Navigation
            _buildBottomNav(4),
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
              ? Color(0xFF00BCD4).withOpacity(0.1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(
          icon,
          color: isActive ? Color(0xFF00BCD4) : Colors.grey,
          size: 28,
        ),
      ),
    );
  }
}
