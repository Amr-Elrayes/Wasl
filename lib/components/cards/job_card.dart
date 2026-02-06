import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:wasl/core/job/models/job_model.dart';
import 'package:wasl/core/utils/colors.dart';
import 'package:wasl/core/utils/text_styles.dart';

class JobCard extends StatelessWidget {
  const JobCard({super.key, required this.job, required this.onTap});
  final JobModel job;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
            color: AppColors.primaryColor,
            borderRadius: BorderRadius.circular(10)),
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              job.title!,
              style: TextStyles.textSize18.copyWith(color: Colors.white),
            ),
            const Gap(10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(job.company!,
                    style: TextStyles.textSize15
                        .copyWith(color: AppColors.softgrayColor)),
                Text(
                  '${job.applications?.length} Applications',
                  style: TextStyles.textSize15
                      .copyWith(color: AppColors.softgrayColor),
                )
              ],
            ),
            const Gap(10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(job.description!,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyles.textSize15
                        .copyWith(color: AppColors.softgrayColor)),
                Text(
                  job.status,
                  style: TextStyles.textSize15.copyWith(
                      color:
                          job.status == "Active" ? Colors.green : Colors.red),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
