// // Splash screen
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:sizer/sizer.dart';
// import '../controllers/auth_controller.dart';

// class SplashScreen extends StatefulWidget {
//   @override
//   _SplashScreenState createState() => _SplashScreenState();
// }

// class _SplashScreenState extends State<SplashScreen> {
//   final AuthController authController = Get.find();

//   @override
//   void initState() {
//     super.initState();
//     _navigateToNext();
//   }

//   void _navigateToNext() async {
//     await Future.delayed(Duration(seconds: 2));

//     if (authController.currentUser.value != null) {
//       Get.offAllNamed('/home');
//     } else {
//       Get.offAllNamed('/signin');
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Container(
//         decoration: BoxDecoration(
//           gradient: LinearGradient(
//             begin: Alignment.topLeft,
//             end: Alignment.bottomRight,
//             colors: [Color(0xFFFFFFFF), Color(0xFFFFFFFF)],
//           ),
//         ),
//         child: Center(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               // Icon(Icons.pets, size: 80.sp, color: Colors.white),
//               Image.asset(
//                 'assets/images/logo_splash.png',
//                 width: 200.sp,
//                 height: 200.sp,
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import '../controllers/auth_controller.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkAuthStatus();
  }

  Future<void> _checkAuthStatus() async {
    final AuthController authController = Get.find();

    // 2 seconds splash screen
    await Future.delayed(Duration(seconds: 2));

    // Check if user logged in ahe
    if (authController.firebaseUser.value != null) {
      // User logged in ahe
      String uid = authController.firebaseUser.value!.uid;
      await authController.loadUserData(uid);
      Get.offAllNamed('/home');
    } else {
      // User logged out ahe
      Get.offAllNamed('/signin');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Tumcha logo
            Image.asset(
              'assets/images/logo_splash.png',
              width: 40.w,
              height: 40.w,
            ),
            SizedBox(height: 4.h),

            // Loading indicator
            CircularProgressIndicator(color: Color(0xFFFF9800), strokeWidth: 3),

            SizedBox(height: 2.h),

            Text(
              'Loading...',
              style: TextStyle(fontSize: 12.sp, color: Colors.grey[600]),
            ),
          ],
        ),
      ),
    );
  }
}
