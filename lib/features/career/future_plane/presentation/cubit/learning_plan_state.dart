import 'package:wasl/features/career/future_plane/data/models/learning_plan_model.dart';

abstract class LearningPlanState {}

class LearningPlanStateInitial extends LearningPlanState {}

class LearningPlanStateLoading extends LearningPlanState {}

class LearningPlanStateSuccess extends LearningPlanState {
  final LearningPlanModel plan;
  LearningPlanStateSuccess(this.plan);
}

class LearningPlanStateError extends LearningPlanState {
  final String message;
  LearningPlanStateError(this.message);
}