import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:wasl/components/buttons/custom_buttom.dart';
import 'package:wasl/core/constants/app_images.dart';
import 'package:wasl/core/routes/navigation.dart';
import 'package:wasl/core/routes/routes.dart';
import 'package:wasl/core/utils/colors.dart';
import 'package:wasl/core/utils/text_styles.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Image.asset(
            AppImages.welcome,
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Spacer(),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Welcome To Jubify ,",
                      style: TextStyles.textSize30.copyWith(
                          color: AppColors.primaryColor,
                          fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "Let’s Start",
                      style: TextStyles.textSize30.copyWith(
                          color: AppColors.primaryColor,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const Spacer(flex: 6),
                customButtom(
                  txt: "Login",
                  onPressed: () {
                    pushAndRemoveUntil(context, Routes.login);
                  },
                ),
                const Gap(15),
                customButtom(
                  txt: "Sign Up",
                  onPressed: () {
                    pushAndRemoveUntil(context, Routes.register);
                  },
                  color: AppColors.bgColor,
                  txtColor: AppColors.primaryColor,
                  borderColor: AppColors.primaryColor,
                ),
                const Spacer(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
