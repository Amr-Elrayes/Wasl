import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:wasl/core/utils/text_styles.dart';
import 'package:wasl/features/auth/models/listtile_item_model.dart';

class ExpansionTileItem extends StatelessWidget {
  const ExpansionTileItem({super.key, required this.model});
  final ListTileItemModel model;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          model.name,
          style: TextStyles.textSize15.copyWith(fontWeight: FontWeight.bold),
        ),
        Gap(5),
        Row(
          children: [
            Text(
              model.location ?? "  ",
              style: TextStyles.textSize15,
            ),
            Text(
              " | ",
              style: TextStyles.textSize15,
            ),
            Text(
              model.dateRange,
              style: TextStyles.textSize15,
            )
          ],
        )
      ],
    );
  }
}
