import 'package:flutter/material.dart';
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
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final match = matches[index];
        return _JobMatchCard(match: match);
      },
    );
  }
}

class _JobMatchCard extends StatelessWidget {
  final JobMatchModel match;

  const _JobMatchCard({required this.match});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE5E7EB), width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  match.job.title ?? '',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF111827),
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: _getScoreColor(match.matchScore).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '${match.matchScore}%',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: _getScoreColor(match.matchScore),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            match.job.company ?? '',
            style: const TextStyle(fontSize: 13, color: Color(0xFF6B7280)),
          ),
          const SizedBox(height: 12),
          // Matched Skills
          if (match.matchedSkills.isNotEmpty) ...[
            const Text(
              'Matched Skills',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF111827)),
            ),
            const SizedBox(height: 6),
            Wrap(
              spacing: 8,
              runSpacing: 6,
              children: match.matchedSkills.map((skill) => _SkillChip(
                skill: skill,
                color: Colors.green,
              )).toList(),
            ),
            const SizedBox(height: 12),
          ],
          // Missing Skills
          if (match.missingSkills.isNotEmpty) ...[
            const Text(
              'Missing Skills',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF111827)),
            ),
            const SizedBox(height: 6),
            Wrap(
              spacing: 8,
              runSpacing: 6,
              children: match.missingSkills.map((skill) => _SkillChip(
                skill: skill,
                color: Colors.red,
              )).toList(),
            ),
          ],
        ],
      ),
    );
  }

  Color _getScoreColor(int score) {
    if (score >= 70) return Colors.green;
    if (score >= 40) return Colors.orange;
    return Colors.red;
  }
}

class _SkillChip extends StatelessWidget {
  final String skill;
  final Color color;

  const _SkillChip({required this.skill, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Text(
        skill,
        style: TextStyle(fontSize: 12, color: color, fontWeight: FontWeight.w500),
      ),
    );
  }
}