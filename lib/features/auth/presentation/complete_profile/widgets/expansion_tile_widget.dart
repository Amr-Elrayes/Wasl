import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wasl/core/utils/colors.dart';
import 'package:wasl/core/utils/text_styles.dart';
import 'package:wasl/features/auth/cubit/auth_cubit.dart';
import 'package:wasl/features/auth/presentation/complete_profile/widgets/bottomsheet_content.dart';
import 'package:wasl/features/auth/presentation/complete_profile/widgets/skills_bottom_sheet_content.dart';

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
    var cubit = context.read<AuthCubit>();
    return Container(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
            color: isExpanded ? AppColors.bgColor : AppColors.softgrayColor,
            borderRadius: BorderRadius.circular(8)),
        child: ExpansionTile(
          onExpansionChanged: (value) {
            setState(() => isExpanded = value);

            widget.onExpansionChanged?.call(value);
          },
          tilePadding: EdgeInsets.zero,
          childrenPadding: const EdgeInsets.symmetric(horizontal: 15),
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
          children: [
            Row(mainAxisAlignment: MainAxisAlignment.end, children: [
              IconButton(
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    backgroundColor: Colors.transparent,
                    builder: (context) {
                      return Padding(
                        padding: EdgeInsets.only(
                          bottom: MediaQuery.of(context).viewInsets.bottom,
                        ),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 20),
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(20),
                              topRight: Radius.circular(20),
                            ),
                          ),
                          child: widget.title == "Skills"
                              ? skills_bottom_sheet_content(
                                  widget: widget, cubit: cubit)
                              : bottomsheet_content(
                                  widget: widget,
                                  cubit: cubit,
                                ),
                        ),
                      );
                    },
                  );
                },
                icon: const Icon(
                  Icons.add,
                  color: AppColors.primaryColor,
                  size: 25,
                ),
              ),
            ]),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.2,
              child: ListView.separated(
                physics: const BouncingScrollPhysics(),
                itemBuilder: (context, index) => widget.children[index],
                separatorBuilder: (context, index) => const Divider(
                  color: AppColors.grayColor,
                ),
                itemCount: widget.children.length,
              ),
            )
          ],
        ));
  }
}
