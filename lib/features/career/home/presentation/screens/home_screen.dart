import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:wasl/components/cards/detail_container.dart';
import 'package:wasl/components/inputs/search_field.dart';
import 'package:wasl/core/constants/Industries.dart';
import 'package:wasl/core/routes/navigation.dart';
import 'package:wasl/core/routes/routes.dart';
import 'package:wasl/core/utils/colors.dart';
import 'package:wasl/core/utils/text_styles.dart';
import 'package:wasl/features/career/home/presentation/widgets/info_row.dart';
import 'package:wasl/features/career/home/presentation/widgets/jobs_in_industry.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController controller = TextEditingController();
    final List<String> industries = industryJobTitles.keys.toList();
    return Scaffold(
        body: Padding(
      padding: const EdgeInsets.only(left: 20, right: 20, top: 50),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const InfoRow(),
            const Gap(40),
            GestureDetector(
              onTap: () {},
              child: Searchfield(
                controller: controller,
                isIdel: true,
              ),
            ),
            const Gap(40),
            Text(
              "Industries",
              style: TextStyles.textSize18.copyWith(
                  color: AppColors.darkColor, fontWeight: FontWeight.bold),
            ),
            const Gap(20),
            SizedBox(
              height: 170, // مهم جدًا عشان ListView الأفقي
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: industries.length,
                separatorBuilder: (_, __) => const SizedBox(width: 12),
                itemBuilder: (context, index) {
                  final field = industries[index];
                  final jobsCount = industryJobTitles[field]!.length;

                  return SizedBox(
                    width: 220,
                    child: DetailContainer(
                      title: field,
                      value: jobsCount.toString(), // عدد الوظايف
                      onTap: () {
                        // لو حابب تفتح صفحة بالـ field ده
                        pushTo(context, Routes.indusrty, extra: field);
                      },
                    ),
                  );
                },
              ),
            ),
            const Gap(50),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Jobs With Same Title",
                  style: TextStyles.textSize15.copyWith(
                      color: AppColors.darkColor, fontWeight: FontWeight.bold),
                ),
                TextButton(
                    onPressed: () {
                      pushTo(context, Routes.allItems,
                          extra: "Jobs With Same Title");
                    },
                    child: Text(
                      "See All",
                      style: TextStyles.textSize15.copyWith(
                          color: AppColors.primaryColor,
                          fontWeight: FontWeight.bold),
                    )),
              ],
            ),
            const JobsInIndustry()
          ],
        ),
      ),
    ));
  }
}
