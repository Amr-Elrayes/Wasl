import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wasl/core/job/cubit/job_state.dart';
import 'package:wasl/core/job/cubit/mixins/job_form_mixin.dart';
import 'package:wasl/core/job/cubit/mixins/job_management_mixin.dart';
import 'package:wasl/core/job/cubit/mixins/job_upload_mixin.dart';

class JobCubit extends Cubit<JobState>
    with JobFormMixin, JobUploadMixin, JobManagementMixin {
  JobCubit() : super(JobInitialState());

  @override
  Future<void> close() {
    companySubscription?.cancel();
    return super.close();
  }
}