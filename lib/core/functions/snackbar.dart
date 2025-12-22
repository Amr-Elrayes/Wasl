import 'package:flutter/material.dart';
import 'package:wasl/core/utils/colors.dart';
import 'package:wasl/core/utils/text_styles.dart';

showSnakBar(BuildContext context, Color bgColor, String text) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      behavior: SnackBarBehavior.floating,
      margin: EdgeInsets.all(20),
      elevation: 0,
      backgroundColor: bgColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      content: Text(
        text,
        style: TextStyles.textSize18.copyWith(color: AppColors.bgColor),
      ),
    ),
  );
}
