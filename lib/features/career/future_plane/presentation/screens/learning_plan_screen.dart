import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:file_picker/file_picker.dart';
import 'package:lottie/lottie.dart';
import 'package:wasl/core/constants/Industries.dart';
import 'package:wasl/core/constants/app_images.dart';
import 'package:wasl/core/functions/file_functions.dart';
import 'package:wasl/core/utils/colors.dart';
import 'package:wasl/features/career/future_plane/presentation/cubit/learning_plan_cubit.dart';
import 'package:wasl/features/career/future_plane/presentation/cubit/learning_plan_state.dart';
import 'package:wasl/features/career/future_plane/presentation/widgets/learning_plan_widget.dart';

class LearningPlanScreen extends StatelessWidget {
  const LearningPlanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => LearningPlanCubit(),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.primaryColor,
          title: const Text('Learning Plan',
              style: TextStyle(color: Colors.white)),
        ),
        body: const Padding(
          padding: EdgeInsets.all(20),
          child: SingleChildScrollView(
            child: _LearningPlanBody(),
          ),
        ),
      ),
    );
  }
}

class _LearningPlanBody extends StatefulWidget {
  const _LearningPlanBody();

  @override
  State<_LearningPlanBody> createState() => _LearningPlanBodyState();
}

class _LearningPlanBodyState extends State<_LearningPlanBody> {
  PlatformFile? _selectedFile;
  String? _targetRole;

  Future<void> _pickFile() async {
    final file = await pickDocument(context);
    if (file != null) {
      setState(() => _selectedFile = file);
    }
  }

  void _removeFile() {
    setState(() => _selectedFile = null);
  }

  void _onRoleChanged(String? newRole) {
    setState(() => _targetRole = newRole);
  }

  void _onMakeAPlanPressed() {
    if (_selectedFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please upload your CV first')),
      );
      return;
    }
    if (_targetRole == null || _targetRole!.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a target role')),
      );
      return;
    }
    context
        .read<LearningPlanCubit>()
        .getLearningPlane(_selectedFile!, _targetRole!);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Attach Document',
          style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Color(0xFF374151)),
        ),
        const SizedBox(height: 8),
        _selectedFile == null ? _buildUploadArea() : _buildFilePreview(),
        const SizedBox(height: 20),
        const Text(
          'Target Role',
          style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Color(0xFF374151)),
        ),
        const SizedBox(height: 8),
        _buildRoleDropdown(),
        const SizedBox(height: 20),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: _onMakeAPlanPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryColor,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text(
              'Make A Plan',
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 15),
            ),
          ),
        ),
        const SizedBox(height: 20),
        BlocBuilder<LearningPlanCubit, LearningPlanState>(
          builder: (context, state) {
            if (state is LearningPlanStateLoading) {
              return const Padding(
                padding: EdgeInsets.only(top: 40),
                child: Center(
                  child:
                      CircularProgressIndicator(color: AppColors.primaryColor),
                ),
              );
            }
            if (state is LearningPlanStateError) {
              return SizedBox(
                height: MediaQuery.of(context).size.height * 0.4,
                child: Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Lottie.asset(AppImages.error, width: 160, height: 160),
                      const SizedBox(height: 20),
                      const Text(
                        'Something went wrong',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF111827),
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Please try again later',
                        style: TextStyle(
                          fontSize: 13,
                          color: Color(0xFF9CA3AF),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }
            if (state is LearningPlanStateSuccess) {
              return LearningPlanResultWidget(plan: state.plan);
            }
            return const SizedBox();
          },
        ),
      ],
    );
  }

  Widget _buildUploadArea() {
    return GestureDetector(
      onTap: _pickFile,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.grey.shade50,
          border: Border.all(color: Colors.grey.shade300, width: 1.5),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.upload_file_outlined,
                size: 36, color: Colors.grey.shade400),
            const SizedBox(height: 10),
            Text(
              'Tap to upload a file',
              style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey.shade700),
            ),
            const SizedBox(height: 4),
            Text('PDF or DOCX only',
                style: TextStyle(fontSize: 12, color: Colors.grey.shade400)),
          ],
        ),
      ),
    );
  }

  Widget _buildFilePreview() {
    final file = _selectedFile!;
    final extension = file.extension ?? '';

    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: const Color(0xFFE5E7EB), width: 1.5),
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  blurRadius: 8,
                  offset: const Offset(0, 2)),
            ],
          ),
          child: Row(
            children: [
              buildFileIcon(extension),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      file.name,
                      style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF111827)),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(formatFileSize(file.size),
                        style: const TextStyle(
                            fontSize: 12, color: Color(0xFF9CA3AF))),
                  ],
                ),
              ),
            ],
          ),
        ),
        Positioned(
          top: -10,
          right: -10,
          child: GestureDetector(
            onTap: _removeFile,
            child: Container(
              width: 26,
              height: 26,
              decoration: BoxDecoration(
                color: const Color(0xFFEF4444),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                      color: Colors.black.withOpacity(0.15),
                      blurRadius: 4,
                      offset: const Offset(0, 1))
                ],
              ),
              child: const Icon(Icons.close, size: 14, color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRoleDropdown() {
    final allTitles = industryJobTitles.values
        .expand((list) => list)
        .toSet()
        .toList()
      ..sort();

    return Container(
      height: 50,
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.softgrayColor,
        borderRadius: BorderRadius.circular(25),
      ),
      child: DropdownButton<String?>(
        icon: const Icon(Icons.expand_circle_down_outlined,
            color: AppColors.primaryColor),
        iconEnabledColor: AppColors.primaryColor,
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
        underline: const SizedBox(),
        isExpanded: true,
        hint: const Text('Select target role'),
        value: _targetRole,
        items: [
          for (var title in allTitles)
            DropdownMenuItem(value: title, child: Text(title)),
        ],
        onChanged: _onRoleChanged,
      ),
    );
  }
}
