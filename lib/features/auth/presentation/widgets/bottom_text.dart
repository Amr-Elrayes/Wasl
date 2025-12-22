import 'package:flutter/material.dart';
import 'package:wasl/core/routes/navigation.dart';
import 'package:wasl/core/routes/routes.dart';
import 'package:wasl/core/utils/colors.dart';
import 'package:wasl/core/utils/text_styles.dart';

class BottomNavbar extends StatelessWidget {
  const BottomNavbar({super.key, required this.current_page});
  final String current_page;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        if (current_page == "login") ...[
          Text("Don\’t Have an Account?  ",
              style: TextStyles.textSize15.copyWith(
                color: AppColors.darkColor,
                fontWeight: FontWeight.w500,
              )),
          TextButton(
            onPressed: () {
              pushReplacment(context, Routes.register);
            },
            style: TextButton.styleFrom(
              padding: EdgeInsets.zero,
              minimumSize: Size(0, 0),
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: Text(
              "Register",
              style:
                  TextStyles.textSize15.copyWith(color: AppColors.primaryColor),
            ),
          ),
        ] else if (current_page == "register") ...[
          Text("Already Have an Account? ",
              style: TextStyles.textSize15.copyWith(
                color: AppColors.darkColor,
                fontWeight: FontWeight.w500,
              )),
          TextButton(
            onPressed: () {
              pushReplacment(context, Routes.login);
            },
            style: TextButton.styleFrom(
              padding: EdgeInsets.zero,
              minimumSize: Size(0, 0),
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: Text(
              "Login",
              style:
                  TextStyles.textSize15.copyWith(color: AppColors.primaryColor),
            ),
          ),
        ],
      ]),
    );
  }
}
