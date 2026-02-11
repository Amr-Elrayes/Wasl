import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:wasl/components/buttons/custom_buttom.dart';
import 'package:wasl/core/job/cubit/job_cubit.dart';
import 'package:wasl/core/utils/colors.dart';
import 'package:wasl/core/utils/text_styles.dart';
import 'package:wasl/core/job/models/list_item_model.dart';
import 'package:wasl/features/auth/presentation/complete_profile/widgets/bottomsheet_text_form_field.dart';
import 'package:wasl/features/company/add%20job/presentation/widgets/addjob_expansion_tile_widget.dart';

class AddjobSkillsBottomSheetContent extends StatefulWidget {
  const AddjobSkillsBottomSheetContent({
    super.key,
    required this.cubit,
    required this.widget,
  });
  final AddjobExpansionTileWidget widget;

  final JobCubit cubit;

  @override
  State<AddjobSkillsBottomSheetContent> createState() =>
      _AddjobSkillsBottomSheetContentState();
}

class _AddjobSkillsBottomSheetContentState
    extends State<AddjobSkillsBottomSheetContent> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController skillController;
  @override
  void initState() {
    skillController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    skillController.dispose();
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
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Add Skill",
                  style: TextStyles.textSize18.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.darkColor,
                  ),
                ),
              ],
            ),
            const Gap(20),
            bottomsheet_text_form_field(
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Please Enter a Skill";
                }
                return null;
              },
              controller: skillController,
              hint: "Skill",
            ),
            const Gap(20),
            const SizedBox(
              height: 150,
            ),
            customButtom(
              txt: "Add",
              onPressed: () {
                if (!_formKey.currentState!.validate()) return;
                widget.widget.onAdd(
                  ListItemModel(
                    name: skillController.text,
                  ),
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
