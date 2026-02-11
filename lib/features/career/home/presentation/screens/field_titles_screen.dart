import 'package:flutter/material.dart';
import 'package:wasl/components/cards/title_card.dart';
import 'package:wasl/core/constants/Industries.dart';
import 'package:wasl/core/routes/navigation.dart';
import 'package:wasl/core/routes/routes.dart';
import 'package:wasl/core/utils/colors.dart';
import 'package:wasl/core/utils/text_styles.dart';

class FieldTitlesScreen extends StatelessWidget {
  const FieldTitlesScreen({super.key, required this.field});
  final String field;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          field,
          style:
              TextStyles.textSize18.copyWith(color: Colors.white, fontSize: 20),
        ),
        backgroundColor: AppColors.primaryColor,
        leading: IconButton(
          onPressed: () {
            pop(context);
          },
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          color: Colors.white,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 20, right: 20, top: 30),
        child: ListView.builder(
            itemBuilder: (context, index) {
              final title = industryJobTitles[field]![index];
              return TitleCard(
                title: title,
                onTap: () {
                  pushTo(context, Routes.titleJobs, extra: title);
                },
              );
            },
            itemCount: industryJobTitles[field]!.length),
      ),
    );
  }
}
