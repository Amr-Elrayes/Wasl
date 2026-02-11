import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:wasl/components/cards/info_container.dart';
import 'package:wasl/core/functions/showloadingdialog.dart';
import 'package:wasl/core/functions/snackbar.dart';
import 'package:wasl/core/routes/navigation.dart';
import 'package:wasl/core/routes/routes.dart';
import 'package:wasl/core/utils/colors.dart';
import 'package:wasl/core/utils/text_styles.dart';
import 'package:wasl/features/auth/cubit/auth_cubit.dart';
import 'package:wasl/features/auth/cubit/auth_state.dart';
import 'package:wasl/features/auth/models/company_model.dart';
import 'package:wasl/services/firebase/firebase_services.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key, required this.canEdit});
  final bool canEdit;
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthCubit(),
      child: BlocListener<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is AuthLoadingState) {
            showloadingDialog(context);
          } else if (state is AuthLogoutState) {
            pushReplacment(context, Routes.splah);
          } else if (state is AuthFailureState) {
            Navigator.pop(context);
            showSnakBar(context, Colors.red, state.errorMessage);
          }
        },
        child: Scaffold(
            body: StreamBuilder<CompanyModel>(
          stream: FirestoreServices.getCompanyStream(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return CircularProgressIndicator();
            }

            final company = snapshot.data!;

            return Padding(
              padding: const EdgeInsets.only(left: 20, right: 20, top: 50),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  InfoContainer(
                    image: company.image,
                    name: company.name,
                    email: company.email,
                    field: company.field,
                    isCompany: true,
                    canEdit: canEdit,
                    onLogout: () {
                      showDialog(
                        context: context,
                        builder: (_) => AlertDialog(
                          title: const Text("Logout"),
                          content: const Text("Are you sure?"),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text("Cancel"),
                            ),
                            TextButton(
                              onPressed: () {
                                context.read<AuthCubit>().logout();
                                Navigator.pop(context);
                              },
                              child: const Text("Logout"),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                  const Gap(40),
                  Text(
                    "Bio",
                    style: TextStyles.textSize18.copyWith(
                        fontWeight: FontWeight.w500,
                        color: AppColors.primaryColor),
                  ),
                  const Gap(10),
                  Expanded(
                      child: Text(
                    company.bio!,
                    style: TextStyles.textSize18
                        .copyWith(fontWeight: FontWeight.w500),
                  ))
                ],
              ),
            );
          },
        )),
      ),
    );
  }
}
