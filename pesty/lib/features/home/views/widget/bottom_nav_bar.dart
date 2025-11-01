import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class CustomBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const CustomBottomNavBar({
    Key? key,
    required this.currentIndex,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 8.h,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavItem(Icons.home, 0, Colors.orange),
          _buildNavItem(Icons.favorite, 1, Colors.teal),
          _buildNavItem(Icons.document_scanner_outlined, 2, Colors.blue),
          _buildNavItem(Icons.pets, 3, Colors.green),
          _buildNavItem(Icons.qr_code, 4, Colors.red),
        ],
      ),
    );
  }

  Widget _buildNavItem(IconData icon, int index, Color color) {
    final isSelected = currentIndex == index;
    return GestureDetector(
      onTap: () => onTap(index),
      child: Container(
        padding: EdgeInsets.all(2.w),
        decoration: BoxDecoration(
          color: isSelected ? color.withOpacity(0.15) : Colors.transparent,
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: isSelected ? color : Colors.grey, size: 6.w),
      ),
    );
  }
}
