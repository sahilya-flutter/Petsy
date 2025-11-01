import 'package:flutter/material.dart';
import '../../../../core/constants/app_constants.dart';

class AuthHeader extends StatelessWidget {
  const AuthHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 60,
          height: 60,
          decoration: const BoxDecoration(
            color: Colors.orange,
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.pets, color: Colors.white, size: 35),
        ),
        const SizedBox(width: 12),
        const Text(
          AppConstants.appName,
          style: TextStyle(
            fontSize: 40,
            fontWeight: FontWeight.bold,
            color: Colors.teal,
            fontFamily: 'Cursive',
          ),
        ),
      ],
    );
  }
}
