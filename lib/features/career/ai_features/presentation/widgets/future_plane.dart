import 'package:flutter/material.dart';
import 'package:wasl/components/cards/future_plane_card.dart';
import 'package:wasl/features/career/ai_features/data/models/future_plane_model.dart';

class FuturePlanWidget extends StatelessWidget {
  final FuturePlanModel? futurePlan; // تعديل النوع إلى Object

  const FuturePlanWidget({super.key, required this.futurePlan});

  @override
  Widget build(BuildContext context) {
    if (futurePlan == null || futurePlan!.careerPaths.isEmpty) {
      return const Center(
        child: Text('No future plan available'),
      );
    }

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. عرض ملخص الكانديديت
          if (futurePlan!.candidateSummary.isNotEmpty) ...[
            const Text(
              'Candidate Summary',
              style: TextStyle(
                fontSize: 15, 
                fontWeight: FontWeight.bold, 
                color: Color(0xff1F3C88),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              futurePlan!.candidateSummary, 
              style: const TextStyle(fontSize: 13, color: Colors.black87),
            ),
            const Divider(height: 24, thickness: 1),
          ],

          // 2. عرض المسارات المهنية المتوقعة
          const Text(
            'Career Paths',
            style: TextStyle(
              fontSize: 15, 
              fontWeight: FontWeight.bold, 
              color: Color(0xff1F3C88),
            ),
          ),
          const SizedBox(height: 10),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: futurePlan!.careerPaths.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final item = futurePlan!.careerPaths[index];
              // ملحوظة: تأكد من تعديل الـ FuturePlanCard ليستقبل كائن من نوع CareerPathItem
              return FuturePlanCard(item: item);
            },
          ),

          // 3. عرض النصائح العامة
          if (futurePlan!.generalAdvice.isNotEmpty) ...[
            const Divider(height: 24, thickness: 1),
            const Text(
              'General Advice',
              style: TextStyle(
                fontSize: 15, 
                fontWeight: FontWeight.bold, 
                color: Color(0xff1F3C88),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              futurePlan!.generalAdvice, 
              style: const TextStyle(fontSize: 13, color: Colors.black87, fontStyle: FontStyle.italic),
            ),
          ],
        ],
      ),
    );
  }
}