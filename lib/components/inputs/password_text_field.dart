import 'package:flutter/material.dart';
import 'package:wasl/core/utils/colors.dart';

// ignore: must_be_immutable
class PasswordTextField extends StatefulWidget {
  PasswordTextField({
    super.key,
    this.hintText,
    this.validator,
    required this.controller,
    this.maxlines = 1,
    this.ontap,
    this.readonly = false,
    this.textAlign = TextAlign.start,
    this.Picon,
  });
  final String? hintText;
  final String? Function(String?)? validator;
  final TextEditingController controller;
  int maxlines;
  Function()? ontap;
  bool readonly;
  TextAlign textAlign;
  final Widget? Picon;

  @override
  State<PasswordTextField> createState() => _customTextformfieldState();
}

class _customTextformfieldState extends State<PasswordTextField> {
  bool obsecureText = true;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      obscureText: obsecureText,
      readOnly: widget.readonly,
      onTap: widget.ontap,
      maxLines: widget.maxlines,
      controller: widget.controller,
      validator: widget.validator,
      textAlign: widget.textAlign,
      decoration: InputDecoration(
        prefixIcon: widget.Picon,
        hintText: widget.hintText,
        suffixIcon: GestureDetector(
          onTap: () {
            setState(() {
              obsecureText = !obsecureText;
            });
          },
          child: Icon(
            obsecureText ? Icons.visibility_off : Icons.visibility,
            color: AppColors.primaryColor,
          ),
        ),
        filled: true,
        fillColor: AppColors.jobCardColor,
      ),
    );
  }
}
