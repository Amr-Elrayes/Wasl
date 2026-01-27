import 'package:flutter/material.dart';
import 'package:wasl/core/routes/navigation.dart';
import 'package:wasl/core/routes/routes.dart';
import 'package:wasl/core/utils/colors.dart';
import 'package:wasl/core/utils/text_styles.dart';
import 'package:wasl/features/auth/models/career_builder_model.dart';

class EmplpyeeCard extends StatelessWidget {
  const EmplpyeeCard(
      {super.key, required this.employee, this.isClickable = true});

  final CareerBuilderModel employee;
  final bool isClickable;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 10, right: 10, top: 0),
      width: double.infinity,
      height: 70,
      decoration: BoxDecoration(
        color: AppColors.softgrayColor,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            offset: const Offset(-3, 0),
            blurRadius: 15,
            color: Colors.grey.withOpacity(.1),
          ),
        ],
      ),
      child: InkWell(
        onTap: () {
          if (isClickable) {
            pushTo(context, Routes.BprofileScreen, extra: employee);
          }
        },
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(13)),
              child: Container(
                height: 55,
                width: 55,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: Colors.white,
                ),
                child: Image.network(
                  employee.image ?? '',
                  height: 50,
                  width: 50,
                  fit: BoxFit.contain,
                ),
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    employee.name ?? '',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyles.textSize18,
                  ),
                  Text(employee.jobTitle ?? '', style: TextStyles.textSize15),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
