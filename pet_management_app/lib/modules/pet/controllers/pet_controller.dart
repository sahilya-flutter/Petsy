import 'package:get/get.dart';
import 'package:pet_management_app/app/data/database/database_helper.dart';
import 'package:pet_management_app/app/data/model/pet_model.dart';
import '../../auth/controllers/auth_controller.dart';

class PetController extends GetxController {
  final _db = DatabaseHelper.instance;
  final _authController = Get.find<AuthController>();

  final RxList<PetModel> pets = <PetModel>[].obs;
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadPets();
  }

  Future<void> loadPets() async {
    try {
      isLoading.value = true;
      final userId = _authController.currentUser.value?.id;
      if (userId != null) {
        final petList = await _db.getPetsByUserId(userId);
        pets.value = petList;
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to load pets: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> addPet(PetModel pet) async {
    try {
      isLoading.value = true;
      await _db.createPet(pet);
      await loadPets();
      Get.back();
      Get.snackbar('Success', 'Pet added successfully!');
    } catch (e) {
      Get.snackbar('Error', 'Failed to add pet: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updatePet(PetModel pet) async {
    try {
      isLoading.value = true;
      await _db.updatePet(pet);
      await loadPets();
      Get.snackbar('Success', 'Pet updated successfully!');
    } catch (e) {
      Get.snackbar('Error', 'Failed to update pet: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> deletePet(int id) async {
    try {
      isLoading.value = true;
      await _db.deletePet(id);
      await loadPets();
      Get.snackbar('Success', 'Pet removed successfully!');
    } catch (e) {
      Get.snackbar('Error', 'Failed to delete pet: $e');
    } finally {
      isLoading.value = false;
    }
  }
}
