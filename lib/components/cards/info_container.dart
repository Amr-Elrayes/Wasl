import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:wasl/core/routes/navigation.dart';
import 'package:wasl/core/routes/routes.dart';
import 'package:wasl/core/utils/colors.dart';
import 'package:wasl/core/utils/text_styles.dart';

class InfoContainer extends StatelessWidget {
  const InfoContainer({
    super.key,
    required this.name,
    required this.image,
    required this.email,
    required this.field,
    required this.isCompany,
    required this.canEdit,
    this.onLogout,
  });

  final String? name;
  final String? image;
  final String? email;
  final String? field;
  final bool isCompany;
  final bool canEdit;
  final VoidCallback? onLogout;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.primaryColor,
        borderRadius: BorderRadius.circular(10),
      ),
      padding: const EdgeInsets.only(left: 15, top: 15, bottom: 20),
      child: Stack(
        children: [
          /// content
          Column(
            children: [
              Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(70),
                    child: Container(
                      height: 120,
                      width: 120,
                      color: Colors.white,
                      child: Image.network(image ?? ""),
                    ),
                  ),
                  const Gap(20),
                  Text(
                    name ?? "",
                    style: TextStyles.textSize24.copyWith(
                      color: Colors.white,
                      fontSize: 20,
                    ),
                  ),
                ],
              ),
              const Gap(20),
              Row(
                children: [
                  const Icon(Icons.work, color: Colors.white),
                  const Gap(5),
                  Text(
                    field ?? "",
                    style: TextStyles.textSize15.copyWith(
                      color: Colors.white,
                      fontSize: 12,
                    ),
                  ),
                  const Gap(10),
                  const Icon(Icons.mail, color: Colors.white),
                  const Gap(5),
                  Expanded(
                    child: Text(
                      email ?? "",
                      style: TextStyles.textSize15.copyWith(
                        color: Colors.white,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),

          /// actions
          if (canEdit)
            Positioned(
              top: 0,
              right: 0,
              child: Row(
                children: [
                  IconButton(
                    onPressed: () {
                      isCompany
                          ? pushTo(context, Routes.CompanyCompleteProfileScreen)
                          : pushTo(
                              context, Routes.BuilderCompleteProfileScreen);
                    },
                    icon: const Icon(Icons.edit, color: Colors.white),
                  ),
                  IconButton(
                    icon: const Icon(Icons.logout, color: Colors.white),
                    onPressed: onLogout,
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

