import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:lottie/lottie.dart';
import 'package:rxdart/rxdart.dart';
import 'package:wasl/components/cards/job_card.dart';
import 'package:wasl/core/constants/app_images.dart';
import 'package:wasl/core/job/models/job_model.dart';
import 'package:wasl/core/routes/navigation.dart';
import 'package:wasl/core/routes/routes.dart';
import 'package:wasl/core/utils/colors.dart';
import 'package:wasl/core/utils/text_styles.dart';

class AppliedSavedJobsScreen extends StatelessWidget {
  const AppliedSavedJobsScreen({
    super.key,
    required this.userId,
  });

  final String userId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Applied Jobs",
          style:
              TextStyles.textSize18.copyWith(color: Colors.white, fontSize: 20),
        ),
        backgroundColor: AppColors.primaryColor,
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('Career')
            .doc(userId)
            .snapshots(),
        builder: (context, userSnapshot) {
          if (userSnapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!userSnapshot.hasData || !userSnapshot.data!.exists) {
            return  Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Lottie.asset(AppImages.noData, width: 160, height: 160),
                  Text(
                    "User not Found",
                    style: TextStyles.textSize15,
                  )
                ],
              ),
            );
          }

          final data = userSnapshot.data!.data() as Map<String, dynamic>;

          final List<String> appliedJobs =
              List<String>.from(data['appliedJobs'] ?? []);

          if (appliedJobs.isEmpty) {
            return  Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Lottie.asset(AppImages.noData, width: 160, height: 160),
                  Text(
                    "You Haven’t Apllied to Any Job Yet",
                    style: TextStyles.textSize15,
                  )
                ],
              ),
            );
          }

          return StreamBuilder<List<JobModel>>(
            stream: _jobsStream(appliedJobs),
            builder: (context, jobsSnapshot) {
              if (jobsSnapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (!jobsSnapshot.hasData || jobsSnapshot.data!.isEmpty) {
                return  Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Lottie.asset(AppImages.noData, width: 160, height: 160),
                  Text(
                    "No Jobs Found",
                    style: TextStyles.textSize15,
                  )
                ],
              ),
            );
              }

              final jobs = jobsSnapshot.data!;

              return ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: jobs.length,
                separatorBuilder: (context, index) {
                  return const Gap(20);
                },
                itemBuilder: (context, index) {
                  return JobCard(
                    job: jobs[index],
                    onTap: () {
                      pushTo(context, Routes.JobDetailsScreen, extra: {
                        "job": jobs[index],
                        "isUser": false,
                      });
                    },
                  );
                },
              );
            },
          );
        },
      ),
    );
  }

  Stream<List<JobModel>> _jobsStream(List<String> jobIds) {
    final chunks = _chunkList(jobIds, 10);

    final streams = chunks.map((chunk) {
      return FirebaseFirestore.instance
          .collection('jobs')
          .where(FieldPath.documentId, whereIn: chunk)
          .snapshots();
    }).toList();

    if (streams.length == 1) {
      return streams.first.map((snapshot) {
        return snapshot.docs
            .map((doc) => JobModel.fromJson(doc.data() as Map<String, dynamic>))
            .toList();
      });
    }

    return CombineLatestStream.list(streams).map((snapshots) {
      final allDocs = snapshots.expand((snapshot) => snapshot.docs).toList();

      return allDocs
          .map((doc) => JobModel.fromJson(doc.data() as Map<String, dynamic>))
          .toList();
    });
  }

  List<List<String>> _chunkList(List<String> list, int size) {
    final chunks = <List<String>>[];
    for (var i = 0; i < list.length; i += size) {
      chunks.add(
        list.sublist(
          i,
          i + size > list.length ? list.length : i + size,
        ),
      );
    }
    return chunks;
  }
}
