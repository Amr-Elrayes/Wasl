import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:wasl/core/constants/app_images.dart';
import 'package:wasl/core/routes/navigation.dart';
import 'package:wasl/core/routes/routes.dart';
import 'package:wasl/core/utils/colors.dart';
import 'package:wasl/services/local/shered_pref.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  // @override
  void initState() {
    //   bool seen = SharedPref.isOnboardingSeen();
    //   User? user = FirebaseAuth.instance.currentUser;
    Future.delayed(Duration(seconds: 3), () {
      pushReplacment(context, Routes.BuilderCompleteProfileScreen);
    });
    //     if (user != null) {
    //       if (user.photoURL == "doctor") {
    //         pushReplacment(context, Routes.doctor_main);
    //       } else {
    //         pushReplacment(context, Routes.patent_main);
    //       }
    //     } else {
    //       if (seen) {
    //         pushReplacment(context, Routes.welcome);
    //       } else {
    //         pushReplacment(context, Routes.onboarding);
    //       }
    //     }
    //   });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(AppImages.logo, width: 500),
          ],
        ),
      ),
    );
  }
}
