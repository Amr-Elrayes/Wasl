import 'package:flutter/material.dart';
import 'package:wasl/core/utils/colors.dart';
import 'package:wasl/core/utils/text_styles.dart';

class ExpansionTileWidget extends StatefulWidget {
  const ExpansionTileWidget({
    super.key,
    required this.title,
    this.onExpansionChanged,
    required this.children,
  });

  final String title;
  final ValueChanged<bool>? onExpansionChanged;
  final List<Widget> children;

  @override
  State<ExpansionTileWidget> createState() => _ExpansionTileWidgetState();
}

class _ExpansionTileWidgetState extends State<ExpansionTileWidget> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
          color: isExpanded ? AppColors.bgColor : AppColors.softgrayColor,
          borderRadius: BorderRadius.circular(8)),
      child: ExpansionTile(
          onExpansionChanged: (value) {
            setState(() => isExpanded = value);

            widget.onExpansionChanged?.call(value);
          },
          tilePadding: EdgeInsets.zero,
          childrenPadding: const EdgeInsets.only(left: 15),
          expandedCrossAxisAlignment: CrossAxisAlignment.start,
          expandedAlignment: Alignment.centerLeft,
          shape: const Border(),
          collapsedShape: const Border(),
          title: Text(
            widget.title,
            style: TextStyles.textSize18.copyWith(
              fontWeight: FontWeight.bold,
              color: AppColors.primaryColor,
            ),
          ),
          trailing: Icon(
            isExpanded
                ? Icons.keyboard_arrow_down_rounded
                : Icons.keyboard_arrow_right_rounded,
            size: 25,
            color: AppColors.primaryColor,
          ),
          children: widget.children),
    );
  }
}
