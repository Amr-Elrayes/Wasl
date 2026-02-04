import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wasl/core/constants/enums.dart';
import 'package:wasl/core/job/cubit/job_state.dart';
import 'package:wasl/core/job/models/job_model.dart';
import 'package:wasl/features/auth/models/listtile_item_model.dart';

class JobCubit extends Cubit<JobState> {
  JobCubit() : super(JobInitialState());
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  var describtionController = TextEditingController();
  var requirmentsController = TextEditingController();
  var salaryController = TextEditingController();
  List<ListTileItemModel> reqskills = [];
  String? title;
  Jobtype? jobType;
  Joblocation? jobLocation;

  Future<void> uploadJob({
    required String companyId,
  }) async {
    try {
      emit(JobLoadingState());

      /// 1- generate jobId
      final jobDoc = FirebaseFirestore.instance.collection('jobs').doc();
      final jobId = jobDoc.id;

      /// 2- create job model
      final job = JobModel(
        jobId: jobId,
        title: title,
        location: jobLocation?.name,
        type: jobType?.name,
        salary: double.tryParse(salaryController.text),
        description: describtionController.text,
        requirments: requirmentsController.text,
        reqSkills: reqskills,
      );

      /// 3- batch (عشان يترفعوا مع بعض)
      final batch = FirebaseFirestore.instance.batch();

      /// 4- jobs collection
      batch.set(jobDoc, job.toJson());

      /// 5- company document
      final companyDoc =
          FirebaseFirestore.instance.collection('Company').doc(companyId);

      batch.update(companyDoc, {
        'uploadedJobs': FieldValue.arrayUnion([job.toJson()]),
        'activeJobs': FieldValue.arrayUnion([job.toJson()]),
      });

      /// 6- commit
      await batch.commit();

      emit(JobSuccessState());
    } catch (e) {
      emit(JobFailureState(e.toString()));
    }
  }

void clearForm() {
  describtionController.clear();
  requirmentsController.clear();
  salaryController.clear();

  title = null;
  jobType = null;
  jobLocation = null;

  reqskills.clear();

  formKey = GlobalKey<FormState>();
}


}
