import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wasl/core/utils/colors.dart';

// ignore: must_be_immutable
class customTextformfield extends StatelessWidget {
  customTextformfield({
    super.key,
    this.hintText,
    this.validator,
    required this.controller,
    this.maxlines = 1,
    this.Sicon,
    this.Picon,
    this.ontap,
    this.readonly = false,
    this.textAlign = TextAlign.start,
    this.keyboardType = TextInputType.text,
    this.inputFormatters
  });
  final String? hintText;
  final String? Function(String?)? validator;
  final TextEditingController controller;
  int maxlines;
  final Widget? Sicon;
  final Widget? Picon;
  Function()? ontap;
  bool readonly;
  TextAlign textAlign;
  TextInputType keyboardType;
  List<TextInputFormatter>? inputFormatters;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      textAlign: textAlign,
      readOnly: readonly,
      onTap: ontap,
      maxLines: maxlines,
      controller: controller,
      validator: validator,
      decoration: InputDecoration(
        hintText: hintText,
        suffixIcon: Sicon,
        prefixIcon: Picon,
        filled: true,
        fillColor: AppColors.jobCardColor,
      ),
    );
  }
}
