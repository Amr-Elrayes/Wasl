import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:wasl/components/cards/emplpyee_card.dart';
import 'package:wasl/components/cards/job_card.dart';
import 'package:wasl/core/constants/app_images.dart';
import 'package:wasl/core/job/models/job_model.dart';
import 'package:wasl/core/routes/navigation.dart';
import 'package:wasl/core/routes/routes.dart';
import 'package:wasl/core/utils/colors.dart';
import 'package:wasl/core/utils/text_styles.dart';
import 'package:wasl/features/auth/models/career_builder_model.dart';
import 'package:wasl/services/firebase/firebase_services.dart';

class AllItemsScreen extends StatelessWidget {
  const AllItemsScreen({super.key, required this.title});
  final String title;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            title,
            style: TextStyles.textSize18.copyWith(color: Colors.white),
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
          padding: const EdgeInsets.only(top: 30, left: 20, right: 20),
          child: FutureBuilder<String>(
            future: (title.startsWith("Employees"))
                ? FirestoreServices.getCompanyField()
                : FirestoreServices.getUserTitle(),
            builder: (context, fieldSnapshot) {
              if (!fieldSnapshot.hasData || fieldSnapshot.data!.isEmpty) {
                return Center(child: Text("No Data Found"));
              }
              if (!fieldSnapshot.hasData) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              final field = fieldSnapshot.data!;

if (title.startsWith("Employees")) {
  return FutureBuilder<QuerySnapshot>(
    future: FirestoreServices.filterEmployeesByIndustry(field),
    builder: (context, snapshot) {
      if (!snapshot.hasData) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      }

      final docs = snapshot.data!.docs;

      if (docs.isEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Lottie.asset(AppImages.noData, width: 160, height: 160),
              Text(
                "No Employees In Your Industry",
                style: TextStyles.textSize15,
              )
            ],
          ),
        );
      }

      return ListView.separated(
        separatorBuilder: (_, __) =>
            const Divider(color: AppColors.grayColor),
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: docs.length,
        itemBuilder: (context, index) {
          final employee = CareerBuilderModel.fromJson(
            docs[index].data() as Map<String, dynamic>,
          );

          return EmplpyeeCard(employee: employee);
        },
      );
    },
  );
} else {
  return StreamBuilder<QuerySnapshot>(
    stream: FirestoreServices.filterJobsByTitle(field),
    builder: (context, snapshot) {
      if (!snapshot.hasData) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      }

      final docs = snapshot.data!.docs;

      if (docs.isEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Lottie.asset(AppImages.noData, width: 160, height: 160),
              Text(
                "No Jobs Has The Same Title",
                style: TextStyles.textSize15,
              )
            ],
          ),
        );
      }

      return ListView.separated(
        separatorBuilder: (_, __) =>
            const Divider(color: AppColors.grayColor),
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: docs.length,
        itemBuilder: (context, index) {
          final job = JobModel.fromJson(
            docs[index].data() as Map<String, dynamic>,
          );

          return JobCard(
            job: job,
            onTap: () {
              pushTo(
                context,
                Routes.JobDetailsScreen,
                extra: {
                  "job": job,
                  "isUser": true,
                },
              );
            },
          );
        },
      );
    },
  );
}
            },
          ),
        ),
        );
  }
}
