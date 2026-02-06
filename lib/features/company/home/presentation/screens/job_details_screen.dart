import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wasl/core/job/cubit/job_cubit.dart';
import 'package:wasl/core/job/models/job_model.dart';
import 'package:wasl/core/routes/navigation.dart';
import 'package:wasl/core/routes/routes.dart';
import 'package:wasl/core/utils/colors.dart';
import 'package:wasl/core/utils/text_styles.dart';

class jobDetailsScreen extends StatefulWidget {
  const jobDetailsScreen({super.key, required this.job});
  final JobModel job;

  @override
  State<jobDetailsScreen> createState() => _jobDetailsScreenState();
}

class _jobDetailsScreenState extends State<jobDetailsScreen> {
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
          if (isCompany)
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.edit, color: Colors.white),
                  onPressed: () {
                    pushTo(
                      context,
                      Routes.addJob,
                      extra: widget.job,
                    );
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.white),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (_) => AlertDialog(
                        title: const Text("Delete Job"),
                        content: const Text(
                            "Are you sure you want to delete this job?"),
                        actions: [
                          TextButton(
                            onPressed: () => pop(context),
                            child: const Text("Cancel"),
                          ),
                          TextButton(
                            onPressed: () {
                              final cubit = context.read<JobCubit>();

                              Navigator.pop(context); // اقفل الدايلوج
                              cubit.deleteJob(widget.job.jobId);
                              Navigator.pop(context); // ارجع Total
                            },
                            child: const Text(
                              "Delete",
                              style: TextStyle(color: Colors.red),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
        ],
      ),
      body: Column(),
    );
  }
}
