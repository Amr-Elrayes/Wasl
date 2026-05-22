import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wasl/core/job/cubit/job_state.dart';
import 'package:wasl/core/job/cubit/mixins/job_form_mixin.dart';
import 'package:wasl/core/job/models/job_model.dart';
import 'package:wasl/features/auth/models/company_model.dart';

mixin JobUploadMixin on Cubit<JobState>, JobFormMixin {

  Future<void> uploadJob({required String companyId}) async {
    try {
      emit(JobLoadingState());

      final jobDoc = FirebaseFirestore.instance.collection('jobs').doc();
      final jobId = jobDoc.id;
      final companyDoc =
          FirebaseFirestore.instance.collection('Company').doc(companyId);
      final companySnapshot = await companyDoc.get();
      final Company =
          CompanyModel.fromJson(companySnapshot.data() as Map<String, dynamic>);

      final job = JobModel(
        jobId: jobId,
        title: title,
        company: FirebaseAuth.instance.currentUser?.displayName,
        companyImg: Company.image,
        companyId: Company.uid,
        location: jobLocation?.name,
        type: jobType?.name,
        salary: double.tryParse(salaryController.text),
        description: describtionController.text,
        requirments: requirmentsController.text,
        reqSkills: reqskills,
        applications: [],
      );

      final batch = FirebaseFirestore.instance.batch();

      batch.set(jobDoc, job.toJson());
      batch.update(companyDoc, {
        'uploadedJobs': FieldValue.arrayUnion([job.toJson()]),
        'activeJobs': FieldValue.arrayUnion([job.toJson()]),
      });

      await batch.commit();

      emit(JobSuccessState());
    } catch (e) {
      emit(JobFailureState(e.toString()));
    }
  }

  Future<void> updateJob({
    required String companyId,
    required String jobId,
  }) async {
    try {
      emit(JobLoadingState());

      final updatedJob = JobModel(
        jobId: jobId,
        title: title,
        company: FirebaseAuth.instance.currentUser?.displayName,
        location: jobLocation?.name,
        type: jobType?.name,
        salary: double.tryParse(salaryController.text),
        description: describtionController.text,
        requirments: requirmentsController.text,
        reqSkills: reqskills,
        status: "Active",
      );

      final companyDoc =
          FirebaseFirestore.instance.collection('Company').doc(companyId);

      final snapshot = await companyDoc.get();
      final data = snapshot.data()!;

      List uploadedJobs = List.from(data['uploadedJobs'] ?? []);
      List activeJobs = List.from(data['activeJobs'] ?? []);
      List terminatedJobs = List.from(data['terminatedJobs'] ?? []);

      List updateList(List list) {
        final index = list.indexWhere((j) => j['jobId'] == jobId);
        if (index != -1) {
          list[index] = updatedJob.toJson();
        }
        return list;
      }

      uploadedJobs = updateList(uploadedJobs);
      activeJobs = updateList(activeJobs);
      terminatedJobs = updateList(terminatedJobs);

      await companyDoc.update({
        'uploadedJobs': uploadedJobs,
        'activeJobs': activeJobs,
        'terminatedJobs': terminatedJobs,
      });

      final jobDocRef =
          FirebaseFirestore.instance.collection('jobs').doc(jobId);

      final jobSnapshot = await jobDocRef.get();
      if (jobSnapshot.exists) {
        await jobDocRef.update(updatedJob.toJson());
      }

      emit(JobSuccessState());
    } catch (e) {
      emit(JobFailureState(e.toString()));
    }
  }
}