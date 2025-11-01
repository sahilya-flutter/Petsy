import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class ServiceItem {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  ServiceItem({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });
}

class ServiceGrid extends StatelessWidget {
  final List<ServiceItem> services;

  const ServiceGrid({Key? key, required this.services}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        crossAxisSpacing: 3.w,
        mainAxisSpacing: 2.h,
        childAspectRatio: 0.85,
      ),
      itemCount: services.length,
      itemBuilder: (context, index) {
        final service = services[index];
        return GestureDetector(
          onTap: service.onTap,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 15.w,
                height: 15.w,
                decoration: BoxDecoration(
                  color: service.color.withOpacity(0.15),
                  shape: BoxShape.circle,
                  border: Border.all(color: service.color, width: 2),
                ),
                child: Icon(service.icon, color: service.color, size: 7.w),
              ),
              SizedBox(height: 0.5.h),
              Text(
                service.label,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        );
      },
    );
  }
}
