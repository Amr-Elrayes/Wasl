import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:wasl/components/cards/job_card.dart';
import 'package:wasl/core/constants/app_images.dart';
import 'package:wasl/core/job/models/job_model.dart';
import 'package:wasl/core/routes/navigation.dart';
import 'package:wasl/core/routes/routes.dart';
import 'package:wasl/core/utils/colors.dart';
import 'package:wasl/core/utils/text_styles.dart';

class JobsWithRequestesScreen extends StatelessWidget {
  const JobsWithRequestesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final companyId = FirebaseAuth.instance.currentUser?.uid;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Jobs With Applications",
          style: TextStyles.textSize18.copyWith(color: Colors.white),
        ),
        backgroundColor: AppColors.primaryColor,
      ),
      body: companyId == null
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Lottie.asset(AppImages.noData, width: 160, height: 160),
                  Text(
                    "You Don’d Have Any Jobs With Apllications",
                    style: TextStyles.textSize15,
                  )
                ],
              ),
            )
          : StreamBuilder<DocumentSnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('Company')
                  .doc(companyId)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || !snapshot.data!.exists) {
                  return const Center(child: Text("No Company Data Found"));
                }

                final data = snapshot.data!.data() as Map<String, dynamic>;

                final activeJobsJson = List.from(data['activeJobs'] ?? []);

                if (activeJobsJson.isEmpty) {
                  return const Center(child: Text("No Active Jobs"));
                }

                final jobs = activeJobsJson
                    .map((job) => JobModel.fromJson(job))
                    .where((job) => (job.applications ?? []).isNotEmpty)
                    .toList();

                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: jobs.length,
                  itemBuilder: (context, index) {
                    final job = jobs[index];

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: JobCard(
                        job: job,
                        onTap: () {
                          pushTo(context, Routes.requestes,
                              extra: job.applications);
                        },
                      ),
                    );
                  },
                );
              },
            ),
    );
  }
}
