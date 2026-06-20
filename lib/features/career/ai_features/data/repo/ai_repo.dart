import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:wasl/features/career/ai_features/data/models/recommendation_model.dart';
import 'package:wasl/features/career/ai_features/data/models/job_matching_model.dart';
import 'package:wasl/services/firebase/firebase_services.dart';

class AiRepo {
  final Dio _dio = Dio();

Future<List<JobMatchModel>> getJobMatching(PlatformFile file) async {
  final jobs = await FirestoreServices.getJobsForMatching();
  final formData = FormData.fromMap({
    'file': file.bytes != null
        ? MultipartFile.fromBytes(file.bytes!, filename: file.name)
        : await MultipartFile.fromFile(file.path!, filename: file.name),
    'jobs_json': jsonEncode(jobs),
  });

  final response = await _dio.post(
    'https://flamelike-piteously-chu.ngrok-free.dev/jobs/match-dynamic',
    data: formData,
  );

  if (response.statusCode == 200) {
    final List<dynamic> data = response.data['matches'];
    return data.map((e) => JobMatchModel.fromJson(e)).toList();
  } else {
    throw Exception('Job matching failed');
  }
}

Future<RecommendationModel> getFuturePlan(PlatformFile file) async {
    final formData = FormData.fromMap({
      'file': file.bytes != null
          ? MultipartFile.fromBytes(file.bytes!, filename: file.name) 
          : await MultipartFile.fromFile(file.path!, filename: file.name),
    });

    final response = await _dio.post(
      'https://flamelike-piteously-chu.ngrok-free.dev/career/recommend',
      data: formData,
    );

    if (response.statusCode == 200) {
      // نمرر الـ response.data بالكامل لأن الموديل مهيأ لاستقبال الـ Object الرئيسي
      return RecommendationModel.fromJson(response.data);
    } else {
      throw Exception('Future plan failed');
    }
  }
}
