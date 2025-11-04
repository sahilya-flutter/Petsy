import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

class CareScreen extends StatefulWidget {
  const CareScreen({Key? key}) : super(key: key);

  @override
  State<CareScreen> createState() => _CareScreenState();
}

class _CareScreenState extends State<CareScreen> {
  DateTime selectedDate = DateTime.now();
  int selectedDay = DateTime.now().day;

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
                    // Care Title
                    Text(
                      'Care',
                      style: TextStyle(
                        fontSize: 24.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),

                    SizedBox(height: 2.h),

                    // Calendar Widget
                    Container(
                      decoration: BoxDecoration(
                        color: Color(0xFF00BCD4),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding: EdgeInsets.all(16),
                      child: Column(
                        children: [
                          // Month Selector
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              IconButton(
                                icon: Icon(
                                  Icons.chevron_left,
                                  color: Colors.white,
                                ),
                                onPressed: () {
                                  setState(() {
                                    selectedDate = DateTime(
                                      selectedDate.year,
                                      selectedDate.month - 1,
                                    );
                                  });
                                },
                              ),
                              Text(
                                _getMonthName(selectedDate.month),
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              IconButton(
                                icon: Icon(
                                  Icons.chevron_right,
                                  color: Colors.white,
                                ),
                                onPressed: () {
                                  setState(() {
                                    selectedDate = DateTime(
                                      selectedDate.year,
                                      selectedDate.month + 1,
                                    );
                                  });
                                },
                              ),
                            ],
                          ),

                          SizedBox(height: 1.h),

                          // Weekdays
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: ['S', 'M', 'T', 'W', 'T', 'F', 'S']
                                .map(
                                  (day) => SizedBox(
                                    width: 40,
                                    child: Text(
                                      day,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: Colors.white70,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 11.sp,
                                      ),
                                    ),
                                  ),
                                )
                                .toList(),
                          ),

                          SizedBox(height: 1.h),

                          // Calendar Grid
                          _buildCalendarGrid(),
                        ],
                      ),
                    ),

                    SizedBox(height: 3.h),

                    // Upcoming Appointment
                    Container(
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.orange[50],
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(color: Color(0xFFFF9800), width: 2),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                              color: Color(0xFF00BCD4),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  '15',
                                  style: TextStyle(
                                    fontSize: 20.sp,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                Text(
                                  'Sep',
                                  style: TextStyle(
                                    fontSize: 10.sp,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(width: 3.w),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '11 am - Haircut/grooming for my kitty',
                                  style: TextStyle(
                                    fontSize: 11.sp,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black87,
                                  ),
                                ),
                                Text(
                                  'By George: Care Daily XYZ Saloon',
                                  style: TextStyle(
                                    fontSize: 10.sp,
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Icon(
                            Icons.notifications_active,
                            color: Color(0xFFFF9800),
                            size: 24,
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 3.h),

                    // Book Appointment Button
                    SizedBox(
                      width: double.infinity,
                      height: 6.h,
                      child: ElevatedButton(
                        onPressed: () {
                          Get.toNamed('/appointments');
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF00BCD4),
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(100),
                          ),
                        ),
                        child: Text(
                          'Book an Appointment',
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: 2.h),

                    // Add Reminder Button
                    SizedBox(
                      width: double.infinity,
                      height: 6.h,
                      child: OutlinedButton(
                        onPressed: () {
                          Get.snackbar(
                            'Reminder',
                            'Add reminder येणार लवकरच!',
                            snackPosition: SnackPosition.BOTTOM,
                          );
                        },
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(color: Color(0xFFFF9800), width: 2),
                          foregroundColor: Color(0xFFFF9800),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(100),
                          ),
                        ),
                        child: Text(
                          'Add a reminder for an activity',
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
            _buildBottomNav(2),
          ],
        ),
      ),
    );
  }

  Widget _buildCalendarGrid() {
    // Get first day of month
    DateTime firstDay = DateTime(selectedDate.year, selectedDate.month, 1);
    int daysInMonth = DateTime(
      selectedDate.year,
      selectedDate.month + 1,
      0,
    ).day;
    int startWeekday = firstDay.weekday % 7;

    List<Widget> dayWidgets = [];

    // Empty spaces before first day
    for (int i = 0; i < startWeekday; i++) {
      dayWidgets.add(SizedBox(width: 40, height: 40));
    }

    // Days of month
    for (int day = 1; day <= daysInMonth; day++) {
      bool isToday =
          day == DateTime.now().day &&
          selectedDate.month == DateTime.now().month &&
          selectedDate.year == DateTime.now().year;
      bool isSelected = day == selectedDay;

      dayWidgets.add(
        GestureDetector(
          onTap: () {
            setState(() {
              selectedDay = day;
            });
          },
          child: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: isSelected
                  ? Colors.red
                  : isToday
                  ? Colors.white.withOpacity(0.2)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Text(
                '$day',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: isSelected || isToday
                      ? FontWeight.bold
                      : FontWeight.normal,
                  fontSize: 12.sp,
                ),
              ),
            ),
          ),
        ),
      );
    }

    return GridView.count(
      crossAxisCount: 7,
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      children: dayWidgets,
    );
  }

  String _getMonthName(int month) {
    const months = [
      'JANUARY',
      'FEBRUARY',
      'MARCH',
      'APRIL',
      'MAY',
      'JUNE',
      'JULY',
      'AUGUST',
      'SEPTEMBER',
      'OCTOBER',
      'NOVEMBER',
      'DECEMBER',
    ];
    return months[month - 1];
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
