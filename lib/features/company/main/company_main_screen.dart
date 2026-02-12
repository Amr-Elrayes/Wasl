import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:wasl/core/constants/app_icons.dart';
import 'package:wasl/core/utils/colors.dart';
import 'package:wasl/features/company/add%20job/presentation/screens/add_job_sreen.dart';
import 'package:wasl/features/company/home/presentation/screens/home_screen.dart';
import 'package:wasl/features/company/profile/presentation/screens/profile_screen.dart';
import 'package:wasl/features/company/requests/presentation/screens/jobs_with_requestes_screen.dart';

class CompanyMainScreen extends StatefulWidget {
  final int initialIndex;
  const CompanyMainScreen({super.key, this.initialIndex = 0});

  @override
  State<CompanyMainScreen> createState() => _CompanyMainScreenState();
}

class _CompanyMainScreenState extends State<CompanyMainScreen> {
  late int currentIndex;



  late List<Widget> screens;

@override
void initState() {
  super.initState();
  currentIndex = widget.initialIndex;

  screens = [
    HomeScreen(
      onTotalApplicationsTap: () {
        setState(() {
          currentIndex = 2; // RequestsScreen
        });
      },
    ),
    const AddJobSreen(),
    const JobsWithRequestesScreen(),
    const ProfileScreen(canEdit: true,),
  ];
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screens[currentIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: BottomNavigationBar(
          currentIndex: currentIndex,
          onTap: (index) {
            setState(() {
              currentIndex = index;
            });
          },
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.transparent,
          elevation: 0,
          selectedItemColor: AppColors.primaryColor,
          unselectedItemColor: AppColors.darkColor,
          items: [
            BottomNavigationBarItem(
              icon: SvgPicture.asset(
                AppIcons.homeSvg,
                colorFilter: ColorFilter.mode(
                  currentIndex == 0
                      ? AppColors.primaryColor
                      : AppColors.darkColor,
                  BlendMode.srcIn,
                ),
              ),
              label: "",
            ),
            BottomNavigationBarItem(
              icon: SvgPicture.asset(
                AppIcons.addSvg,
                colorFilter: ColorFilter.mode(
                  currentIndex == 1
                      ? AppColors.primaryColor
                      : AppColors.darkColor,
                  BlendMode.srcIn,
                ),
              ),
              label: "",
            ),
            BottomNavigationBarItem(
              icon: SvgPicture.asset(
                AppIcons.requestSvg,
                colorFilter: ColorFilter.mode(
                  currentIndex == 2
                      ? AppColors.primaryColor
                      : AppColors.darkColor,
                  BlendMode.srcIn,
                ),
              ),
              label: "",
            ),
            BottomNavigationBarItem(
              icon: SvgPicture.asset(
                AppIcons.profileSvg,
                colorFilter: ColorFilter.mode(
                  currentIndex == 3
                      ? AppColors.primaryColor
                      : AppColors.darkColor,
                  BlendMode.srcIn,
                ),
              ),
              label: "",
            ),
          ],
        ),
      ),
    );
  }
}
