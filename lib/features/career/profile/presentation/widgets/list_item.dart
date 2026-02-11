import 'package:flutter/material.dart';
import 'package:wasl/core/utils/colors.dart';
import 'package:wasl/core/utils/text_styles.dart';
import 'package:wasl/core/job/models/list_item_model.dart';

class ListItem extends StatelessWidget {
  const ListItem({super.key, required this.model});
  final ListItemModel model;
  @override
  Widget build(BuildContext context) {
    return Container(
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
          if ((model.location != null && model.location!.isNotEmpty) ||
              model.dateRange.isNotEmpty) ...[
            const SizedBox(height: 4),
            Row(
              children: [
                if (model.location != null && model.location!.isNotEmpty)
                  Text(
                    model.location!,
                    style: TextStyles.textSize15.copyWith(
                      fontSize: 12,
                      color: AppColors.darkColor,
                    ),
                  ),
                if (model.location != null &&
                    model.location!.isNotEmpty &&
                    model.dateRange.isNotEmpty)
                  Text(
                    "  |  ",
                    style: TextStyles.textSize15
                        .copyWith(fontSize: 12, color: AppColors.primaryColor),
                  ),
                if (model.dateRange.isNotEmpty)
                  Text(
                    model.dateRange,
                    style: TextStyles.textSize15.copyWith(
                      fontSize: 12,
                      color: AppColors.darkColor,
                    ),
                  ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
