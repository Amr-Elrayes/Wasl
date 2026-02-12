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

class JobsInTitleScreen extends StatelessWidget {
  const JobsInTitleScreen({super.key, required this.title});
  final String title;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          title,
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
        child: StreamBuilder<QuerySnapshot>(
  stream: FirestoreServices.filterJobsByTitle(title),
  builder: (context, snapshot) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
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
)
      ),
    );
  }
}
