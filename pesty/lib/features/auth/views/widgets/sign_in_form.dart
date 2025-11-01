import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/auth_controller.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/social_login_button.dart';
import '../../../../app/routes/app_routes.dart';

class SignInForm extends StatelessWidget {
  final AuthController controller;

  const SignInForm({Key? key, required this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomTextField(
          controller: controller.emailController,
          hintText: 'name@example.com',
          labelText: 'E-mail',
          keyboardType: TextInputType.emailAddress,
        ),
        const SizedBox(height: 20),
        Obx(
          () => CustomTextField(
            controller: controller.passwordController,
            labelText: 'Password',
            obscureText: !controller.showPassword.value,
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
        const SizedBox(height: 30),
        Obx(
          () => CustomButton(
            text: 'Sign In',
            isLoading: controller.isLoading.value,
            onPressed: controller.signIn,
          ),
        ),
        const SizedBox(height: 30),
        const Text(
          'or use one of your social profiles',
          style: TextStyle(color: Colors.grey, fontSize: 14),
        ),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SocialLoginButton(
              icon: Icons.g_mobiledata,
              color: Colors.red,
              onTap: controller.signInWithGoogle,
            ),
            const SizedBox(width: 20),
            SocialLoginButton(
              icon: Icons.facebook,
              color: Colors.blue.shade700,
              onTap: () {},
            ),
            const SizedBox(width: 20),
            SocialLoginButton(
              icon: Icons.apple,
              color: Colors.black,
              onTap: () {},
            ),
          ],
        ),
        const SizedBox(height: 20),
        TextButton(
          onPressed: () => Get.toNamed(AppRoutes.FORGOT_PASSWORD),
          child: const Text(
            'Forgot Password?',
            style: TextStyle(color: Colors.blue, fontSize: 14),
          ),
        ),
      ],
    );
  }
}
