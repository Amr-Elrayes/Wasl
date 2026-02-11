import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wasl/core/job/cubit/job_cubit.dart';
import 'package:wasl/core/utils/colors.dart';
import 'package:wasl/core/utils/text_styles.dart';
import 'package:wasl/core/job/models/list_item_model.dart';
import 'package:wasl/features/auth/presentation/complete_profile/widgets/expansion_tile_item.dart';
import 'package:wasl/features/company/add%20job/presentation/widgets/addjob_skills_bottom_sheet_content.dart';

class AddjobExpansionTileWidget extends StatefulWidget {
  const AddjobExpansionTileWidget({
    super.key,
    required this.title,
    required this.items,
    required this.onAdd,
    required this.onDelete,
  });

  final String title;
  final List<ListItemModel> items;
  final Function(ListItemModel) onAdd;
  final Function(int index) onDelete;

  @override
  State<AddjobExpansionTileWidget> createState() =>
      _AddjobExpansionTileWidgetState();
}

class _AddjobExpansionTileWidgetState extends State<AddjobExpansionTileWidget> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<JobCubit>();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: isExpanded ? AppColors.bgColor : AppColors.softgrayColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: ExpansionTile(
        tilePadding: EdgeInsets.zero,
        childrenPadding: const EdgeInsets.symmetric(horizontal: 15),
        shape: const Border(),
        collapsedShape: const Border(),
        onExpansionChanged: (value) {
          setState(() => isExpanded = value);
        },
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
          color: AppColors.primaryColor,
        ),
        children: [
          Align(
            alignment: Alignment.centerRight,
            child: IconButton(
              icon: const Icon(Icons.add, color: AppColors.primaryColor),
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  backgroundColor: Colors.transparent,
                  builder: (sheetContext) {
                    return Padding(
                      padding: EdgeInsets.only(
                        bottom: MediaQuery.of(sheetContext).viewInsets.bottom,
                      ),
                      child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 20),
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(20),
                            ),
                          ),
                          child: AddjobSkillsBottomSheetContent(
                            cubit: cubit,
                            widget: widget,
                          )),
                    );
                  },
                );
              },
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.25,
            child: ListView.separated(
              itemCount: widget.items.length,
              separatorBuilder: (_, __) =>
                  const Divider(color: AppColors.grayColor),
              itemBuilder: (context, index) {
                return Dismissible(
                  key: ValueKey(widget.items[index].name),
                  direction: DismissDirection.horizontal,
                  background: _deleteBg(Alignment.centerLeft),
                  secondaryBackground: _deleteBg(Alignment.centerRight),
                  onDismissed: (_) {
                    widget.onDelete(index);
                  },
                  child: ExpansionTileItem(model: widget.items[index]),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _deleteBg(Alignment alignment) {
    return Container(
      alignment: alignment,
      padding: const EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
        color: AppColors.redColor,
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }
}
