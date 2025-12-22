// ignore_for_file: non_constant_identifier_names

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:wasl/features/auth/cubit/auth_cubit.dart';
import 'package:wasl/features/auth/presentation/complete_profile/builder_complete_profile_screen.dart';
import 'package:wasl/features/auth/presentation/complete_profile/company_complete_profile_screen.dart';
import 'package:wasl/features/auth/presentation/login/login_screen.dart';
import 'package:wasl/features/auth/presentation/register/register_screen.dart';
import 'package:wasl/features/intro/onboarding/onboarding_screen.dart';
import 'package:wasl/features/intro/splash/splash_screen.dart';
import 'package:wasl/features/intro/welcome/welcome_screen.dart';


class Routes {
  static String splah = "/";
  static String onboarding = "/onboarding";
  static String welcome = "/welcome";
  static String login = "/login";
  static String register = "/register";
  static String BuilderCompleteProfileScreen = "/BuilderCompleteProfileScreen";
  static String CompanyCompleteProfileScreen = "/CompanyCompleteProfileScreen";
  static String Bmain = "/Bmain";
  static String Cmain = "/Cmain";

  static GoRouter routes = GoRouter(
    routes: [
      GoRoute(path: splah, builder: (context, state) => const SplashScreen()),
      GoRoute(
        path: onboarding,
        builder: (context, state) =>  OnboardingScreen(),
      ),
      GoRoute(
        path: welcome,
        builder: (context, state) => const WelcomeScreen(),
      ),
      GoRoute(
        path: login,
        builder: (context, state) => BlocProvider(
          create: (context) => AuthCubit(),
          child:const LoginScreen(),
        ),
      ),
      GoRoute(
        path: register,
        builder: (context, state) => BlocProvider(
          create: (context) => AuthCubit(),
          child: const RegisterScreen(),
        ),
      ),
      GoRoute(
        path: BuilderCompleteProfileScreen,
        builder: (context, state) => BlocProvider(
          create: (context) => AuthCubit(),
          child: const BuilderCompleteProfile(),
        ),
      ),
      GoRoute(
        path: CompanyCompleteProfileScreen,
        builder: (context, state) => BlocProvider(
          create: (context) => AuthCubit(),
          child: const CompanyCompleteProfile(),
        ),
      ),
      
    ],
  );
}
