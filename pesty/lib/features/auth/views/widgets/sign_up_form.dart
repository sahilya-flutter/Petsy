import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/auth_controller.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../app/theme/app_colors.dart';

class SignUpForm extends StatelessWidget {
  final AuthController controller;

  const SignUpForm({Key? key, required this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomTextField(
          controller: controller.fullNameController,
          hintText: 'Full Name',
          prefixIcon: const Icon(Icons.person_outline, color: Colors.grey),
        ),
        const SizedBox(height: 20),
        CustomTextField(
          controller: controller.emailController,
          hintText: 'E-mail',
          keyboardType: TextInputType.emailAddress,
          prefixIcon: const Icon(Icons.email_outlined, color: Colors.grey),
        ),
        const SizedBox(height: 20),
        Obx(
          () => CustomTextField(
            controller: controller.passwordController,
            hintText: 'Password',
            obscureText: !controller.showPassword.value,
            prefixIcon: const Icon(Icons.lock_outline, color: Colors.grey),
            suffixIcon: IconButton(
              icon: Icon(
                controller.showPassword.value
                    ? Icons.visibility
                    : Icons.visibility_off,
                color: Colors.grey,
              ),
              onPressed: () {
                controller.showPassword.value = !controller.showPassword.value;
              },
            ),
          ),
        ),
        const SizedBox(height: 20),
        Obx(
          () => CustomTextField(
            controller: controller.confirmPasswordController,
            hintText: 'Re-type Password',
            obscureText: !controller.showConfirmPassword.value,
            prefixIcon: const Icon(Icons.lock_outline, color: Colors.grey),
            suffixIcon: IconButton(
              icon: Icon(
                controller.showConfirmPassword.value
                    ? Icons.visibility
                    : Icons.visibility_off,
                color: Colors.grey,
              ),
              onPressed: () {
                controller.showConfirmPassword.value =
                    !controller.showConfirmPassword.value;
              },
            ),
          ),
        ),
        const SizedBox(height: 20),
        CustomTextField(
          controller: controller.phoneController,
          hintText: 'Phone Number',
          keyboardType: TextInputType.phone,
          prefixIcon: const Padding(
            padding: EdgeInsets.only(left: 15, top: 14),
            child: Text(
              '+91',
              style: TextStyle(fontSize: 16, color: Colors.black),
            ),
          ),
        ),
        const SizedBox(height: 30),
        Obx(
          () => CustomButton(
            text: 'Next',
            isLoading: controller.isLoading.value,
            onPressed: controller.signUp,
            backgroundColor: AppColors.secondary,
          ),
        ),
      ],
    );
  }
}
