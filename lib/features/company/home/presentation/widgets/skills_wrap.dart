import 'package:flutter/material.dart';
import 'package:wasl/core/job/models/job_model.dart';
import 'package:wasl/core/utils/colors.dart';
import 'package:wasl/core/utils/text_styles.dart';

class SkillsWrap extends StatelessWidget {
  final JobModel job;

  const SkillsWrap({super.key, required this.job});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: (job.reqSkills ?? [])
          .map(
            (skill) => Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 6,
              ),
              decoration: BoxDecoration(
                  color: AppColors.bgColor,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AppColors.primaryColor)),
              child: Text(
                skill.name,
                style: TextStyles.textSize15
                    .copyWith(color: AppColors.darkColor, fontSize: 13),
              ),
            ),
          )
          .toList(),
    );
  }
}
