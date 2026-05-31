import 'package:flutter/material.dart';
import 'package:wasl/components/cards/job_match_card.dart';
import 'package:wasl/features/career/ai_features/data/models/job_matching_model.dart';

class JobMatchingWidget extends StatelessWidget {
  final List<JobMatchModel> matches;

  const JobMatchingWidget({super.key, required this.matches});

  @override
  Widget build(BuildContext context) {
    if (matches.isEmpty) {
      return const Center(
        child: Text('No matches found'),
      );
    }

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: matches.length,
      separatorBuilder: (_, __) => const SizedBox(height: 20),
      itemBuilder: (context, index) {
        final match = matches[index];
        return JobMatchCard(match: match);
      },
    );
  }
}
