import 'package:wasl/features/career/ai_features/data/models/future_plane_model.dart';
import 'package:wasl/features/career/ai_features/data/models/job_matching_model.dart';

abstract class AiState {}

class AiInitial extends AiState {}

class AiLoading extends AiState {}

class AiSuccess extends AiState {
  final List<JobMatchModel> matches;
  final List<FuturePlanModel> futurePlan;

  AiSuccess({
    required this.matches,
    required this.futurePlan,
  });
}

class AiError extends AiState {
  final String message;
  AiError(this.message);
}