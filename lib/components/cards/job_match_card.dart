import 'package:flutter/material.dart';
import 'package:wasl/components/cards/job_card.dart';
import 'package:wasl/core/routes/navigation.dart';
import 'package:wasl/core/routes/routes.dart';
import 'package:wasl/features/career/ai_features/data/models/job_matching_model.dart';

class JobMatchCard extends StatelessWidget {
  final JobMatchModel match;

  const JobMatchCard({required this.match});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              JobCard(
                  job: match.job,
                  onTap: () {
                    pushTo(
                      context,
                      Routes.JobDetailsScreen,
                      extra: {
                        "job": match.job,
                        "isUser": true,
                      },
                    );
                  }),
              Positioned(
                top: -10,
                right: -10,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '${match.matchScore}% Matching',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: _getScoreColor(match.matchScore),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

Color _getScoreColor(int score) {
  if (score >= 90) return Colors.green;
  if (score >= 70) return Colors.orange;
  if (score >= 50) return Colors.blue;
  return Colors.red;
}
