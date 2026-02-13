// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:wasl/components/buttons/custom_buttom.dart';
import 'package:wasl/core/functions/snackbar.dart';
import 'package:wasl/core/job/cubit/job_cubit.dart';
import 'package:wasl/core/job/models/job_model.dart';
import 'package:wasl/core/routes/navigation.dart';
import 'package:wasl/core/routes/routes.dart';
import 'package:wasl/core/utils/colors.dart';
import 'package:wasl/core/utils/text_styles.dart';
import 'package:wasl/features/auth/models/career_builder_model.dart';
import 'package:wasl/features/company/home/presentation/widgets/skills_wrap.dart';

class jobDetailsScreen extends StatefulWidget {
  const jobDetailsScreen({super.key, required this.job, required this.isUser});
  final JobModel job;
  final bool isUser;
  @override
  State<jobDetailsScreen> createState() => _jobDetailsScreenState();
}

class _jobDetailsScreenState extends State<jobDetailsScreen> {
  bool isLoading = false;
  List<Widget> _buildCompanyActions(BuildContext context) {
    final cubit = context.read<JobCubit>();

    if (widget.job.status == "Active") {
      return _activeJobActions(context, cubit);
    } else {
      return _terminatedJobActions(context, cubit);
    }
  }

  List<Widget> _activeJobActions(
    BuildContext context,
    JobCubit cubit,
  ) {
    return [
      IconButton(
        icon: const Icon(Icons.edit, color: Colors.white),
        onPressed: () {
          pushTo(context, Routes.addJob, extra: widget.job);
        },
      ),
      IconButton(
        icon: const Icon(Icons.delete, color: Colors.white),
        onPressed: () {
          _showTerminateDialog(context, cubit);
        },
      ),
    ];
  }

  List<Widget> _terminatedJobActions(
    BuildContext context,
    JobCubit cubit,
  ) {
    return [
      IconButton(
        icon: const Icon(Icons.restore, color: Colors.white),
        onPressed: () {
          _showRestoreDialog(context, cubit);
        },
      ),
      IconButton(
        icon: const Icon(Icons.delete_forever, color: Colors.white),
        onPressed: () {
          _showDeleteForeverDialog(context, cubit);
        },
      ),
    ];
  }

