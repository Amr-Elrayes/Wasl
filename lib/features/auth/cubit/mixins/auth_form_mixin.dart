import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wasl/core/constants/enums.dart';
import 'package:wasl/core/job/models/list_item_model.dart';
import 'package:wasl/features/auth/cubit/auth_state.dart';

mixin AuthFormMixin on Cubit<AuthState> {
  final formKey = GlobalKey<FormState>();
  var nameController = TextEditingController();
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var confirmpasswordController = TextEditingController();
  var summaryController = TextEditingController();
  var bioController = TextEditingController();

  List<ListItemModel> workExperiences = [];
  List<ListItemModel> education = [];
  List<ListItemModel> certificates = [];
  List<ListItemModel> skills = [];

  usertype? selectedUserType;
  String? Industrie;
  String? jobTitle;

  void addListItem({
    required String section,
    required String name,
    String? location,
    String? startDate,
    String? endDate,
  }) {
    final item = ListItemModel(
      name: name.trim(),
      location: location?.trim(),
      startDate: startDate?.trim(),
      endDate: endDate?.trim(),
    );

    switch (section) {
      case "Work Experience":
        workExperiences.add(item);
        break;
      case "Education":
        education.add(item);
        break;
      case "Certificates":
        certificates.add(item);
        break;
      case "Skills":
        skills.add(item);
        break;
    }

    emit(LocalListUpdatedState());
  }
}