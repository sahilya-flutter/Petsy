import 'package:flutter/material.dart';
import 'package:pesty/data/models/pet_model.dart';
import 'package:sizer/sizer.dart';

class PetCard extends StatelessWidget {
  final PetModel pet;
  final VoidCallback? onTap;

  const PetCard({Key? key, required this.pet, this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 16.w,
            height: 16.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.grey[200],
              border: Border.all(color: Colors.orange, width: 2),
            ),
            child: ClipOval(
              child: pet.imageUrl != null
                  ? Image.network(pet.imageUrl!, fit: BoxFit.cover)
                  : Icon(Icons.pets, size: 8.w, color: Colors.orange),
            ),
          ),
          SizedBox(height: 1.h),
          Text(
            pet.name,
            style: TextStyle(
              fontSize: 10.sp,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}
