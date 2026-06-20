import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wasl/features/career/ai_features/data/models/recommendation_model.dart';
import 'package:wasl/features/career/ai_features/data/models/job_matching_model.dart';
import 'package:wasl/features/career/ai_features/data/repo/ai_repo.dart';
import 'ai_state.dart';

class AiCubit extends Cubit<AiState> {
  final AiRepo _repo = AiRepo();

  AiCubit() : super(AiInitial());

  Future<void> analyzeCV(PlatformFile file) async {
    emit(AiLoading());
    try {
      // تشغيل العمليتين في نفس الوقت لسرعة الاستجابة
      final matchesFuture = _repo.getJobMatching(file);
      final futurePlanFuture = _repo.getFuturePlan(file);

      final results = await Future.wait([matchesFuture, futurePlanFuture]);

      emit(AiSuccess(
        matches: results[0] as List<JobMatchModel>,
        futurePlan: results[1] as RecommendationModel,
      ));
} catch (e) {
  if (e is DioException) {
    print('TYPE: ${e.type}'); 
    print('MESSAGE: ${e.message}');
    print('RESPONSE DATA: ${e.response?.data}');
    print('RESPONSE STATUS: ${e.response?.statusCode}');
  }
  print('ERROR: $e');
  emit(AiError(e.toString()));
}
  }

  void reset() => emit(AiInitial());
}