import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:wasl/core/utils/colors.dart';
import 'package:wasl/core/utils/text_styles.dart';
import 'package:wasl/features/auth/models/career_builder_model.dart';

class InfoRow extends StatelessWidget {
  const InfoRow({super.key});

  @override
  Widget build(BuildContext context) {
    final String uid = FirebaseAuth.instance.currentUser!.uid;
    return StreamBuilder<DocumentSnapshot>(
      stream:
          FirebaseFirestore.instance.collection('Career').doc(uid).snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || !snapshot.data!.exists) {
          return const Center(child: Text("No company data found"));
        }

        final user = CareerBuilderModel.fromJson(
          snapshot.data!.data() as Map<String, dynamic>,
        );

        return Row(
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(13)),
              child: Container(
                height: 60,
                width: 60,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: Colors.white,
                ),
                child: Image.network(
                  user.image ?? '',
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const Gap(10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Hi ${user.name}",
                  style: TextStyles.textSize18.copyWith(
                      color: AppColors.primaryColor,
                      fontWeight: FontWeight.bold),
                ),
                const Text("Nice to See You "),
              ],
            ),
          ],
        );
      },
    );
  }
}
