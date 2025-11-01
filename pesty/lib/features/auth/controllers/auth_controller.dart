import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/repositories/auth_repository.dart';

class AuthController extends GetxController {
  final AuthRepository _authRepository = AuthRepository();

  final isSignIn = true.obs;
  final isLoading = false.obs;
  final showPassword = false.obs;
  final showConfirmPassword = false.obs;

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final fullNameController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final phoneController = TextEditingController();

  void toggleAuthMode() {
    isSignIn.value = !isSignIn.value;
    clearFields();
  }

  void clearFields() {
    emailController.clear();
    passwordController.clear();
    fullNameController.clear();
    confirmPasswordController.clear();
    phoneController.clear();
  }

  Future<void> signIn() async {
    if (emailController.text.isEmpty || passwordController.text.isEmpty) {
      Get.snackbar(
        'Error',
        'Please fill all fields',
        backgroundColor: Colors.red.shade400,
        colorText: Colors.white,
      );
      return;
    }

    try {
      isLoading.value = true;
      await _authRepository.signIn(
        emailController.text.trim(),
        passwordController.text,
      );
      Get.snackbar(
        'Success',
        'Signed in successfully',
        backgroundColor: Colors.green.shade400,
        colorText: Colors.white,
      );
      // Navigate to home screen
      // Get.offAllNamed(AppRoutes.HOME);
    } on FirebaseException catch (e) {
      Get.snackbar(
        'Error',
        e.message ?? 'An error occurred',
        backgroundColor: Colors.red.shade400,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> signUp() async {
    if (fullNameController.text.isEmpty ||
        emailController.text.isEmpty ||
        passwordController.text.isEmpty ||
        confirmPasswordController.text.isEmpty ||
        phoneController.text.isEmpty) {
      Get.snackbar(
        'Error',
        'Please fill all fields',
        backgroundColor: Colors.red.shade400,
        colorText: Colors.white,
      );
      return;
    }

    if (passwordController.text != confirmPasswordController.text) {
      Get.snackbar(
        'Error',
        'Passwords do not match',
        backgroundColor: Colors.red.shade400,
        colorText: Colors.white,
      );
      return;
    }

    try {
      isLoading.value = true;
      await _authRepository.signUp(
        emailController.text.trim(),
        passwordController.text,
      );
      Get.snackbar(
        'Success',
        'Account created successfully',
        backgroundColor: Colors.green.shade400,
        colorText: Colors.white,
      );
      // Navigate to home screen
      // Get.offAllNamed(AppRoutes.HOME);
    } on FirebaseException catch (e) {
      Get.snackbar(
        'Error',
        e.message ?? 'An error occurred',
        backgroundColor: Colors.red.shade400,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> signInWithGoogle() async {
    try {
      isLoading.value = true;
      // await _authRepository.signInWithGoogle();
      Get.snackbar(
        'Success',
        'Signed in with Google',
        backgroundColor: Colors.green.shade400,
        colorText: Colors.white,
      );
    } on FirebaseException catch (e) {
      Get.snackbar(
        'Error',
        e.message ?? 'An error occurred',
        backgroundColor: Colors.red.shade400,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    fullNameController.dispose();
    confirmPasswordController.dispose();
    phoneController.dispose();
    super.onClose();
  }
}
