import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

class ForumScreen extends StatelessWidget {
  const ForumScreen({Key? key}) : super(key: key);

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
                    // Forum Title
                    Text(
                      'Forum',
                      style: TextStyle(
                        fontSize: 24.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),

                    SizedBox(height: 2.h),

                    // Category Icons
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildCategoryIcon(
                          Icons.chat_bubble,
                          'Discussion',
                          Color(0xFF00BCD4),
                        ),
                        _buildCategoryIcon(
                          Icons.article,
                          'Articles',
                          Color(0xFF00BCD4),
                        ),
                        _buildCategoryIcon(
                          Icons.groups,
                          'Community',
                          Color(0xFF00BCD4),
                        ),
                        _buildAddIcon(),
                      ],
                    ),

                    SizedBox(height: 3.h),

                    // Trending Topic Section
                    Text(
                      'Trending Topic',
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),

                    SizedBox(height: 2.h),

                    // Trending Topics List
                    SizedBox(
                      height: 180,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: [
                          _buildTopicCard(
                            'Training Tips',
                            'How to train your puppy',
                            'assets/images/cat.jpg',
                            Color(0xFF00BCD4),
                          ),
                          SizedBox(width: 3.w),
                          _buildTopicCard(
                            'Health Care',
                            'Pet nutrition guide',
                            'assets/images/cat.jpg',
                            Color(0xFF00BCD4),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 3.h),

                    // Trending News Section
                    Text(
                      'Trending News',
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),

                    SizedBox(height: 2.h),

                    // Trending News List
                    _buildNewsCard(
                      'Pet Adoption Event',
                      'Join us this weekend',
                      'assets/images/cat.jpg',
                      Color(0xFF00BCD4),
                    ),
                    SizedBox(height: 2.h),
                    _buildNewsCard(
                      'New Pet Hospital',
                      'Opening in your area',
                      'assets/images/cat.jpg',
                      Color(0xFF00BCD4),
                    ),

                    SizedBox(height: 3.h),
                  ],
                ),
              ),
            ),

            // Bottom Navigation
            _buildBottomNav(0),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryIcon(IconData icon, String label, Color color) {
    return Column(
      children: [
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: Color(0xFF00BCD4), width: 3),
            color: Colors.white,
          ),
          child: Icon(icon, size: 28, color: color),
        ),
        SizedBox(height: 0.5.h),
        Text(
          label,
          style: TextStyle(fontSize: 10.sp, color: Colors.black87),
        ),
      ],
    );
  }

  Widget _buildAddIcon() {
    return Column(
      children: [
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Color(0xFFFF9800),
          ),
          child: Icon(Icons.add, size: 30, color: Colors.white),
        ),
        SizedBox(height: 0.5.h),
        Text(
          'Create',
          style: TextStyle(fontSize: 10.sp, color: Colors.black87),
        ),
      ],
    );
  }

  Widget _buildTopicCard(
    String title,
    String subtitle,
    String image,
    Color color,
  ) {
    return Container(
      width: 250,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(15),
              bottomLeft: Radius.circular(15),
            ),
            child: Image.asset(
              image,
              width: 100,
              height: 180,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  width: 100,
                  height: 180,
                  color: Colors.grey[300],
                  child: Icon(Icons.pets, size: 40),
                );
              },
            ),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 1.h),
                  Text(
                    subtitle,
                    style: TextStyle(fontSize: 11.sp, color: Colors.white70),
                    maxLines: 3,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNewsCard(
    String title,
    String subtitle,
    String image,
    Color color,
  ) {
    return Container(
      height: 120,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(15),
              bottomLeft: Radius.circular(15),
            ),
            child: Image.asset(
              image,
              width: 120,
              height: 120,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  width: 120,
                  height: 120,
                  color: Colors.grey[300],
                  child: Icon(Icons.pets, size: 40),
                );
              },
            ),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 0.5.h),
                  Text(
                    subtitle,
                    style: TextStyle(fontSize: 11.sp, color: Colors.white70),
                  ),
                ],
              ),
            ),
          ),
        ],
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
