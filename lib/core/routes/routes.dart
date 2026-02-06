// ignore_for_file: non_constant_identifier_names

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:wasl/core/job/cubit/job_cubit.dart';
import 'package:wasl/core/job/models/job_model.dart';
import 'package:wasl/features/auth/cubit/auth_cubit.dart';
import 'package:wasl/features/auth/presentation/complete_profile/builder_complete_profile_screen.dart';
import 'package:wasl/features/auth/presentation/complete_profile/company_complete_profile_screen.dart';
import 'package:wasl/features/auth/presentation/login/login_screen.dart';
import 'package:wasl/features/auth/presentation/register/register_screen.dart';
import 'package:wasl/features/career/main/career_builder_main_screen.dart';
import 'package:wasl/features/career/profile/presentation/screens/profile_screen.dart';
import 'package:wasl/features/company/add%20job/presentation/screens/add_job_sreen.dart';
import 'package:wasl/features/company/home/presentation/screens/indusrty_employee.dart';
import 'package:wasl/features/company/home/presentation/screens/job_details_screen.dart';
import 'package:wasl/features/company/home/presentation/screens/total_screen.dart';
import 'package:wasl/features/company/main/company_main_screen.dart';
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
  static String BprofileScreen = "/BprofileScreen";
  static String induartyemployee = "/induartyemployee";
  static String totalJScreen = "/totalJScreen";
  static String JobDetailsScreen = "/JobDetailsScreen";
  static String addJob = "/addJob";

  static GoRouter routes = GoRouter(
    routes: [
      GoRoute(path: splah, builder: (context, state) => const SplashScreen()),
      GoRoute(
        path: onboarding,
        builder: (context, state) => OnboardingScreen(),
      ),
      GoRoute(
        path: welcome,
        builder: (context, state) => const WelcomeScreen(),
      ),
      GoRoute(
        path: login,
        builder: (context, state) => BlocProvider(
          create: (context) => AuthCubit(),
          child: const LoginScreen(),
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
      GoRoute(
        path: Bmain,
        builder: (context, state) {
          return BlocProvider(
            create: (context) => JobCubit(),
            child: const CareerBuilderMainScreen(),
          );
        },
      ),
      GoRoute(
        path: Cmain,
        builder: (context, state) {
          final int initialIndex = state.extra as int? ?? 0;

          return BlocProvider(
            create: (context) => JobCubit(),
            child: CompanyMainScreen(
              initialIndex: initialIndex,
            ),
          );
        },
      ),
      GoRoute(
        path: BprofileScreen,
        builder: (context, state) {
          return const ProfileScreen();
        },
      ),
      GoRoute(
        path: induartyemployee,
        builder: (context, state) {
          return const IndusrtyEmployee();
        },
      ),
      GoRoute(
        path: Routes.totalJScreen,
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>;

          // هنا هنجيب الـ JobCubit اللي موجود في CompanyMainScreen
          final jobCubit = extra['cubit'] as JobCubit;

          return BlocProvider.value(
            value: jobCubit,
            child: TotalScreen(
              title: extra['title'],
              listType: extra['type'],
            ),
          );
        },
      ),
      GoRoute(
        path: Routes.JobDetailsScreen,
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>; // extra دلوقتي Map
          final JobModel job = extra['job'] as JobModel; // خده من الـ Map
          final jobCubit = extra['cubit'] as JobCubit;

          return BlocProvider.value(
            value: jobCubit,
            child: jobDetailsScreen(job: job),
          );
        },
      ),
      GoRoute(
        path: addJob,
        builder: (context, state) {
          return BlocProvider(
            create: (context) => JobCubit(),
            child: AddJobSreen(job: state.extra as JobModel?),
          );
        },
      ),
    ],
  );
}
