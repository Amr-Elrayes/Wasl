import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:lottie/lottie.dart';
import 'package:wasl/components/cards/job_card.dart';
import 'package:wasl/core/constants/app_images.dart';
import 'package:wasl/core/constants/enums.dart';
import 'package:wasl/core/job/cubit/job_cubit.dart';
import 'package:wasl/core/job/cubit/job_state.dart';
import 'package:wasl/core/routes/navigation.dart';
import 'package:wasl/core/routes/routes.dart';
import 'package:wasl/core/utils/colors.dart';
import 'package:wasl/core/utils/text_styles.dart';

class TotalScreen extends StatefulWidget {
  const TotalScreen({super.key, required this.title, required this.listType});
  final String title;
  final JobListType listType;
  @override
  State<TotalScreen> createState() => _TotalScreenState();
}

class _TotalScreenState extends State<TotalScreen> {
  late JobCubit jobCubit;
  @override
  void initState() {
    super.initState();
    jobCubit = BlocProvider.of<JobCubit>(context);
    jobCubit.getJobsByType(
      companyId: FirebaseAuth.instance.currentUser!.uid,
      type: widget.listType,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            widget.title,
            style: TextStyles.textSize18
                .copyWith(color: Colors.white, fontSize: 20),
          ),
          backgroundColor: AppColors.primaryColor,
          leading: IconButton(
            onPressed: () {
              pop(context);
            },
            icon: const Icon(Icons.arrow_back_ios_new_rounded),
            color: Colors.white,
          ),
        ),
        body: BlocBuilder<JobCubit, JobState>(
          bloc: jobCubit,
          builder: (context, state) {
            if (state is JobLoadingState) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is JobListLoadedState) {
              if (state.jobs.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Lottie.asset(AppImages.noData, width: 160, height: 160),
                      Text(
                        "No Jobs Found",
                        style: TextStyles.textSize15,
                      )
                    ],
                  ),
                );
              }

              return ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: state.jobs.length,
                separatorBuilder: (_, __) => const Gap(15),
                itemBuilder: (context, index) {
                  return JobCard(
                    job: state.jobs[index],
                    onTap: () {
                      pushTo(context, Routes.JobDetailsScreen, extra: {
                        "job": state.jobs[index],
                        "isUser": false
                      });
                    },
                  );
                },
              );
            }

            if (state is JobFailureState) {
              return Center(child: Text(state.errorMessage));
            }

            return const SizedBox();
          },
        ));
  }
}
