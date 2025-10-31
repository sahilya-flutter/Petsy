import 'package:get/get.dart';
import 'package:pet_management_app/app/data/database/database_helper.dart';
import 'package:pet_management_app/app/data/model/user_model.dart';
import '../../../routes/app_routes.dart';

class AuthController extends GetxController {
  final _db = DatabaseHelper.instance;

  final Rx<UserModel?> currentUser = Rx<UserModel?>(null);
  final RxBool isLoading = false.obs;

  Future<void> signUp({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      isLoading.value = true;

      // Check if user already exists
      final existingUser = await _db.getUserByEmail(email);
      if (existingUser != null) {
        Get.snackbar('Error', 'Email already registered');
        return;
      }

      final user = UserModel(name: name, email: email, password: password);

      final id = await _db.createUser(user);
      currentUser.value = user.copyWith(id: id);

      Get.offAllNamed(AppRoutes.HOME);
      Get.snackbar('Success', 'Account created successfully!');
    } catch (e) {
      Get.snackbar('Error', 'Sign up failed: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> signIn({required String email, required String password}) async {
    try {
      isLoading.value = true;

      final user = await _db.getUserByEmail(email);

      if (user == null) {
        Get.snackbar('Error', 'User not found');
        return;
      }

      if (user.password != password) {
        Get.snackbar('Error', 'Invalid password');
        return;
      }

      currentUser.value = user;
      Get.offAllNamed(AppRoutes.HOME);
      Get.snackbar('Success', 'Welcome back, ${user.name}!');
    } catch (e) {
      Get.snackbar('Error', 'Sign in failed: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void signOut() {
    currentUser.value = null;
    Get.offAllNamed(AppRoutes.SIGNIN);
  }
}

extension on UserModel {
  UserModel copyWith({int? id}) {
    return UserModel(
      id: id ?? this.id,
      name: name,
      email: email,
      password: password,
      createdAt: createdAt,
    );
  }
}
