import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:wasl/features/career/future_plane/data/models/learning_plan_model.dart';

class LearningPlanRepo {
  final Dio _dio = Dio();

  Future<LearningPlanModel> getLearningPlan(PlatformFile file, String targetRole) async {
    final formData = FormData.fromMap({
      'file': file.bytes != null
          ? MultipartFile.fromBytes(file.bytes!, filename: file.name)
          : await MultipartFile.fromFile(file.path!, filename: file.name),
      'target_role': targetRole,
    });

    final response = await _dio.post(
      'https://flamelike-piteously-chu.ngrok-free.dev/learning/plan-from-cv',
      data: formData,
    );

    if (response.statusCode == 200) {
      return LearningPlanModel.fromJson(response.data);
    } else {
      throw Exception('Learning plan failed');
    }
  }
}