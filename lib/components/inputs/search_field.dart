import 'package:flutter/material.dart';
import 'package:wasl/core/utils/colors.dart';
import 'package:wasl/core/utils/text_styles.dart';

class Searchfield extends StatelessWidget {
  const Searchfield({
    super.key,
    required this.controller,
    this.onChanged,
    required this.isIdel, this.focusNode,
  });
  final TextEditingController controller;
  final Function(String)? onChanged;
  final bool isIdel;
  final FocusNode? focusNode;
  @override
  Widget build(BuildContext context) {
    return AbsorbPointer(
      absorbing: isIdel,
      child: TextFormField(
        focusNode: focusNode,
          onChanged: onChanged,
          controller: controller,
          textAlignVertical: TextAlignVertical.center,
          style: TextStyles.textSize15,
          cursorColor: AppColors.primaryColor,
          decoration: InputDecoration(
              prefixIcon: const Icon(Icons.search,
                  color: AppColors.primaryColor, size: 30),
              filled: true,
              fillColor: Colors.transparent,
              hintText: "Search By Job Title",
              hintStyle: TextStyles.textSize15,
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: const BorderSide(color: AppColors.primaryColor),
              ))),
    );
  }
}
