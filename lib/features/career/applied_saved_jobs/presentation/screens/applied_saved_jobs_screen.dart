import 'package:flutter/material.dart';
import 'package:wasl/core/utils/colors.dart';
import 'package:wasl/core/utils/text_styles.dart';

class AppliedSavedJobsScreen extends StatelessWidget {
  const AppliedSavedJobsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Applied Jobs",
          style:
              TextStyles.textSize18.copyWith(color: Colors.white, fontSize: 20),
        ),
        backgroundColor: AppColors.primaryColor,
      ),
    );
  }
}
