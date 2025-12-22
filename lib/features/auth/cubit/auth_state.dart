class AuthState {}

class AuthInitialState extends AuthState {}

class AuthLoadingState extends AuthState {}

class AuthSuccessState extends AuthState {
  AuthSuccessState();
}

class AuthFailureState extends AuthState {
  final String errorMessage;
  AuthFailureState(this.errorMessage);
}