  void _showTerminateDialog(BuildContext context, JobCubit cubit) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Terminate Job"),
        content: const Text(
          "This job will be moved to terminated jobs.",
        ),
        actions: [
          TextButton(
            onPressed: () => pop(context),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              pop(context);
              cubit.terminateJobFromActive(widget.job.jobId);
              pop(context); // رجوع للتوتال
            },
            child: const Text("Terminate"),
          ),
        ],
      ),
    );
  }

  void _showRestoreDialog(BuildContext context, JobCubit cubit) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Restore Job"),
        content: const Text(
          "This job will become active again.",
        ),
        actions: [
          TextButton(
            onPressed: () => pop(context),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              pop(context);
              cubit.restoreJob(widget.job.jobId);
              pop(context);
            },
            child: const Text("Restore"),
          ),
        ],
      ),
    );
  }

  void _showDeleteForeverDialog(BuildContext context, JobCubit cubit) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Delete Job Permanently"),
        content: const Text(
          "This action cannot be undone.",
        ),
        actions: [
          TextButton(
            onPressed: () => pop(context),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              pop(context);
              cubit.deleteJobPermanently(widget.job.jobId);
              pop(context);
            },
            child: const Text(
              "Delete",
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  bool isCompany = false;
  @override
  void initState() {
    super.initState();
    checkUserRole();
  }

  Future<void> checkUserRole() async {
    final uid = FirebaseAuth.instance.currentUser!.uid;

    final doc =
        await FirebaseFirestore.instance.collection('Company').doc(uid).get();

    if (doc.exists) {
      setState(() {
        isCompany = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: widget.isUser
          ? Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: customButtom(
                txt: isLoading ? "Applying..." : "Apply",
                onPressed: isLoading ? null : applyForJob,
              ),
            )
          : const SizedBox(),
      appBar: AppBar(
        title: Text(
          widget.job.title!,
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
        centerTitle: false,
        actions: [
          if (isCompany) ..._buildCompanyActions(context),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 20, right: 20, top: 30),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    "Company:  ",
                    style: TextStyles.textSize18.copyWith(
                        color: AppColors.primaryColor,
                        fontWeight: FontWeight.bold),
                  ),
                  Text(widget.job.company!,
                      style: TextStyles.textSize18.copyWith(
                          color: AppColors.primaryColor,
                          fontWeight: FontWeight.bold)),
                ],
              ),
              const Gap(20),
              Row(
                children: [
                  Text(
                    "Location:  ",
                    style: TextStyles.textSize18.copyWith(
                        color: AppColors.primaryColor,
                        fontWeight: FontWeight.bold),
                  ),
                  Text(widget.job.location!,
                      style: TextStyles.textSize18.copyWith(
                          color: AppColors.primaryColor,
                          fontWeight: FontWeight.bold)),
                ],
              ),
              const Gap(20),
              Row(
                children: [
                  Text(
                    "Type:  ",
                    style: TextStyles.textSize18.copyWith(
                        color: AppColors.primaryColor,
                        fontWeight: FontWeight.bold),
                  ),
                  Text(widget.job.type!,
                      style: TextStyles.textSize18.copyWith(
                          color: AppColors.primaryColor,
                          fontWeight: FontWeight.bold)),
                ],
              ),
              const Gap(20),
              Row(
                children: [
                  Text(
                    "Salary:  ",
                    style: TextStyles.textSize18.copyWith(
                        color: AppColors.primaryColor,
                        fontWeight: FontWeight.bold),
                  ),
                  Text("${widget.job.salary.toString()} \$/Month",
                      style: TextStyles.textSize18.copyWith(
                          color: AppColors.primaryColor,
                          fontWeight: FontWeight.bold)),
                ],
              ),
              const Gap(40),
              Text(
                "Descrption:  ",
                style: TextStyles.textSize18.copyWith(
                    color: AppColors.primaryColor, fontWeight: FontWeight.bold),
              ),
              const Gap(10),
              Text(widget.job.description!,
                  style: TextStyles.textSize15.copyWith(
                      color: AppColors.darkColor, fontWeight: FontWeight.bold)),
              const Gap(40),
              Text(
                "Requirments:  ",
                style: TextStyles.textSize18.copyWith(
                    color: AppColors.primaryColor, fontWeight: FontWeight.bold),
              ),
              const Gap(10),
              Text(widget.job.requirments!,
                  style: TextStyles.textSize15.copyWith(
                      color: AppColors.darkColor, fontWeight: FontWeight.bold)),
              const Gap(40),
              Text(
                "Requirments Skills:  ",
                style: TextStyles.textSize18.copyWith(
                    color: AppColors.primaryColor, fontWeight: FontWeight.bold),
              ),
              const Gap(10),
              SkillsWrap(job: widget.job),
              const Gap(80)
            ],
          ),
        ),
      ),
    );
  }

  Future<void> applyForJob() async {
    if (isLoading) return;

    setState(() {
      isLoading = true;
    });

    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      showSnakBar(context, Colors.red, "Please login first");
      setState(() => isLoading = false);
      return;
    }

    final uid = user.uid;

    final firestore = FirebaseFirestore.instance;

    final userDoc = firestore.collection("Career").doc(uid);
    final jobDoc = firestore.collection("jobs").doc(widget.job.jobId);
    final companyDoc =
        firestore.collection("Company").doc(widget.job.companyId);

    final userSnapshot = await userDoc.get();
    final companySnapshot = await companyDoc.get();

    if (!userSnapshot.exists) {
      showSnakBar(context, Colors.red, "User data not found");
      setState(() => isLoading = false);
      return;
    }

    if (!companySnapshot.exists) {
      showSnakBar(context, Colors.red, "Company data not found");
      setState(() => isLoading = false);
      return;
    }

    final userData = CareerBuilderModel.fromJson(userSnapshot.data()!);

    final alreadyApplied =
        (userData.appliedJobs ?? []).contains(widget.job.jobId);

    if (alreadyApplied) {
      showSnakBar(context, Colors.red, "You already applied");
      setState(() => isLoading = false);
      return;
    }

    final batch = firestore.batch();

    /// 1️⃣ Update Career
    batch.update(userDoc, {
      "appliedJobs": FieldValue.arrayUnion([widget.job.jobId])
    });

    /// 2️⃣ Update jobs collection
    batch.update(jobDoc, {
      "applications": FieldValue.arrayUnion([uid])
    });

    /// 3️⃣ Update Company.activeJobs
    List activeJobs = List.from(companySnapshot.data()!['activeJobs'] ?? []);

    final aindex =
        activeJobs.indexWhere((job) => job['jobId'] == widget.job.jobId);

    if (aindex != -1) {
      List applications = List.from(activeJobs[aindex]['applications'] ?? []);

      if (!applications.contains(uid)) {
        applications.add(uid);
      }

      activeJobs[aindex]['applications'] = applications;

      batch.update(companyDoc, {
        "activeJobs": activeJobs,
      });
    }

    /// 3️⃣ Update Company.uploadedJobs
    ///
    List uploadedJobs =
        List.from(companySnapshot.data()!['uploadedJobs'] ?? []);

    final uindex =
        uploadedJobs.indexWhere((job) => job['jobId'] == widget.job.jobId);

    if (uindex != -1) {
      List applications = List.from(uploadedJobs[uindex]['applications'] ?? []);

      if (!applications.contains(uid)) {
        applications.add(uid);
      }

      uploadedJobs[uindex]['applications'] = applications;

      batch.update(companyDoc, {
        "uploadedJobs": uploadedJobs,
      });
    }

    /// 3️⃣ Update Company.terminatedJobs
    List terminatedJobs =
        List.from(companySnapshot.data()!['terminatedJobs'] ?? []);

    final tindex =
        terminatedJobs.indexWhere((job) => job['jobId'] == widget.job.jobId);

    if (tindex != -1) {
      List applications =
          List.from(terminatedJobs[tindex]['applications'] ?? []);

      if (!applications.contains(uid)) {
        applications.add(uid);
      }

      terminatedJobs[tindex]['applications'] = applications;

      batch.update(companyDoc, {
        "terminatedJobs": terminatedJobs,
      });
    }

    await batch.commit();

    if (!mounted) return;

    showSnakBar(context, Colors.green, "Applied Successfully");

    setState(() {
      isLoading = false;
    });
  }
}
