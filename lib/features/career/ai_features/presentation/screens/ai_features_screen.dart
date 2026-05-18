import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wasl/components/inputs/cv_upload_field.dart';
import 'package:wasl/core/utils/colors.dart';
import 'package:wasl/core/utils/text_styles.dart';
import 'package:wasl/features/career/ai_features/presentation/cubit/ai_cubit.dart';

class AiFeaturesScreen extends StatelessWidget {
  const AiFeaturesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AiCubit(),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.primaryColor,
          title: Text(
            'Upload Document',
            style: TextStyles.textSize18
                .copyWith(color: Colors.white, fontSize: 20),
          ),
        ),
        body: const SingleChildScrollView(
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              FileUploadField(),
            ],
          ),
        ),
      ),
    );
  }
}
