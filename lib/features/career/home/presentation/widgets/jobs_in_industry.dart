import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:wasl/components/cards/job_card.dart';
import 'package:wasl/core/constants/app_images.dart';
import 'package:wasl/core/job/models/job_model.dart';
import 'package:wasl/core/routes/navigation.dart';
import 'package:wasl/core/routes/routes.dart';
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

        return StreamBuilder<QuerySnapshot>(
          stream: FirestoreServices.filterJobsByTitle(userTitle),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return Center(
                child: Column(
                  children: [
                    Lottie.asset(AppImages.noData,
                        width: 160, height: 160),
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
                final doc = snapshot.data!.docs[index];

                final job = JobModel.fromJson(
                  doc.data() as Map<String, dynamic>,
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
      },
    );
  }
}

