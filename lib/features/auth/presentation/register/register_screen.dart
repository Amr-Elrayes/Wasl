import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:wasl/components/buttons/custom_buttom.dart';
import 'package:wasl/components/inputs/custom_text_field.dart';
import 'package:wasl/components/inputs/password_text_field.dart';
import 'package:wasl/core/constants/enums.dart';
import 'package:wasl/core/functions/showloadingdialog.dart';
import 'package:wasl/core/functions/snackbar.dart';
import 'package:wasl/core/routes/navigation.dart';
import 'package:wasl/core/routes/routes.dart';
import 'package:wasl/core/utils/colors.dart';
import 'package:wasl/core/utils/text_styles.dart';
import 'package:wasl/features/auth/cubit/auth_cubit.dart';
import 'package:wasl/features/auth/cubit/auth_state.dart';
import 'package:wasl/features/auth/presentation/widgets/bottom_text.dart';
import 'package:wasl/features/auth/presentation/widgets/user_type_choicechip.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  usertype? selectedUserType;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: const Padding(
        padding: EdgeInsets.only(bottom: 20),
        child: BottomNavbar(current_page: "register"),
      ),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: GestureDetector(
          onTap: () {
            pop(context);
          },
        ),
        centerTitle: false,
      ),
      body: SingleChildScrollView(child: _buildregsterbody(context)),
    );
  }

  Widget _buildregsterbody(BuildContext context) {
    var cubit = context.read<AuthCubit>();
    return BlocListener<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is AuthLoadingState) {
            showloadingDialog(context);
          } else if (state is AuthSuccessState) {
            pop(context);
            if (selectedUserType == usertype.Career) {
              pushAndRemoveUntil(context, Routes.BuilderCompleteProfileScreen);
            } else {
              pushAndRemoveUntil(context, Routes.CompanyCompleteProfileScreen);
            }
          } else if (state is AuthFailureState) {
            Navigator.pop(context);
            showSnakBar(context, Colors.red, state.errorMessage);
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(22),
          child: Form(
            key: cubit.formKey,
            child: Column(
              children: [
                Text("Hello , Thanks for Choosing us . Let’s Start",
                    style: TextStyles.textSize30.copyWith(
                      color: AppColors.darkColor,
                      fontWeight: FontWeight.bold,
                    )),
                const Gap(30),
                customTextformfield(
                  controller: cubit.nameController,
                  hintText: "Enter your name",
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter your name";
                    }
                    return null;
                  },
                  Picon: const Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child:
                            Icon(Icons.person, color: AppColors.primaryColor),
                      ),
                    ],
                  ),
                ),
                const Gap(15),
                customTextformfield(
                  controller: cubit.emailController,
                  hintText: "Enter your email",
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter your email";
                    }
                    return null;
                  },
                  Picon: const Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: Icon(Icons.email, color: AppColors.primaryColor),
                      ),
                    ],
                  ),
                ),
                const Gap(15),
                PasswordTextField(
                  controller: cubit.passwordController,
                  hintText: "Enter your password",
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter your password";
                    }
                    return null;
                  },
                  Picon: const Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: Icon(Icons.lock, color: AppColors.primaryColor),
                      ),
                    ],
                  ),
                ),
                const Gap(15),
                PasswordTextField(
                  controller: cubit.confirmpasswordController,
                  hintText: "Confirm your password",
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please confirm your password";
                    }
                    return null;
                  },
                  Picon: const Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: Icon(Icons.lock, color: AppColors.primaryColor),
                      ),
                    ],
                  ),
                ),
                const Gap(15),
                UserTypeChipSelector(
                  onUserTypeSelected: (usertype userType) {
                    setState(() {
                      selectedUserType = userType;
                    });
                  },
                ),
                const Gap(30),
                customButtom(
                  txt: "Register",
                  onPressed: () {
                    if (selectedUserType == null) {
                      showSnakBar(
                          context, Colors.red, "Please select user type");
                      return;
                    }
                    if (cubit.formKey.currentState!.validate()) {
                      cubit.register(type: selectedUserType!);
                    }
                  },
                ),
              ],
            ),
          ),
        ));
  }
}
