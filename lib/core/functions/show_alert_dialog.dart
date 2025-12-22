import 'package:flutter/material.dart';
import 'package:wasl/core/utils/colors.dart';
import 'package:wasl/core/utils/text_styles.dart';

showAlertDialog(
  BuildContext context, {
  String? ok,
  String? no,
  required String title,
  void Function()? onTap,
}) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return SimpleDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        backgroundColor: AppColors.jobCardColor,
        children: [
          Container(
            decoration: BoxDecoration(
              color: AppColors.jobCardColor,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              children: [
                Icon(Icons.check, size: 50, color: AppColors.darkColor),
                const SizedBox(height: 20),
                Text(
                  title,
                  style: TextStyles.textSize24.copyWith(
                    color: AppColors.darkColor,
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    if (ok != null)
                      GestureDetector(
                        onTap: onTap,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 10,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: AppColors.primaryColor,
                          ),
                          child: Text(
                            ok,
                            style: TextStyles.textSize18.copyWith(
                              color: AppColors.bgColor,
                            ),
                          ),
                        ),
                      ),
                    if (no != null)
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 10,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: AppColors.jobCardColor,
                          ),
                          child: Text(no, style: TextStyles.textSize18),
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ],
      );
    },
  );
}
