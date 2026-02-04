import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wasl/core/constants/enums.dart';
import 'package:wasl/core/functions/upload_image.dart';
import 'package:wasl/features/auth/cubit/auth_state.dart';
import 'package:wasl/features/auth/models/career_builder_model.dart';
import 'package:wasl/features/auth/models/company_model.dart';
import 'package:wasl/features/auth/models/listtile_item_model.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthInitialState());
  final formKey = GlobalKey<FormState>();
  var nameController = TextEditingController();
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var confirmpasswordController = TextEditingController();
  var summaryController = TextEditingController();
  var bioController = TextEditingController();
  List<ListTileItemModel> workExperiences = [];
  List<ListTileItemModel> education = [];
  List<ListTileItemModel> certificates = [];
  List<ListTileItemModel> skills = [];
  usertype? selectedUserType;
  String? Industrie;
  String? jobTitle;

  register({required usertype type}) async {
    emit(AuthLoadingState());
    try {
      final credential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );
      User? user = credential.user;
      await user?.updateDisplayName(nameController.text);
      user?.updatePhotoURL(type == usertype.Company ? "Company" : "Career");

      if (type.toString().split('.').last == "Career") {
        var career = CareerBuilderModel(
          uid: user?.uid,
          name: nameController.text,
          email: emailController.text,
        );
        await FirebaseFirestore.instance
            .collection("Career")
            .doc(user?.uid)
            .set(career.toJson());
      } else {
        var company = CompanyModel(
            uid: user?.uid,
            name: nameController.text,
            email: emailController.text);
        await FirebaseFirestore.instance
            .collection("Company")
            .doc(user?.uid)
            .set(company.toJson());
      }
      emit(AuthSuccessState());
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        emit(AuthFailureState('The password provided is too weak.'));
      } else if (e.code == 'email-already-in-use') {
        emit(AuthFailureState('The account already exists for that email.'));
      } else {
        emit(AuthFailureState(
            e.message ?? 'An error occurred, please try again.'));
      }
    } catch (e) {
      emit(AuthFailureState('An error occurred, please try again.'));
    }
  }

  login() async {
    emit(AuthLoadingState());
    try {
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );

      final user = credential.user;
      if (user == null) {
        emit(AuthFailureState('User not found'));
        return;
      }

      final role = await _getUserType(user.uid);

      if (role == null) {
        emit(AuthFailureState('User data not found'));
        return;
      }

      emit(AuthSuccessState(role: role));
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        emit(AuthFailureState('User Not Found'));
      } else if (e.code == 'wrong-password') {
        emit(AuthFailureState('Wrong Password'));
      } else {
        emit(
            AuthFailureState(e.message ?? 'Something Went Wrong , Try Again.'));
      }
    } catch (e) {
      emit(AuthFailureState('Unexpected error occurred'));
    }
  }

  Future<String?> _getUserType(String uid) async {
    final collections = ['Career', 'Company'];

    for (final col in collections) {
      final doc =
          await FirebaseFirestore.instance.collection(col).doc(uid).get();

      if (doc.exists) {
        return col;
      }
    }
    return null;
  }

  Future<List<ListTileItemModel>> getListFromProfile({
    required String fieldName,
  }) async {
    final uid = FirebaseAuth.instance.currentUser!.uid;

    final doc =
        await FirebaseFirestore.instance.collection('Career').doc(uid).get();

    final list = doc.data()?[fieldName] ?? [];

    return List<ListTileItemModel>.from(
      list.map((e) => ListTileItemModel.fromJson(e)),
    );
  }

  updateData(File? pickedImage, usertype user) async {
    emit(AuthLoadingState());
    try {
      if (pickedImage == null) {
        emit(AuthFailureState("No image selected"));
        return;
      }
      String? imgUrl = await updateImageToCloudinary(pickedImage);
      if (imgUrl == null) {
        emit(AuthFailureState("Uplad Image Fails , try Again"));
        return;
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
            skills: skills);
        await FirebaseFirestore.instance
            .collection("Career")
            .doc(careerBuilder.uid)
            .update(careerBuilder.updateData());
        emit(AuthSuccessState());
      } else {
        var Company = CompanyModel(
            uid: FirebaseAuth.instance.currentUser?.uid,
            image: imgUrl,
            bio: bioController.text,
            field: Industrie,
            isProfileCompleted: true);
        await FirebaseFirestore.instance
            .collection("Company")
            .doc(Company.uid)
            .update(Company.updateData());
        emit(AuthSuccessState());
      }
    } on Exception catch (_) {
      emit(AuthFailureState("There is an Error , try again later"));
    }
  }

  void addListItem({
    required String section,
    required String name,
    String? location,
    String? startDate,
    String? endDate,
  }) {
    final item = ListTileItemModel(
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
