import 'package:flutter/material.dart';
import 'package:wasl/features/career/ai_features/data/models/future_plane_model.dart';

class FuturePlanCard extends StatelessWidget {
  // تم تغيير النوع هنا ليستقبل العنصر الخاص بالمسار المهني الجديد
  final CareerPathItem item;

  const FuturePlanCard({super.key, required this.item});

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
          // 1. العنوان ونسبة التوافق (Fit Score)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  item.title,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF111827),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: _getDemandColor(item.marketDemand).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  "${item.fitScore}% Match",
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: _getDemandColor(item.marketDemand),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),

          // 2. الطلب في السوق والمدة الزمنية
          Row(
            children: [
              Text(
                "Demand: ${item.marketDemand}",
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: _getDemandColor(item.marketDemand),
                ),
              ),
              const SizedBox(width: 12),
              Text(
                "Timeline: ${item.timeline}",
                style: const TextStyle(fontSize: 12, color: Color(0xFF6B7280)),
              ),
            ],
          ),
          const SizedBox(height: 10),

          // 3. الشرح والسبب (Rationale)
          Text(
            item.rationale,
            style: const TextStyle(fontSize: 13, color: Color(0xFF4B5563)),
          ),
          const Divider(height: 20, thickness: 0.8),

          // 4. المهارات المطلوبة تطويرها (Skills to Develop)
          if (item.skillsToDevelop.isNotEmpty) ...[
            const Text(
              'Skills to Develop:',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF1F3C88)),
            ),
            const SizedBox(height: 4),
            Wrap(
              spacing: 6,
              runSpacing: 4,
              children: item.skillsToDevelop.map((skill) {
                return Chip(
                  labelPadding: const EdgeInsets.symmetric(horizontal: 4),
                  backgroundColor: const Color(0xFFF3F4F6),
                  side: BorderSide.none,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  label: Text(skill, style: const TextStyle(fontSize: 11, color: Color(0xFF374151))),
                );
              }).toList(),
            ),
            const SizedBox(height: 8),
          ],

          // 5. الخطوات القادمة (Next Steps)
          if (item.nextSteps.isNotEmpty) ...[
            const Text(
              'Next Steps:',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF1F3C88)),
            ),
            const SizedBox(height: 4),
            ...item.nextSteps.map((step) => Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("• ", style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xff1F3C88))),
                      Expanded(
                        child: Text(
                          step,
                          style: const TextStyle(fontSize: 12, color: Color(0xFF6B7280)),
                        ),
                      ),
                    ],
                  ),
                )),
          ],
        ],
      ),
    );
  }

  // دالة لتحديد اللون بناءً على حجم الطلب في السوق (Market Demand)
  Color _getDemandColor(String demand) {
    switch (demand.toLowerCase()) {
      case 'high':
        return Colors.green;
      case 'medium':
        return Colors.orange;
      case 'low':
        return Colors.red;
      default:
        return Colors.blue;
    }
  }
}