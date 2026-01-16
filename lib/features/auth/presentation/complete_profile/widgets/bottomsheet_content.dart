import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:wasl/components/buttons/custom_buttom.dart';
import 'package:wasl/core/functions/date_picker.dart';
import 'package:wasl/core/utils/colors.dart';
import 'package:wasl/core/utils/text_styles.dart';
import 'package:wasl/features/auth/cubit/auth_cubit.dart';
import 'package:wasl/features/auth/presentation/complete_profile/widgets/bottomsheet_text_form_field.dart';
import 'package:wasl/features/auth/presentation/complete_profile/widgets/expansion_tile_widget.dart';

class bottomsheet_content extends StatefulWidget {
  bottomsheet_content({
    super.key,
    required this.widget,
    required this.cubit,
  });
  final ExpansionTileWidget widget;
  final AuthCubit cubit;

  @override
  State<bottomsheet_content> createState() => _bottomsheet_contentState();
}

class _bottomsheet_contentState extends State<bottomsheet_content> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController roleController;
  late final TextEditingController locationController;
  late final TextEditingController startDateController;
  late final TextEditingController endDateController;
  final Map<String, String> roleHints = {
    "Work Experience": "Role",
    "Education": "Degree",
    "Certificates": "Certificate Name",
  };

  @override
  void initState() {
    super.initState();
    roleController = TextEditingController();
    locationController = TextEditingController();
    startDateController = TextEditingController();
    endDateController = TextEditingController();
  }

  @override
  void dispose() {
    roleController.dispose();
    locationController.dispose();
    startDateController.dispose();
    endDateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Add ${widget.widget.title}",
                  style: TextStyles.textSize18.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.darkColor,
                  ),
                ),
              ],
            ),
            const Gap(25),
            bottomsheet_text_form_field(
              controller: roleController,
              hint: roleHints[widget.widget.title] ?? "Title",
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Please Enter Your Role";
                }
                return null;
              },
            ),
            const Gap(20),
            bottomsheet_text_form_field(
              controller: locationController,
              hint: "Location",
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Please Enter Location";
                }
                return null;
              },
            ),
            const Gap(20),
            Row(
              children: [
                Expanded(
                  child: bottomsheet_text_form_field(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please Enter Start Date";
                      }
                      return null;
                    },
                    hint: "From",
                    controller: startDateController,
                    isDateField: true,
                    onTap: () async {
                      await pickMonthYearWithDatePicker(
                        context,
                        startDateController,
                      );
                    },
                  ),
                ),
                const Gap(30),
                Expanded(
                  child: bottomsheet_text_form_field(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please Enter Start Date";
                      }
                      return null;
                    },
                    hint: "To",
                    controller: endDateController,
                    isDateField: true,
                    onTap: () async {
                      await pickMonthYearWithDatePicker(
                        context,
                        endDateController,
                      );
                    },
                  ),
                ),
              ],
            ),
            const Gap(40),
            customButtom(
              txt: "Add",
              onPressed: () {
                if (!_formKey.currentState!.validate()) return;
                widget.cubit.addListItem(
                  section: widget.widget.title,
                  name: roleController.text,
                  location: locationController.text,
                  startDate: startDateController.text,
                  endDate: endDateController.text,
                );
                Navigator.pop(context);
              },
            )
          ],
        ),
      ),
    );
  }
}
