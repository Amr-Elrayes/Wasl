import 'package:flutter/material.dart';
import 'package:wasl/core/utils/colors.dart';
import 'package:wasl/core/utils/text_styles.dart';
import 'package:wasl/core/job/models/list_item_model.dart';

class ExpansionTileItem extends StatelessWidget {
  const ExpansionTileItem({super.key, required this.model});
  final ListItemModel model;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            model.name,
            style: TextStyles.textSize15.copyWith(
              fontWeight: FontWeight.w600,
              color: AppColors.darkColor,
            ),
          ),
          if (model.location != null && model.location!.isNotEmpty) ...[
            const SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  model.location!,
                  style: TextStyles.textSize15.copyWith(
                    fontSize: 12,
                    color: AppColors.darkColor,
                  ),
                ),
                Row(
                  children: [
                    const Icon(
                      Icons.arrow_left_sharp,
                      size: 20,
                      color: AppColors.redColor,
                    ),
                    Text(
                      "Delete",
                      style: TextStyles.textSize15
                          .copyWith(color: AppColors.redColor),
                    )
                  ],
                )
              ],
            ),
          ],
          if (model.dateRange.isNotEmpty) ...[
            const SizedBox(height: 4),
            Text(
              model.dateRange,
              style: TextStyles.textSize15.copyWith(
                fontSize: 12,
                color: AppColors.darkColor,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
