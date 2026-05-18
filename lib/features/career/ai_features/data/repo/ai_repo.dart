import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:wasl/features/career/ai_features/data/models/future_plane_model.dart';
import 'package:wasl/features/career/ai_features/data/models/job_matching_model.dart';
import 'package:wasl/services/firebase/firebase_services.dart';

class AiRepo {
  final Dio _dio = Dio();

Future<List<JobMatchModel>> getJobMatching(PlatformFile file) async {
  final jobs = await FirestoreServices.getJobsForMatching();

  final formData = FormData.fromMap({
    'cv_file': file.bytes != null
        ? MultipartFile.fromBytes(file.bytes!, filename: file.name)
        : await MultipartFile.fromFile(file.path!, filename: file.name),
    'jobs': jsonEncode(jobs),
  });

  final response = await _dio.post(
    'JOB_MATCHING_ENDPOINT',
    data: formData,
  );

  if (response.statusCode == 200) {
    final List<dynamic> data = response.data['matches'];
    return data.map((e) => JobMatchModel.fromJson(e)).toList();
  } else {
    throw Exception('Job matching failed');
  }
}

Future<List<FuturePlanModel>> getFuturePlan(PlatformFile file) async {
  final formData = FormData.fromMap({
    'cv_file': file.bytes != null
        ? MultipartFile.fromBytes(file.bytes!, filename: file.name)
        : await MultipartFile.fromFile(file.path!, filename: file.name),
  });

  final response = await _dio.post(
    'FUTURE_PLAN_ENDPOINT',
    data: formData,
  );

  if (response.statusCode == 200) {
    final List<dynamic> data = response.data['future_plan'];
    return data.map((e) => FuturePlanModel.fromJson(e)).toList();
  } else {
    throw Exception('Future plan failed');
  }
}
}