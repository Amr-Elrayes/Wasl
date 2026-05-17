import 'package:flutter/material.dart';
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
        // الزرارين
        Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () => setState(() => _isJobMatching = true),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  decoration: BoxDecoration(
                    color: _isJobMatching ? const Color(0xff1F3C88) : Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xff1F3C88), width: 1.5),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.work_outline,
                          color: _isJobMatching ? Colors.white : const Color(0xff1F3C88),
                          size: 18),
                      const SizedBox(width: 8),
                      Text(
                        'Job Matching',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: _isJobMatching ? Colors.white : const Color(0xff1F3C88),
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
                    color: !_isJobMatching ? const Color(0xff1F3C88) : Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xff1F3C88), width: 1.5),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.flag_outlined,
                          color: !_isJobMatching ? Colors.white : const Color(0xff1F3C88),
                          size: 18),
                      const SizedBox(width: 8),
                      Text(
                        'Future Plan',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: !_isJobMatching ? Colors.white : const Color(0xff1F3C88),
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
        _isJobMatching ? buildJobMatchingContent() : buildFuturePlanContent(),
      ],
    );
  }
}