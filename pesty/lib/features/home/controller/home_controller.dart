import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pesty/app/database/database.dart';
import 'package:pesty/data/models/pet_model.dart';
import 'package:pesty/data/repositories/auth_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../app/routes/app_routes.dart';

class HomeController extends GetxController {
  final DatabaseHelper _dbHelper = DatabaseHelper();
  final AuthRepository _authRepository = AuthRepository();

  final RxList<PetModel> pets = <PetModel>[].obs;
  final RxInt selectedBottomNavIndex = 0.obs;
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadPets();
  }

  Future<void> loadPets() async {
    try {
      isLoading.value = true;
      final petsList = await _dbHelper.getPets();
      pets.value = petsList;

      if (pets.isEmpty) {
        await addDemoPet();
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to load pets: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> addDemoPet() async {
    final demoPet = PetModel(
      name: 'Katty',
      type: 'Cat',
      breed: 'Persian',
      age: 2,
    );
    await _dbHelper.insertPet(demoPet);
    await loadPets();
  }

  Future<void> addPet(PetModel pet) async {
    try {
      await _dbHelper.insertPet(pet);
      await loadPets();
      Get.snackbar(
        'Success',
        'Pet added successfully!',
        backgroundColor: Get.theme.primaryColor.withOpacity(0.8),
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to add pet: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  Future<void> logout() async {
    try {
      await _authRepository.signOut();
      Get.offAllNamed(AppRoutes.AUTH);

      await Future.delayed(const Duration(milliseconds: 500));
      Get.snackbar(
        'Success',
        'Logged out successfully',
        backgroundColor: Colors.orange,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Logout failed: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  void changeBottomNavIndex(int index) {
    selectedBottomNavIndex.value = index;
  }

  void navigateToEmergency() {
    Get.snackbar(
      '🚨 Emergency',
      'Emergency service activated!',
      backgroundColor: Colors.red,
      colorText: Colors.white,
      snackPosition: SnackPosition.TOP,
      duration: const Duration(seconds: 2),
    );
  }

  void navigateToService(String service) {
    Get.snackbar(
      'Service',
      'Opening $service...',
      backgroundColor: Get.theme.primaryColor.withOpacity(0.8),
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 2),
    );
  }
}
