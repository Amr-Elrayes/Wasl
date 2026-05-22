import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wasl/features/auth/cubit/auth_state.dart';
import 'package:wasl/features/auth/cubit/mixins/auth_form_mixin.dart';
import 'package:wasl/features/auth/cubit/mixins/auth_operations_mixin.dart';
import 'package:wasl/features/auth/cubit/mixins/auth_profile_mixin.dart';

class AuthCubit extends Cubit<AuthState>
    with AuthFormMixin, AuthOperationsMixin, AuthProfileMixin {
  AuthCubit() : super(AuthInitialState());
}