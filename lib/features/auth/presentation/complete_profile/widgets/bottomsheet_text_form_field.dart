import 'package:flutter/material.dart';
import 'package:wasl/core/utils/colors.dart';
import 'package:wasl/core/utils/text_styles.dart';

class bottomsheet_text_form_field extends StatelessWidget {
  const bottomsheet_text_form_field({
    super.key,
    required this.hint,
    required this.controller,
    this.isDateField = false,
    this.onTap,
    this.validator,
  });

  final TextEditingController controller;
  final String hint;
  final bool isDateField;
  final VoidCallback? onTap;
  final String? Function(String?)? validator;

  @override
  Widget build(BuildContext context) {
    final textField = TextFormField(
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: validator,
        controller: controller,
        enabled: !isDateField,
        style: TextStyles.textSize15.copyWith(
          color: AppColors.darkColor,
        ),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyles.textSize15.copyWith(
            color: AppColors.darkColor,
          ),
          disabledBorder: const UnderlineInputBorder(
            borderSide: BorderSide(
              color: AppColors.grayColor,
              width: 2,
            ),
          ),
          enabledBorder: const UnderlineInputBorder(
            borderSide: BorderSide(
              color: AppColors.grayColor,
              width: 2,
            ),
          ),
          focusedBorder: const UnderlineInputBorder(
            borderSide: BorderSide(
              color: AppColors.primaryColor,
              width: 2,
            ),
          ),
          errorBorder: const UnderlineInputBorder(
            borderSide: BorderSide(
              color: AppColors.redColor,
              width: 2,
            ),
          ),
          focusedErrorBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: AppColors.redColor, width: 2),
          ),
        ));

    if (isDateField) {
      return GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: textField,
      );
    }

    return textField;
  }
}
