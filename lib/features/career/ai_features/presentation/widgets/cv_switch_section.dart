import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:wasl/core/constants/app_images.dart';
import 'package:wasl/features/career/ai_features/presentation/cubit/ai_cubit.dart';
import 'package:wasl/features/career/ai_features/presentation/cubit/ai_state.dart';
import 'package:wasl/features/career/ai_features/presentation/widgets/future_plane.dart';
import 'package:wasl/features/career/ai_features/presentation/widgets/job_matching.dart';

class CvSwitchSection extends StatefulWidget {
  const CvSwitchSection({super.key});

  @override
  State<CvSwitchSection> createState() => CvSwitchSectionState();
}

class CvSwitchSectionState extends State<CvSwitchSection> {
  bool _isJobMatching = true;

  void reset() {
    setState(() => _isJobMatching = true);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () => setState(() => _isJobMatching = true),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  decoration: BoxDecoration(
                    color:
                        _isJobMatching ? const Color(0xff1F3C88) : Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border:
                        Border.all(color: const Color(0xff1F3C88), width: 1.5),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.work_outline,
                          color: _isJobMatching
                              ? Colors.white
                              : const Color(0xff1F3C88),
                          size: 18),
                      const SizedBox(width: 8),
                      Text(
                        'Job Matching',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: _isJobMatching
                              ? Colors.white
                              : const Color(0xff1F3C88),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: GestureDetector(
                onTap: () => setState(() => _isJobMatching = false),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  decoration: BoxDecoration(
                    color: !_isJobMatching
                        ? const Color(0xff1F3C88)
                        : Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border:
                        Border.all(color: const Color(0xff1F3C88), width: 1.5),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.flag_outlined,
                          color: !_isJobMatching
                              ? Colors.white
                              : const Color(0xff1F3C88),
                          size: 18),
                      const SizedBox(width: 8),
                      Text(
                        'Recommendations',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: !_isJobMatching
                              ? Colors.white
                              : const Color(0xff1F3C88),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        BlocBuilder<AiCubit, AiState>(
          builder: (context, state) {
            if (state is AiLoading) {
              return SizedBox(
                height: MediaQuery.of(context).size.height * 0.5,
                child: const Center(
                  child: CircularProgressIndicator(
                    color: Color(0xff1F3C88),
                  ),
                ),
              );
            }
            if (state is AiError) {
              return SizedBox(
                height: MediaQuery.of(context).size.height * 0.5,
                child: Column(
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
              );
            }
            if (state is AiSuccess) {
              return _isJobMatching
                  ? JobMatchingWidget(matches: state.matches)
                  : FuturePlanWidget(futurePlan: state.futurePlan);
            }
            return const SizedBox();
          },
        ),
      ],
    );
  }
}
