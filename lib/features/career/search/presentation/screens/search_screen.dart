import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:lottie/lottie.dart';
import 'package:wasl/components/cards/job_card.dart';
import 'package:wasl/components/inputs/search_field.dart';
import 'package:wasl/core/constants/app_images.dart';
import 'package:wasl/core/job/models/job_model.dart';
import 'package:wasl/core/routes/navigation.dart';
import 'package:wasl/core/routes/routes.dart';
import 'package:wasl/core/utils/colors.dart';
import 'package:wasl/core/utils/text_styles.dart';
import 'package:wasl/services/firebase/firebase_services.dart';

class SearchScreen extends StatefulWidget {
  SearchScreen({super.key, required this.searchKey, required this.controller});
  final TextEditingController controller;

  final String searchKey;

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  late TextEditingController controller;
  String searchKey = "";

  @override
  void initState() {
    super.initState();
    controller = TextEditingController();

    controller.addListener(() {
      setState(() {
        searchKey = controller.text.trim();
      });
    });
  }

  Stream<QuerySnapshot> getJobs() {
    if (searchKey.isEmpty) {
      return FirestoreServices.getAllJobs();
    } else {
      return FirestoreServices.getJobsByTitle(searchKey);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Search By Title",
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
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Searchfield(controller: controller, isIdel: false),
            const SizedBox(height: 20),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: getJobs(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final docs = snapshot.data!.docs;

                  if (docs.isEmpty) {
                    return const EmptyWidget();
                  }

                  return ListView.separated(
                    separatorBuilder: (context, index) {
                      return const Gap(20);
                    },
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
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class EmptyWidget extends StatelessWidget {
  const EmptyWidget({super.key});

  @override
  Widget build(BuildContext context) {
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
}
