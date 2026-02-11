import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wasl/core/routes/routes.dart';
import 'package:wasl/core/utils/app_theme.dart';
import 'package:wasl/features/auth/cubit/auth_cubit.dart';
import 'package:wasl/firebase_options.dart';
import 'package:wasl/services/local/shered_pref.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SharedPref.init();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(
    MultiBlocProvider(
      providers: [
            BlocProvider(
      create: (_) => AuthCubit(),
    ),
      ],
      child: const Wasl()),
  );
}

class Wasl extends StatelessWidget {
  const Wasl({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: Routes.routes,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
    );
  }
}

