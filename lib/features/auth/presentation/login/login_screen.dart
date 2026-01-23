import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:wasl/components/buttons/custom_buttom.dart';
import 'package:wasl/components/inputs/custom_text_field.dart';
import 'package:wasl/components/inputs/password_text_field.dart';
import 'package:wasl/core/functions/showloadingdialog.dart';
import 'package:wasl/core/functions/snackbar.dart';
import 'package:wasl/core/routes/navigation.dart';
import 'package:wasl/core/routes/routes.dart';
import 'package:wasl/core/utils/colors.dart';
import 'package:wasl/core/utils/text_styles.dart';
import 'package:wasl/features/auth/cubit/auth_cubit.dart';
import 'package:wasl/features/auth/cubit/auth_state.dart';
import 'package:wasl/features/auth/presentation/widgets/bottom_text.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(bottom: 20),
        child: BottomNavbar(current_page: "login"),
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
      body: SingleChildScrollView(child: _buildloginbody(context)),
    );
  }

  Widget _buildloginbody(BuildContext context) {
    var cubit = context.read<AuthCubit>();
    return BlocListener<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is AuthLoadingState) {
            showloadingDialog(context);
          } else if (state is AuthSuccessState) {
            pop(context);
            if (state.role == "Career") {
              pushAndRemoveUntil(context, Routes.Bmain);
            } else {
              pushAndRemoveUntil(context, Routes.Cmain);
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
                Text(
                  "Welcome back! Glad to see you, Again!",
                  style: TextStyles.textSize30.copyWith(
                    color: AppColors.darkColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Gap(30),
                customTextformfield(
                  controller: cubit.emailController,
                  hintText: "Enter Your Email",
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please Enter an Email";
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
                Gap(15),
                PasswordTextField(
                  controller: cubit.passwordController,
                  hintText: "Enter Your Password",
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please Enter a Password";
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
                Gap(60),
                customButtom(
                  txt: "Login",
                  onPressed: () {
                    if (cubit.formKey.currentState!.validate()) {
                      cubit.login();
                    }
                  },
                ),
              ],
            ),
          ),
        ));
  }
}
