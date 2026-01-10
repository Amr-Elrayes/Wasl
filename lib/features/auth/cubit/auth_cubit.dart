import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wasl/core/constants/user_type_enum.dart';
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
  var jobTitleController = TextEditingController();
  var summaryController = TextEditingController();
  var tileNameController = TextEditingController();
  var locationController = TextEditingController();
  var startDateController = TextEditingController();
  var endDateController = TextEditingController();
  File? pickedImage;
  usertype? selectedUserType;

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
      if (type.toString().split('.').last == "Career") {
        var career = CareerBuilderModel(
            uid: user?.uid,
            name: nameController.text,
            email: emailController.text,
            certificates: [],
            education: [],
            workExperiences: [],
            skills: []);
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

  updateCareerBuilderData() async {
    emit(AuthLoadingState());
    String imgUrl = '';
    var careerBuilder = CareerBuilderModel(
      uid: FirebaseAuth.instance.currentUser?.uid,
      jobTitle: jobTitleController.text,
      summary: summaryController.text,
      image: imgUrl,
    );
    await FirebaseFirestore.instance
        .collection("Career")
        .doc(careerBuilder.uid)
        .update(careerBuilder.updateData());
  }
}
