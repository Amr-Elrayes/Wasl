import 'package:flutter/material.dart';
import 'package:wasl/core/utils/colors.dart';
import 'package:wasl/core/utils/text_styles.dart';

// ignore: must_be_immutable
class customButtom extends StatelessWidget {
  customButtom({
    super.key,
    required this.txt,
    required this.onPressed,
    this.color = AppColors.primaryColor,
    this.txtColor = AppColors.bgColor,
    this.borderColor = AppColors.primaryColor,
    this.width = double.infinity,
    this.height = 55,
  });
  final String txt;
  final VoidCallback? onPressed;
  Color color;
  Color txtColor;
  Color borderColor;
  double width;
  double height;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: width,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          side: BorderSide(color: borderColor),
          backgroundColor: color,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        onPressed: onPressed,
        child: Center(
          child: Text(
            txt,
            style: TextStyles.textSize18.copyWith(
              color: txtColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
