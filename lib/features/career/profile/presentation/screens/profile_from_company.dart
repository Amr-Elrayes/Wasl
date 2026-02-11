import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:wasl/components/cards/info_container.dart';
import 'package:wasl/core/functions/showloadingdialog.dart';
import 'package:wasl/core/functions/snackbar.dart';
import 'package:wasl/core/job/models/list_item_model.dart';
import 'package:wasl/core/routes/navigation.dart';
import 'package:wasl/core/routes/routes.dart';
import 'package:wasl/core/utils/colors.dart';
import 'package:wasl/core/utils/text_styles.dart';
import 'package:wasl/features/auth/cubit/auth_cubit.dart';
import 'package:wasl/features/auth/cubit/auth_state.dart';
import 'package:wasl/features/auth/models/career_builder_model.dart';
import 'package:wasl/features/career/profile/presentation/widgets/list_item.dart';
import 'package:wasl/features/career/profile/presentation/widgets/skills_wrap.dart';

class ProfileFromCompany extends StatelessWidget {
  const ProfileFromCompany({super.key, this.user, required this.canEdit});
  final CareerBuilderModel? user;
  final bool canEdit;
  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
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
          body: _ProfileBody(
        user: user!,
        canEdit: canEdit,
      )),
    );
  }
}

class _ProfileBody extends StatelessWidget {
  const _ProfileBody({required this.user, required this.canEdit});
  final CareerBuilderModel user;
  final bool canEdit;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20, top: 50),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InfoContainer(
              image: user.image,
              name: user.name,
              email: user.email,
              field: user.jobTitle,
              isCompany: false,
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
            _sectionTitle("Summary"),
            Text(
              user.summary ?? "No summary added",
              style: TextStyles.textSize15.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
            const Gap(20),
            _sectionTitle("Work Experiences"),
            _listOrEmpty(
              items: user.workExperiences,
              emptyText: "No Work Experience Added",
            ),
            const Gap(20),
            _sectionTitle("Education"),
            _listOrEmpty(
              items: user.education,
              emptyText: "No Education Added",
            ),
            const Gap(20),
            _sectionTitle("Certificates"),
            _listOrEmpty(
              items: user.certificates,
              emptyText: "No Certificates Added",
            ),
            const Gap(20),
            _sectionTitle("Skills"),
            user.skills!.isEmpty
                ? Text("No Skills Added", style: TextStyles.textSize15)
                : SkillsWrap(model: user),
            const Gap(30),
          ],
        ),
      ),
    );
  }
}

Widget _sectionTitle(String text) {
  return Text(
    text,
    style: TextStyles.textSize18.copyWith(
      fontWeight: FontWeight.bold,
      color: AppColors.primaryColor,
    ),
  );
}

Widget _listOrEmpty({
  required List<ListItemModel>? items,
  required String emptyText,
}) {
  if (items == null || items.isEmpty) {
    return Text(emptyText, style: TextStyles.textSize15);
  }

  return ListView.separated(
    shrinkWrap: true,
    physics: const NeverScrollableScrollPhysics(),
    separatorBuilder: (_, __) => const Divider(color: AppColors.grayColor),
    itemCount: items.length,
    itemBuilder: (context, index) {
      return ListItem(model: items[index]);
    },
  );
}
