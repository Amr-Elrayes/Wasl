import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wasl/core/constants/user_type_enum.dart';
import 'package:wasl/features/auth/cubit/auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthInitialState());
  final formKey = GlobalKey<FormState>();
  var nameController = TextEditingController();
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var confirmpasswordController = TextEditingController();
  usertype?selectedUserType;

  register({required usertype type}) async {
    emit(AuthLoadingState());
try {
  final credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
    email: emailController.text,
    password: passwordController.text,
  );
  User? user = credential.user;
  await user?.updateDisplayName(nameController.text);
  FirebaseFirestore.instance.collection('users').doc(user?.uid).set({
    'uid': user?.uid,
    'name': nameController.text,
    'email': emailController.text,
    'userType': type.toString().split('.').last,
  });
  emit(AuthSuccessState());
} on FirebaseAuthException catch (e) {
  if (e.code == 'weak-password') {
    emit(AuthFailureState('The password provided is too weak.'));
  } else if (e.code == 'email-already-in-use') {
    emit(AuthFailureState('The account already exists for that email.'));
  } else {
    emit(AuthFailureState(e.message ?? 'An error occurred, please try again.'));
  }
} catch (e) {
  emit(AuthFailureState('An error occurred, please try again.'));}
  }

  login() async {
    emit(AuthLoadingState());
    // try {
    //   final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
    //     email: emailController.text,
    //     password: passwordController.text,
    //   );
    //   emit(AuthSuccessState(role: credential.user?.photoURL));
    // } on FirebaseAuthException catch (e) {
    //   if (e.code == 'user-not-found') {
    //     emit(AuthFailureState('لا يوجد مستخدم بهذا الايميل.'));
    //   } else if (e.code == 'wrong-password') {
    //     emit(AuthFailureState('كلمة المرور غير صحيحة.'));
    //   } else {
    //     emit(AuthFailureState(e.message ?? 'حدث خطأ ما، حاول مرة أخرى.'));
    //   }
    // }
  }
}