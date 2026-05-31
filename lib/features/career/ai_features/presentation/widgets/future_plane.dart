import 'package:flutter/material.dart';
import 'package:wasl/components/cards/future_plane_card.dart';
import 'package:wasl/features/career/ai_features/data/models/future_plane_model.dart';

class FuturePlanWidget extends StatelessWidget {
  final List<FuturePlanModel> futurePlan;

  const FuturePlanWidget({super.key, required this.futurePlan});

  @override
  Widget build(BuildContext context) {
    if (futurePlan.isEmpty) {
      return const Center(
        child: Text('No future plan available'),
      );
    }

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: futurePlan.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final item = futurePlan[index];
        return FuturePlanCard(item: item);
      },
    );
  }
}