import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:wasl/components/buttons/custom_buttom.dart';
import 'package:wasl/components/inputs/custom_text_field.dart';
import 'package:wasl/core/constants/Industries.dart';
import 'package:wasl/core/constants/enums.dart';
import 'package:wasl/core/functions/showloadingdialog.dart';
import 'package:wasl/core/functions/snackbar.dart';
import 'package:wasl/core/job/cubit/job_cubit.dart';
import 'package:wasl/core/job/cubit/job_state.dart';
import 'package:wasl/core/job/models/job_model.dart';
import 'package:wasl/core/routes/navigation.dart';
import 'package:wasl/core/routes/routes.dart';
import 'package:wasl/core/utils/colors.dart';
import 'package:wasl/core/utils/text_styles.dart';
import 'package:wasl/core/job/models/list_item_model.dart';
import 'package:wasl/features/company/add%20job/presentation/widgets/addjob_expansion_tile_widget.dart';

class AddJobSreen extends StatefulWidget {
  const AddJobSreen({super.key, this.job});
  final JobModel? job;

  bool get isEdit => job != null;
  @override
  State<AddJobSreen> createState() => _AddJobSreenState();
}

class _AddJobSreenState extends State<AddJobSreen> {
  List<ListItemModel> skills = [];
  @override
  void initState() {
    super.initState();
    final cubit = context.read<JobCubit>();

    if (widget.isEdit) {
      final job = widget.job!;

      cubit.title = job.title;
      cubit.describtionController.text = job.description ?? "";
      cubit.requirmentsController.text = job.requirments ?? "";
      cubit.salaryController.text = job.salary?.toString() ?? "";

      cubit.jobType = Jobtype.values.firstWhere((e) => e.name == job.type);

      cubit.jobLocation =
          Joblocation.values.firstWhere((e) => e.name == job.location);

      /// ⭐⭐ المهم هنا ⭐⭐
      skills = List<ListItemModel>.from(job.reqSkills ?? []);
    } else {
      cubit.clearForm();
      skills.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    var cubit = context.watch<JobCubit>();
    return Scaffold(
      appBar: AppBar(
        leading: widget.isEdit
            ? IconButton(
                onPressed: () {
                  pop(context);
                },
                icon: const Icon(Icons.arrow_back_ios_new_rounded),
                color: Colors.white,
              )
            : null,
        backgroundColor: AppColors.primaryColor,
        title: Text(
          widget.isEdit ? "Update Job" : "Add Job",
          style: TextStyles.textSize24.copyWith(
            color: AppColors.bgColor,
          ),
        ),
      ),
      body: BlocListener<JobCubit, JobState>(
        listener: (context, state) {
          if (state is JobLoadingState) {
            showloadingDialog(context);
          } else if (state is JobSuccessState) {
            cubit.clearForm();
            pop(context);
            showSnakBar(context, Colors.green, "Success");
            pushAndRemoveUntil(context, Routes.Cmain);
          } else if (state is JobFailureState) {
            Navigator.pop(context);
            showSnakBar(context, Colors.red, state.errorMessage);
          }
        },
        child: Padding(
          padding: const EdgeInsets.only(top: 30, left: 25, right: 25),
          child: Form(
            key: cubit.formKey,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Title",
                    style: TextStyles.textSize15
                        .copyWith(fontWeight: FontWeight.w500),
                  ),
                  const Gap(5),
                  DropdownButtonFormField<String>(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    icon: const Icon(
                      Icons.expand_circle_down_outlined,
                      color: AppColors.primaryColor,
                    ),
                    value: cubit.title,
                    hint: Text(
                      "Select Job Title",
                      style: TextStyles.textSize15
                          .copyWith(color: AppColors.grayColor),
                    ),
                    items: industryJobTitles.entries.expand((entry) {
                      final industry = entry.key;
                      final jobs = entry.value;
                      return [
                        DropdownMenuItem<String>(
                          enabled: false,
                          value: industry,
                          child: Text(
                            industry,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: AppColors.redColor,
                            ),
                          ),
                        ),
                        ...jobs.map(
                          (job) => DropdownMenuItem<String>(
                            value: job,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 16),
                              child: Text(job),
                            ),
                          ),
                        ),
                      ];
                    }).toList(),
                    onChanged: (newValue) {
                      if (industryJobTitles.containsKey(newValue)) return;
                      cubit.title = newValue;
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please select job title';
                      }
                      return null;
                    },
                  ),
                  const Gap(15),
                  Text(
                    "Description",
                    style: TextStyles.textSize15
                        .copyWith(fontWeight: FontWeight.w500),
                  ),
                  const Gap(5),
                  customTextformfield(
                    controller: cubit.describtionController,
                    hintText: "Add Job Description",
                    maxlines: 4,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please Enter Job Description";
                      }
                      return null;
                    },
                  ),
                  const Gap(15),
                  Text(
                    "Type",
                    style: TextStyles.textSize15
                        .copyWith(fontWeight: FontWeight.w500),
                  ),
                  const Gap(5),
                  DropdownButtonFormField<Jobtype>(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    icon: const Icon(
                      Icons.expand_circle_down_outlined,
                      color: AppColors.primaryColor,
                    ),
                    value: cubit.jobType,
                    hint: Text('Select Job Type',
                        style: TextStyles.textSize15
                            .copyWith(color: AppColors.grayColor)),
                    items: Jobtype.values.map((type) {
                      return DropdownMenuItem<Jobtype>(
                        value: type,
                        child: Text(type.name),
                      );
                    }).toList(),
                    onChanged: (value) {
                      cubit.jobType = value;
                    },
                    validator: (value) {
                      if (value == null) {
                        return 'Please select job type';
                      }
                      return null;
                    },
                  ),
                  const Gap(15),
                  Text(
                    "Location",
                    style: TextStyles.textSize15
                        .copyWith(fontWeight: FontWeight.w500),
                  ),
                  const Gap(5),
                  DropdownButtonFormField<Joblocation>(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    icon: const Icon(
                      Icons.expand_circle_down_outlined,
                      color: AppColors.primaryColor,
                    ),
                    value: cubit.jobLocation,
                    hint: Text('Select Job Location',
                        style: TextStyles.textSize15
                            .copyWith(color: AppColors.grayColor)),
                    items: Joblocation.values.map((location) {
                      return DropdownMenuItem<Joblocation>(
                        value: location,
                        child: Text(location.name),
                      );
                    }).toList(),
                    onChanged: (value) {
                      cubit.jobLocation = value;
                    },
                    validator: (value) {
                      if (value == null) {
                        return 'Please select job location';
                      }
                      return null;
                    },
                  ),
                  const Gap(15),
                  Text(
                    "Salary",
                    style: TextStyles.textSize15
                        .copyWith(fontWeight: FontWeight.w500),
                  ),
                  const Gap(5),
                  Row(
                    children: [
                      Expanded(
                        child: customTextformfield(
                          controller: cubit.salaryController,
                          hintText: "Add Job Salary",
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter
                                .digitsOnly, // ✅ يمنع أي حرف
                          ],
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Please Enter Job Salary";
                            }
                            if (!RegExp(r'^[1-9]\d*$').hasMatch(value)) {
                              return "Salary must be a number greater than 0";
                            }
                            return null;
                          },
                        ),
                      ),
                      const Gap(10),
                      Expanded(
                        child: Text(
                          "\$/Month",
                          style: TextStyles.textSize15
                              .copyWith(fontWeight: FontWeight.w500),
                        ),
                      )
                    ],
                  ),
                  const Gap(15),
                  Text(
                    "Requirments",
                    style: TextStyles.textSize15
                        .copyWith(fontWeight: FontWeight.w500),
                  ),
                  const Gap(5),
                  customTextformfield(
                    controller: cubit.requirmentsController,
                    hintText: "Add Job Requirments",
                    maxlines: 4,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please Enter Job Requirments";
                      }
                      return null;
                    },
                  ),
                  const Gap(15),
                  AddjobExpansionTileWidget(
                    title: "Requirment Skills",
                    items: skills,
                    onAdd: (item) {
                      setState(() => skills.add(item));
                    },
                    onDelete: (index) {
                      setState(() => skills.removeAt(index));
                    },
                  ),
                  const Gap(30)
                ],
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Container(
          height: 60,
          margin: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
          child: customButtom(
            txt: widget.isEdit ? "Update" : "Done",
            onPressed: () async {
              if (cubit.formKey.currentState!.validate()) {
                cubit.reqskills = skills;

                if (widget.isEdit) {
                  await cubit.updateJob(
                    companyId: FirebaseAuth.instance.currentUser!.uid,
                    jobId: widget.job!.jobId,
                  );
                } else {
                  await cubit.uploadJob(
                    companyId: FirebaseAuth.instance.currentUser!.uid,
                  );
                }
              }
            },
          ),
        ),
      ),
    );
  }
}
