import 'package:wasl/core/job/models/job_model.dart';

class JobState {}

class JobInitialState extends JobState {}

class JobLoadingState extends JobState {}

class JobSuccessState extends JobState {
  JobSuccessState({this.role});
  String? role;
}

class JobFailureState extends JobState {
  final String errorMessage;
  JobFailureState(this.errorMessage);
  
}

class JobListLoadedState extends JobState {
  final List<JobModel> jobs;
  JobListLoadedState(this.jobs);
}
