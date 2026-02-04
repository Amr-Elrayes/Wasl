import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
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

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), _decideRoute);
  }

  Future<void> _decideRoute() async {
    final bool seen = SharedPref.isOnboardingSeen();
    final User? user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      pushReplacment(
        context,
        seen ? Routes.welcome : Routes.onboarding,
      );
      return;
    }

    final bool isCompany = user.photoURL == "Company";
    final String collection = isCompany ? "Company" : "Career";

    final doc = await FirebaseFirestore.instance
        .collection(collection)
        .doc(user.uid)
        .get();

    final data = doc.data();

    if (data == null || data['isProfileCompleted'] != true) {
      pushReplacment(
        context,
        isCompany
            ? Routes.CompanyCompleteProfileScreen
            : Routes.BuilderCompleteProfileScreen,
      );
    } 
    else {
      pushReplacment(
        context,
        isCompany ? Routes.Cmain : Routes.Bmain,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      body: Center(
        child: Image.asset(AppImages.logo, width: 500),
      ),
    );
  }
}
