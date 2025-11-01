// import 'package:firebase_auth/firebase_auth.dart';
// import '../services/firebase_auth_service.dart';
// import '../models/user_model.dart';

// class AuthRepository {
//   final FirebaseAuthService _authService = FirebaseAuthService();

//   User? get currentUser => _authService.currentUser;
//   Stream<User?> get authStateChanges => _authService.authStateChanges;

//   Future<UserModel?> signIn(String email, String password) async {
//     try {
//       final userCredential = await _authService.signInWithEmailAndPassword(
//         email,
//         password,
//       );
//       return _mapFirebaseUserToModel(userCredential.user);
//     } catch (e) {
//       rethrow;
//     }
//   }

//   Future<UserModel?> signUp(String email, String password) async {
//     try {
//       final userCredential = await _authService.signUpWithEmailAndPassword(
//         email,
//         password,
//       );
//       return _mapFirebaseUserToModel(userCredential.user);
//     } catch (e) {
//       rethrow;
//     }
//   }

//   Future<UserModel?> signInWithGoogle() async {
//     try {
//       // final userCredential = await _authService.signInWithGoogle();
//       // return _mapFirebaseUserToModel(userCredential?.user);
//     } catch (e) {
//       rethrow;
//     }
//   }

//   Future<void> signOut() async {
//     await _authService.signOut();
//   }

//   Future<void> resetPassword(String email) async {
//     await _authService.resetPassword(email);
//   }

//   UserModel? _mapFirebaseUserToModel(User? user) {
//     if (user == null) return null;
//     return UserModel(
//       id: user.uid,
//       email: user.email,
//       fullName: user.displayName,
//       photoUrl: user.photoURL,
//     );
//   }
// }
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/firebase_auth_service.dart';
import '../models/user_model.dart';

class AuthRepository {
  final FirebaseAuthService _authService = FirebaseAuthService();

  Future<UserModel?> signIn(String email, String password) async {
    try {
      final userCredential = await _authService.signInWithEmailAndPassword(
        email,
        password,
      );
      await _saveLoginStatus(true);
      return _mapFirebaseUserToModel(userCredential.user);
    } catch (e) {
      rethrow;
    }
  }

  Future<UserModel?> signUp(String email, String password) async {
    try {
      final userCredential = await _authService.signUpWithEmailAndPassword(
        email,
        password,
      );
      await _saveLoginStatus(true);
      return _mapFirebaseUserToModel(userCredential.user);
    } catch (e) {
      rethrow;
    }
  }

  // Future<UserModel?> signInWithGoogle() async {
  //   try {
  //     final userCredential = await _authService.signInWithGoogle();
  //     await _saveLoginStatus(true);
  //     return _mapFirebaseUserToModel(userCredential?.user);
  //   } catch (e) {
  //     rethrow;
  //   }
  // }

  Future<void> signOut() async {
    await _authService.signOut();
    await _saveLoginStatus(false);
  }

  Future<void> _saveLoginStatus(bool status) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', status);
  }

  UserModel? _mapFirebaseUserToModel(User? user) {
    if (user == null) return null;
    return UserModel(
      id: user.uid,
      email: user.email,
      fullName: user.displayName,
      photoUrl: user.photoURL,
    );
  }
}
