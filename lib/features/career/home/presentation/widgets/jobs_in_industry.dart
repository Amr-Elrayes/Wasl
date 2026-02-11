import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:wasl/components/cards/job_card.dart';
import 'package:wasl/core/constants/app_images.dart';
import 'package:wasl/core/job/models/job_model.dart';
import 'package:wasl/core/utils/colors.dart';
import 'package:wasl/core/utils/text_styles.dart';
import 'package:wasl/services/firebase/firebase_services.dart';

class JobsInIndustry extends StatelessWidget {
  const JobsInIndustry({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: FirestoreServices.getUserTitle(),
      builder: (context, fieldSnapshot) {
        if (!fieldSnapshot.hasData) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        final userTitle = fieldSnapshot.data!;

        return FutureBuilder<QuerySnapshot>(
          future: FirestoreServices.filterJobsByTitle(userTitle),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            if (snapshot.data!.docs.isEmpty) {
              return Center(
                child: Column(
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
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                final job = JobModel.fromJson(
                  snapshot.data!.docs[index].data() as Map<String, dynamic>,
                );
                return JobCard(
                  job: job,
                  onTap: () {},
                );
              },
            );
          },
        );
      },
    );
  }
}
