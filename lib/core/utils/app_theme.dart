import 'package:flutter/material.dart';
import 'package:wasl/core/constants/app_fonts.dart';
import 'package:wasl/core/utils/colors.dart';
import 'package:wasl/core/utils/text_styles.dart';

class AppTheme {
  static get lightTheme => ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primaryColor,
          onSurface: AppColors.darkColor,
        ),
        fontFamily: AppFonts.DMSans,
        scaffoldBackgroundColor: AppColors.bgColor,
        appBarTheme: AppBarTheme(
          surfaceTintColor: Colors.transparent,
          backgroundColor: AppColors.bgColor,
          centerTitle: true,
        ),
        dividerTheme:
            DividerThemeData(color: AppColors.jobCardColor, thickness: 1),
        inputDecorationTheme: InputDecorationTheme(
          hintStyle: TextStyles.textSize15.copyWith(color: AppColors.grayColor),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: AppColors.primaryColor, width: 1),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: AppColors.primaryColor, width: 1),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: AppColors.redColor, width: 1),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: AppColors.redColor, width: 1),
          ),
        ),
      );
}
