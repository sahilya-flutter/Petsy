import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pet_management_app/modules/widget/custom_button.dart';
import 'package:pet_management_app/modules/widget/custom_textfield.dart';
import 'package:sizer/sizer.dart';
import '../controllers/auth_controller.dart';
import '../../../routes/app_routes.dart';

class SignInScreen extends StatelessWidget {
  SignInScreen({Key? key}) : super(key: key);

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final authController = Get.find<AuthController>();

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 6.w),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(height: 8.h),

                // Logo/Icon
                Image.asset('assets/images/logo.jpeg', height: 20.h),
                SizedBox(height: 2.h),

                // Title
                Text(
                  'Welcome to Petsy',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 24.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.purple,
                  ),
                ),
                SizedBox(height: 1.h),
                Text(
                  'Manage your pet\'s life with ease',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 12.sp, color: Colors.grey[600]),
                ),

                SizedBox(height: 6.h),

                // Email Field
                CustomTextField(
                  controller: _emailController,
                  label: 'Email',
                  prefixIcon: Icons.email_outlined,
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    }
                    if (!GetUtils.isEmail(value)) {
                      return 'Please enter a valid email';
                    }
                    return null;
                  },
                ),

                SizedBox(height: 2.h),

                // Password Field
                CustomTextField(
                  controller: _passwordController,
                  label: 'Password',
                  prefixIcon: Icons.lock_outline,
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your password';
                    }
                    if (value.length < 6) {
                      return 'Password must be at least 6 characters';
                    }
                    return null;
                  },
                ),

                SizedBox(height: 4.h),

                // Sign In Button
                Obx(
                  () => CustomButton(
                    text: 'Sign In',
                    isLoading: authController.isLoading.value,
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        authController.signIn(
                          email: _emailController.text.trim(),
                          password: _passwordController.text,
                        );
                      }
                    },
                  ),
                ),

                SizedBox(height: 2.h),

                // Sign Up Link
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Don\'t have an account? ',
                      style: TextStyle(fontSize: 11.sp),
                    ),
                    GestureDetector(
                      onTap: () => Get.toNamed(AppRoutes.SIGNUP),
                      child: Text(
                        'Sign Up',
                        style: TextStyle(
                          fontSize: 11.sp,
                          color: Colors.purple,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
