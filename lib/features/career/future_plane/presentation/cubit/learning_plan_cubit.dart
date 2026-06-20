import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wasl/features/career/future_plane/data/repo/learning_plan_repo.dart';
import 'learning_plan_state.dart';

class LearningPlanCubit extends Cubit<LearningPlanState> {
  final LearningPlanRepo _repo = LearningPlanRepo();

  LearningPlanCubit() : super(LearningPlanStateInitial());

  Future<void> getLearningPlane(PlatformFile file, String targetRole) async {
    emit(LearningPlanStateLoading());
    try {
      final plan = await _repo.getLearningPlan(file, targetRole);
      emit(LearningPlanStateSuccess(plan));
    } catch (e) {
      if (e is DioException) {
        print('TYPE: ${e.type}');
        print('MESSAGE: ${e.message}');
        print('RESPONSE DATA: ${e.response?.data}');
        print('RESPONSE STATUS: ${e.response?.statusCode}');
      }
      print('ERROR: $e');
      emit(LearningPlanStateError(e.toString()));
    }
  }

  void reset() => emit(LearningPlanStateInitial());
}