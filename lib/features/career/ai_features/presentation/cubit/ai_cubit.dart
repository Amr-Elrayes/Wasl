import 'package:file_picker/file_picker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wasl/features/career/ai_features/data/repo/ai_repo.dart';
import 'ai_state.dart';

class AiCubit extends Cubit<AiState> {
  final AiRepo _repo = AiRepo();

  AiCubit() : super(AiInitial());

Future<void> analyzeCV(PlatformFile file) async {
  emit(AiLoading());
  try {
    // شغّل الاتنين في نفس الوقت
    final matchesFuture = _repo.getJobMatching(file);
    final futurePlanFuture = _repo.getFuturePlan(file);

    // استنى الاتنين مع بعض
    final matches = await matchesFuture;
    final futurePlan = await futurePlanFuture;

    emit(AiSuccess(
      matches: matches,
      futurePlan: futurePlan,
    ));
  } catch (e) {
    emit(AiError(e.toString()));
  }
}
  void reset() => emit(AiInitial());
}