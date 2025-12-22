import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:wasl/components/buttons/custom_buttom.dart';
import 'package:wasl/core/routes/navigation.dart';
import 'package:wasl/core/routes/routes.dart';
import 'package:wasl/core/utils/colors.dart';
import 'package:wasl/core/utils/text_styles.dart';
import 'package:wasl/features/intro/onboarding/model/onboarding_model.dart';
import 'package:wasl/services/local/shered_pref.dart';

// ignore: must_be_immutable
class OnboardingScreen extends StatefulWidget {
  OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  var pageController = PageController();

  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          if (currentIndex != OnBoardingModel.onBoardingScreens.length - 1)
            TextButton(
              onPressed: () {
                SharedPref.setOnboardingSeen();
                pushAndRemoveUntil(context, Routes.welcome);
              },
              child: Text(
                "Skip",
                style: TextStyles.textSize18.copyWith(
                    color: AppColors.primaryColor, fontWeight: FontWeight.bold),
              ),
            ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                onPageChanged: (index) {
                  setState(() {
                    currentIndex = index;
                  });
                },
                controller: pageController,
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      Spacer(),
                      Image.asset(
                        OnBoardingModel.onBoardingScreens[index].image,
                        width: MediaQuery.sizeOf(context).width * 0.8,
                      ),
                      Spacer(),
                      Text(
                        OnBoardingModel.onBoardingScreens[index].title,
                        style: TextStyles.textSize24.copyWith(
                          color: AppColors.primaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Gap(10),
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: Text(
                          OnBoardingModel.onBoardingScreens[index].subtitle,
                          style: TextStyles.textSize18.copyWith(
                            color: AppColors.darkColor,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Spacer(flex: 3),
                    ],
                  );
                },
                itemCount: OnBoardingModel.onBoardingScreens.length,
              ),
            ),
            Container(
              height: 75,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  DotsIndicator(
                    dotsCount: OnBoardingModel.onBoardingScreens.length,
                    position: currentIndex.toDouble(),
                    decorator: DotsDecorator(
                      size: const Size.square(10.0),
                      activeSize: const Size(20.0, 10.0),
                      activeShape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      color: AppColors.grayColor,
                      activeColor: AppColors.primaryColor,
                    ),
                  ),
                  if (currentIndex ==
                      OnBoardingModel.onBoardingScreens.length - 1)
                    customButtom(
                      width: 180,
                      txt: "Get Started",
                      onPressed: () {
                        SharedPref.setOnboardingSeen();
                        pushAndRemoveUntil(context, Routes.welcome);
                      },
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
