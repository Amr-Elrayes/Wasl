import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wasl/features/career/future_plane/data/models/learning_plan_model.dart';
import 'package:wasl/features/career/future_plane/data/models/learning_resource_model.dart';
import 'package:wasl/features/career/future_plane/data/models/learning_week_model.dart';

class LearningPlanResultWidget extends StatelessWidget {
  final LearningPlanModel plan;

  const LearningPlanResultWidget({super.key, required this.plan});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Summary
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xffE6F1FB),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                plan.targetRole,
                style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xff042C53)),
              ),
              const SizedBox(height: 6),
              Text(
                '${plan.currentLevel} • ${plan.totalDuration} • ${plan.weeklyHours}h/week',
                style: const TextStyle(fontSize: 13, color: Color(0xff185FA5)),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // Weekly Plan
        const Text('Weekly Plan',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
        const SizedBox(height: 10),
        ...plan.plan.map((week) => _WeekCard(week: week)),

        const SizedBox(height: 8),

        // Certifications
        if (plan.certifications.isNotEmpty) ...[
          const Text('Recommended Certifications',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          ...plan.certifications.map((c) => _BulletRow(text: c)),
          const SizedBox(height: 16),
        ],

        // Portfolio Projects
        if (plan.portfolioProjects.isNotEmpty) ...[
          const Text('Portfolio Projects',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          ...plan.portfolioProjects.map((p) => _BulletRow(text: p)),
          const SizedBox(height: 16),
        ],

        // Tips
        if (plan.tips.isNotEmpty)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xffEEEDFE),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: const [
                    Icon(Icons.lightbulb_outline,
                        size: 18, color: Color(0xff3C3489)),
                    SizedBox(width: 8),
                    Text('Tips',
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Color(0xff26215C))),
                  ],
                ),
                const SizedBox(height: 8),
                ...plan.tips.map((t) => Padding(
                      padding: const EdgeInsets.only(bottom: 6),
                      child: Text('• $t',
                          style: const TextStyle(
                              fontSize: 13,
                              color: Color(0xff26215C),
                              height: 1.5)),
                    )),
              ],
            ),
          ),
      ],
    );
  }
}

class _WeekCard extends StatelessWidget {
  final LearningWeekModel week;
  const _WeekCard({required this.week});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: const Color(0xFFE5E7EB)),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: const Color(0xff1F3C88),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text('Week ${week.week}',
                    style: const TextStyle(
                        fontSize: 11,
                        color: Colors.white,
                        fontWeight: FontWeight.w600)),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(week.focus,
                    style: const TextStyle(
                        fontSize: 14, fontWeight: FontWeight.w600)),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ...week.learningObjectives.map((o) => Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Text('• $o',
                    style: const TextStyle(
                        fontSize: 12, color: Color(0xFF6B7280))),
              )),
          const SizedBox(height: 8),
          ...week.resources.map((r) => _ResourceRow(resource: r)),
          const SizedBox(height: 8),
          Text('Project: ${week.practiceProject}',
              style: const TextStyle(
                  fontSize: 12,
                  fontStyle: FontStyle.italic,
                  color: Color(0xFF6B7280))),
        ],
      ),
    );
  }
}

class _ResourceRow extends StatelessWidget {
  final LearningResourceModel resource;
  const _ResourceRow({required this.resource});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => launchUrl(Uri.parse(resource.url)),
      child: Padding(
        padding: const EdgeInsets.only(bottom: 6),
        child: Row(
          children: [
            const Icon(Icons.link, size: 14, color: Color(0xff378ADD)),
            const SizedBox(width: 6),
            Expanded(
              child: GestureDetector(
                onTap: () {
                  launchUrl(
                    Uri.parse(resource.url),
                    mode: LaunchMode.externalApplication,
                  );
                },
                child: Text(
                  '${resource.name} (${resource.provider})',
                  style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xff185FA5),
                      decoration: TextDecoration.underline),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BulletRow extends StatelessWidget {
  final String text;
  const _BulletRow({required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text('• $text',
          style: const TextStyle(fontSize: 13, color: Color(0xFF374151))),
    );
  }
}
