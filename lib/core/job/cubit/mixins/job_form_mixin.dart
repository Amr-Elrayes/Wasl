import 'package:flutter/material.dart';
import 'package:wasl/core/constants/enums.dart';
import 'package:wasl/core/job/models/list_item_model.dart';

mixin JobFormMixin {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  var describtionController = TextEditingController();
  var requirmentsController = TextEditingController();
  var salaryController = TextEditingController();

  List<ListItemModel> reqskills = [];
  String? title;
  Jobtype? jobType;
  Joblocation? jobLocation;

  void clearForm() {
    describtionController.clear();
    requirmentsController.clear();
    salaryController.clear();

    title = null;
    jobType = null;
    jobLocation = null;

    reqskills.clear();

    formKey = GlobalKey<FormState>();
  }
}