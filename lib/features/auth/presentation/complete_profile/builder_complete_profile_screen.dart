import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:image_picker/image_picker.dart';
import 'package:wasl/components/buttons/custom_buttom.dart';
import 'package:wasl/components/inputs/custom_text_field.dart';
import 'package:wasl/core/constants/app_icons.dart';
import 'package:wasl/core/constants/app_images.dart';
import 'package:wasl/core/routes/navigation.dart';
import 'package:wasl/core/utils/colors.dart';
import 'package:wasl/core/utils/text_styles.dart';
import 'package:wasl/features/auth/cubit/auth_cubit.dart';
import 'package:wasl/features/auth/cubit/auth_state.dart';
import 'package:wasl/features/auth/presentation/complete_profile/widgets/expansion_tile_item.dart';
import 'package:wasl/features/auth/presentation/complete_profile/widgets/expansion_tile_widget.dart';

class BuilderCompleteProfile extends StatefulWidget {
  const BuilderCompleteProfile({super.key});

  @override
  State<BuilderCompleteProfile> createState() => _BuilderCompleteProfileState();
}

class _BuilderCompleteProfileState extends State<BuilderCompleteProfile> {
  File? imagePath;
  @override
  Widget build(BuildContext context) {
    var cubit = context.read<AuthCubit>();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        title: Text(
          "Complete Your Profile",
          style: TextStyles.textSize18.copyWith(
            color: AppColors.bgColor,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(25),
        child: SingleChildScrollView(
          child: Form(
            key: cubit.formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: GestureDetector(
                    onTap: () {
                      showModalBottomSheet(
                        context: context,
                        builder: (context) {
                          return Container(
                            decoration: BoxDecoration(color: AppColors.bgColor),
                            height: 200,
                            child: Padding(
                              padding: const EdgeInsets.all(20),
                              child: Column(
                                children: [
                                  customButtom(
                                    txt: "From Camera",
                                    onPressed: () {
                                      pop(context);
                                      uploadImages(isCamera: true);
                                    },
                                    txtColor: AppColors.bgColor,
                                    color: AppColors.primaryColor,
                                  ),
                                  Gap(20),
                                  customButtom(
                                    txt: "From Gallery",
                                    onPressed: () {
                                      pop(context);
                                      uploadImages(isCamera: false);
                                    },
                                    txtColor: AppColors.bgColor,
                                    color: AppColors.primaryColor,
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    },
                    child: Stack(
                      children: [
                        CircleAvatar(
                          radius: 70,
                          backgroundColor: AppColors.grayColor.withOpacity(0.4),
                          child: ClipOval(
                            child: imagePath != null
                                ? Image.file(
                                    imagePath!,
                                    width: 140,
                                    height: 140,
                                    fit: BoxFit.contain,
                                  )
                                : Image.asset(
                                    AppImages.person,
                                    width: 120,
                                    height: 120,
                                    fit: BoxFit.contain,
                                  ),
                          ),
                        ),
                        Positioned(
                            left: 105,
                            top: 105,
                            child: SvgPicture.asset(
                              AppIcons.cameraSvg,
                              colorFilter: const ColorFilter.mode(
                                  AppColors.primaryColor, BlendMode.srcIn),
                              height: 25,
                              width: 25,
                            ))
                      ],
                    ),
                  ),
                ),
                Gap(15),
                Text(
                  "Job Title",
                  style: TextStyles.textSize15
                      .copyWith(fontWeight: FontWeight.w500),
                ),
                Gap(5),
                customTextformfield(
                  controller: cubit.jobTitleController,
                  hintText: "ex : UI/UX Designer",
                ),
                Gap(15),
                Text(
                  "Summary",
                  style: TextStyles.textSize15
                      .copyWith(fontWeight: FontWeight.w500),
                ),
                Gap(5),
                customTextformfield(
                  controller: cubit.summaryController,
                  hintText: "Enter Your Summary ",
                  maxlines: 4,
                ),
                Gap(15),
                BlocBuilder<AuthCubit, AuthState>(
                  builder: (context, state) {
                    return ExpansionTileWidget(
                      title: "Work Experience",
                      children: cubit.workExperiences
                          .map((item) => ExpansionTileItem(model: item))
                          .toList(),
                    );
                  },
                ),
                Gap(15),
                BlocBuilder<AuthCubit, AuthState>(
                  builder: (context, state) {
                    return ExpansionTileWidget(
                      title: "Education",
                      children: cubit.education
                          .map((item) => ExpansionTileItem(model: item))
                          .toList(),
                    );
                  },
                ),
                Gap(15),
                BlocBuilder<AuthCubit, AuthState>(
                  builder: (context, state) {
                    return ExpansionTileWidget(
                      title: "Certificates",
                      children: cubit.certificates
                          .map((item) => ExpansionTileItem(model: item))
                          .toList(),
                    );
                  },
                ),
                Gap(15),
                BlocBuilder<AuthCubit, AuthState>(
                  builder: (context, state) {
                    return ExpansionTileWidget(
                      title: "Skills",
                      children: cubit.skills
                          .map((item) => ExpansionTileItem(model: item))
                          .toList(),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> uploadImages({required bool isCamera}) async {
    XFile? file = await ImagePicker().pickImage(
      source: isCamera ? ImageSource.camera : ImageSource.gallery,
    );
    if (file != null) {
      setState(() {
        imagePath = File(file.path);
      });
    }
  }
}
