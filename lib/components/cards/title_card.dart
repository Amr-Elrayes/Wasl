import 'package:flutter/material.dart';
import 'package:wasl/core/utils/colors.dart';
import 'package:wasl/core/utils/text_styles.dart';

class TitleCard extends StatelessWidget {
  const TitleCard({super.key, required this.title, required this.onTap});
  final String title;
  final void Function() onTap;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        margin: const EdgeInsets.only(bottom: 30),
        decoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: AppColors.primaryColor)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: TextStyles.textSize15.copyWith(
                  color: AppColors.darkColor, fontWeight: FontWeight.bold),
            ),
            const Icon(
              Icons.arrow_forward_ios_rounded,
              color: AppColors.darkColor,
              size: 20,
            )
          ],
        ),
      ),
    );
  }
}
