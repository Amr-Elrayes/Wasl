import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:wasl/components/cards/emplpyee_card.dart';
import 'package:wasl/core/utils/colors.dart';
import 'package:wasl/features/auth/models/career_builder_model.dart';
import 'package:wasl/services/firebase/firebase_services.dart';

class employeesInIndustry extends StatelessWidget {
  const employeesInIndustry({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: FirestoreServices.getCompanyField(),
      builder: (context, fieldSnapshot) {
        if (!fieldSnapshot.hasData) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        final companyField = fieldSnapshot.data!;

        return FutureBuilder<QuerySnapshot>(
          future: FirestoreServices.filterEmployeesByIndustry(companyField),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            return ListView.separated(
              separatorBuilder: (_, __) =>
                  const Divider(color: AppColors.grayColor),
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                final employee = CareerBuilderModel.fromJson(
                  snapshot.data!.docs[index].data() as Map<String, dynamic>,
                );
                return EmplpyeeCard(employee: employee);
              },
            );
          },
        );
      },
    );
  }
}
