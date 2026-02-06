import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:wasl/core/utils/colors.dart';
import 'package:wasl/core/utils/text_styles.dart';

class DetailContainer extends StatelessWidget {
  const DetailContainer({
    super.key,
    required this.title,
    required this.value,
    this.onTap
  });

  final String title;
  final String value;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.primaryColor,
          borderRadius: BorderRadius.circular(10),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Stack(
            children: [
              const Positioned(
                top: -20,
                right: -20,
                child: CircleAvatar(
                  backgroundColor: Color(0xff3A5BCC),
                  radius: 60,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 35),
                    Text(
                      value,
                      style:
                          TextStyles.textSize36.copyWith(color: Colors.white),
                    ),
                    const Gap(20),
                    Text(
                      title,
                      style:
                          TextStyles.textSize18.copyWith(color: Colors.white),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
