import 'package:flutter/material.dart';
import 'package:wasl/components/inputs/cv_upload_field.dart';
import 'package:wasl/core/utils/colors.dart';
import 'package:wasl/core/utils/text_styles.dart';

class AiFeaturesScreen extends StatelessWidget {
  const AiFeaturesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: AppColors.primaryColor,
          title: Text('Upload Document',
              style: TextStyles.textSize18
                  .copyWith(color: Colors.white, fontSize: 20))),
      body: const Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            FileUploadField(),
          ],
        ),
      ),
    );
  }
}
