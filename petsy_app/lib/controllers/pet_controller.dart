// Pet CRUD operations
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../database/db_helper.dart';
import 'auth_controller.dart';

class PetController extends GetxController {
  final AuthController authController = Get.find();
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  RxList<Map<String, dynamic>> pets = <Map<String, dynamic>>[].obs;
  RxBool isLoading = false.obs;

  Future<void> loadPets() async {
    try {
      isLoading.value = true;
      final userId = authController.firebaseUser.value?.uid;
      if (userId != null) {
        final petsList = await _dbHelper.getPets(userId);
        pets.value = petsList;
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to load pets: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> addPet({
    required String name,
    required String species,
    required String breed,
    required String gender,
    required String birthday,
  }) async {
    try {
      isLoading.value = true;
      final userId = authController.firebaseUser.value?.uid;

      if (userId != null) {
        await _dbHelper.insertPet({
          'userId': userId,
          'name': name,
          'species': species,
          'breed': breed,
          'gender': gender,
          'birthday': birthday,
          'createdAt': DateTime.now().toIso8601String(),
        });

        Get.snackbar(
          'Success',
          'Pet added successfully!',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Get.theme.primaryColor,
          colorText: Colors.white,
        );

        await loadPets();
        Get.back();
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to add pet: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> deletePet(int petId) async {
    try {
      await _dbHelper.deletePet(petId);
      Get.snackbar(
        'Success',
        'Pet deleted successfully',
        snackPosition: SnackPosition.BOTTOM,
      );
      await loadPets();
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to delete pet: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }
}
