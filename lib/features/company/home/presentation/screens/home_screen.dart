import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:wasl/core/routes/navigation.dart';
import 'package:wasl/core/routes/routes.dart';
import 'package:wasl/core/utils/colors.dart';
import 'package:wasl/features/company/home/presentation/widgets/details_grid_view.dart';
import 'package:wasl/core/utils/text_styles.dart';
import 'package:wasl/features/company/home/presentation/widgets/employees_in_industry.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key, required this.onTotalApplicationsTap});
  final VoidCallback onTotalApplicationsTap;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(left: 20, right: 20, top: 50),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DetailsGridView(
                onTotalApplicationsTap: onTotalApplicationsTap,
              ),
              const Gap(50),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Employees In The Same Industry",
                    style: TextStyles.textSize15.copyWith(
                        color: AppColors.darkColor,
                        fontWeight: FontWeight.bold),
                  ),
                  TextButton(
                      onPressed: () {
                        pushTo(context, Routes.allItems,
                            extra: "Employees In The Same Industry");
                      },
                      child: Text(
                        "See All",
                        style: TextStyles.textSize15.copyWith(
                            color: AppColors.primaryColor,
                            fontWeight: FontWeight.bold),
                      )),
                ],
              ),
              const employeesInIndustry()
            ],
          ),
        ),
      ),
    );
  }
}
