import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:image_picker/image_picker.dart';
import 'package:wasl/components/buttons/custom_buttom.dart';
import 'package:wasl/components/inputs/custom_text_field.dart';
import 'package:wasl/core/constants/Industries.dart';
import 'package:wasl/core/constants/app_icons.dart';
import 'package:wasl/core/constants/app_images.dart';
import 'package:wasl/core/constants/user_type_enum.dart';
import 'package:wasl/core/functions/showloadingdialog.dart';
import 'package:wasl/core/functions/snackbar.dart';
import 'package:wasl/core/routes/navigation.dart';
import 'package:wasl/core/routes/routes.dart';
import 'package:wasl/core/utils/colors.dart';
import 'package:wasl/core/utils/text_styles.dart';
import 'package:wasl/features/auth/cubit/auth_cubit.dart';
import 'package:wasl/features/auth/cubit/auth_state.dart';

class CompanyCompleteProfile extends StatefulWidget {
  const CompanyCompleteProfile({super.key});

  @override
  State<CompanyCompleteProfile> createState() => _CompanyCompleteProfileState();
}

class _CompanyCompleteProfileState extends State<CompanyCompleteProfile> {
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
      body: BlocListener<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is AuthLoadingState) {
            showloadingDialog(context);
          } else if (state is AuthSuccessState) {
            pop(context);
            pushAndRemoveUntil(context, Routes.Cmain);
          } else if (state is AuthFailureState) {
            Navigator.pop(context);
            showSnakBar(context, Colors.red, state.errorMessage);
          }
        },
        child: Padding(
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
                              decoration:
                                  const BoxDecoration(color: AppColors.bgColor),
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
                                    const Gap(20),
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
                            backgroundColor:
                                AppColors.grayColor.withOpacity(0.4),
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
                  const Gap(15),
                  Text(
                    "Industrie",
                    style: TextStyles.textSize15
                        .copyWith(fontWeight: FontWeight.w500),
                  ),
                  const Gap(5),
                  Container(
                    height: 50,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: AppColors.softgrayColor,
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: DropdownButton<String?>(
                      icon: const Icon(
                        Icons.expand_circle_down_outlined,
                        color: AppColors.primaryColor,
                      ),
                      iconEnabledColor: AppColors.primaryColor,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 15,
                        vertical: 5,
                      ),
                      underline: const SizedBox(),
                      isExpanded: true,
                      hint: const Text("Select Industrie"),
                      value: cubit.Industrie,
                      items: [
                        for (var industry in industryJobTitles.keys)
                          DropdownMenuItem(
                            value: industry,
                            child: Text(industry),
                          ),
                      ],
                      onChanged: (String? newValue) {
                        setState(() {
                          cubit.Industrie = newValue;
                        });
                      },
                    ),
                  ),
                  const Gap(15),
                  Text(
                    "Bio",
                    style: TextStyles.textSize15
                        .copyWith(fontWeight: FontWeight.w500),
                  ),
                  const Gap(5),
                  customTextformfield(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please Enter Company’s bio";
                      }
                      return null;
                    },
                    controller: cubit.bioController,
                    hintText: "Enter Company’s bio ",
                    maxlines: 4,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Container(
          margin: const EdgeInsets.all(10),
          child: SizedBox(
            width: double.infinity,
            height: 60,
            child: customButtom(
              txt: "Done",
              onPressed: () async {
                if (cubit.formKey.currentState!.validate()) {
                  if (imagePath != null) {
                    cubit.updateData(imagePath, usertype.Company);
                  } else {
                    showSnakBar(
                        context, AppColors.redColor, "Please Upload an Image");
                  }
                }
              },
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
