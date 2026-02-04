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