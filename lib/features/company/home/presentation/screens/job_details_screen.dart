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
      body: Column(),
    );
  }
}





