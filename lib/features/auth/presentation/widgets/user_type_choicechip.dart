import 'package:flutter/material.dart';
import 'package:wasl/core/constants/enums.dart';
import 'package:wasl/core/utils/colors.dart';
import 'package:wasl/core/utils/text_styles.dart';

class UserTypeChipSelector extends StatefulWidget {
  final Function(usertype) onUserTypeSelected;

  const UserTypeChipSelector({
    Key? key,
    required this.onUserTypeSelected,
  }) : super(key: key);

  @override
  _UserTypeChipSelectorState createState() => _UserTypeChipSelectorState();
}

class _UserTypeChipSelectorState extends State<UserTypeChipSelector> {
  usertype? selectedusertype;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: usertype.values.map((userType) {
        final isSelected = selectedusertype == userType;

        return ChoiceChip(
          showCheckmark: true,
          checkmarkColor: AppColors.bgColor,
          label: Text(
            userType.name,
            style: TextStyles.textSize15.copyWith(
              color: isSelected ? AppColors.bgColor : AppColors.darkColor,
              fontWeight: FontWeight.w500,
            ),
          ),
          selected: isSelected,
          onSelected: (selected) {
            setState(() {
              selectedusertype = selected ? userType : null;
            });
            if (selected) {
              widget.onUserTypeSelected(userType);
            }
          },
          selectedColor: AppColors.primaryColor,
          backgroundColor: AppColors.jobCardColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
            side: BorderSide(
              color: isSelected ? AppColors.primaryColor : Colors.transparent,
              width: 2,
            ),
          ),
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        );
      }).toList(),
    );
  }
}
