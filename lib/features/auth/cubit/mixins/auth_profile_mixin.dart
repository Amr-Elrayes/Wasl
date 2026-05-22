import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wasl/core/constants/enums.dart';
import 'package:wasl/core/functions/upload_image.dart';
import 'package:wasl/core/job/models/list_item_model.dart';
import 'package:wasl/features/auth/cubit/auth_state.dart';
import 'package:wasl/features/auth/cubit/mixins/auth_form_mixin.dart';
import 'package:wasl/features/auth/models/career_builder_model.dart';
import 'package:wasl/features/auth/models/company_model.dart';

mixin AuthProfileMixin on Cubit<AuthState>, AuthFormMixin {
  Future<List<ListItemModel>> getListFromProfile({
    required String fieldName,
  }) async {
    final uid = FirebaseAuth.instance.currentUser!.uid;

    final doc =
        await FirebaseFirestore.instance.collection('Career').doc(uid).get();

    final list = doc.data()?[fieldName] ?? [];

    return List<ListItemModel>.from(
      list.map((e) => ListItemModel.fromJson(e)),
    );
  }

  updateData(File? pickedImage, usertype user) async {
    emit(AuthLoadingState());

    try {
      String? imgUrl;

      if (pickedImage != null) {
        imgUrl = await updateImageToCloudinary(pickedImage);

        if (imgUrl == null) {
          emit(AuthFailureState("Upload Image Failed , Try Again"));
          return;
        }
      }

      if (user == usertype.Career) {
        var careerBuilder = CareerBuilderModel(
          uid: FirebaseAuth.instance.currentUser?.uid,
          jobTitle: jobTitle,
          summary: summaryController.text,
          image: imgUrl,
          field: Industrie,
          isProfileCompleted: true,
          workExperiences: workExperiences,
          education: education,
          certificates: certificates,
          skills: skills,
        );

        await FirebaseFirestore.instance
            .collection("Career")
            .doc(careerBuilder.uid)
            .update(careerBuilder.updateData());

        emit(AuthSuccessState());
      } else {
        var company = CompanyModel(
          uid: FirebaseAuth.instance.currentUser?.uid,
          image: imgUrl,
          bio: bioController.text,
          field: Industrie,
          isProfileCompleted: true,
        );

        await FirebaseFirestore.instance
            .collection("Company")
            .doc(company.uid)
            .update(company.updateData());

        emit(AuthSuccessState());
      }
    } catch (e) {
      emit(AuthFailureState("There is an Error , try again later"));
    }
  }
}
