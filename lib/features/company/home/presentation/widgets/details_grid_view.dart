import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:wasl/features/auth/models/company_model.dart';
import 'package:wasl/features/company/home/presentation/widgets/detail_container.dart';

class DetailsGridView extends StatelessWidget {
  const DetailsGridView({super.key});

  @override
  Widget build(BuildContext context) {
    final String uid = FirebaseAuth.instance.currentUser!.uid;

    return StreamBuilder<DocumentSnapshot>(
      stream:
          FirebaseFirestore.instance.collection('Company').doc(uid).snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || !snapshot.data!.exists) {
          return const Center(child: Text("No company data found"));
        }

        final company = CompanyModel.fromJson(
          snapshot.data!.data() as Map<String, dynamic>,
        );

        return GridView(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 15,
            crossAxisSpacing: 15,
          ),
          children: [
            DetailContainer(
              title: "Total Jobs",
              value: company.uploadedJobs?.length.toString() ?? "0",
            ),
            DetailContainer(
              title: "Total Applications",
              value: company.uploadedJobs?.length.toString() ?? "0",
            ),
            DetailContainer(
              title: "Active Jobs",
              value: company.activeJobs?.length.toString() ?? "0",
            ),
            DetailContainer(
              title: "Terminated Jobs",
              value: company.terminatedJobs?.length.toString() ?? "0",
            ),
          ],
        );
      },
    );
  }
}
