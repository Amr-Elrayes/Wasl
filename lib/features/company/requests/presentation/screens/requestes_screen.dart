import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:async/async.dart';
import 'package:lottie/lottie.dart';
import 'package:wasl/components/cards/emplpyee_card.dart';
import 'package:wasl/core/constants/app_images.dart';
import 'package:wasl/core/routes/navigation.dart';
import 'package:wasl/core/utils/colors.dart';
import 'package:wasl/core/utils/text_styles.dart';
import 'package:wasl/features/auth/models/career_builder_model.dart';

class RequestesScreen extends StatelessWidget {
  const RequestesScreen({
    super.key,
    required this.applicationsIds,
  });

  final List<String> applicationsIds;

  @override
  Widget build(BuildContext context) {
    if (applicationsIds.isEmpty) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Lottie.asset(AppImages.noData, width: 160, height: 160),
              Text(
                "No Applications yet",
                style: TextStyles.textSize15,
              )
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Applications",
          style: TextStyles.textSize18.copyWith(color: Colors.white),
        ),
        backgroundColor: AppColors.primaryColor,
        leading: IconButton(
          onPressed: () {
            pop(context);
          },
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          color: Colors.white,
        ),
      ),
      body: StreamBuilder<List<CareerBuilderModel>>(
        stream: _employeesStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Lottie.asset(AppImages.noData, width: 160, height: 160),
                  Text(
                    "No Apllications Found",
                    style: TextStyles.textSize15,
                  )
                ],
              ),
            );
          }

          final employees = snapshot.data!;

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: employees.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              return EmplpyeeCard(employee: employees[index]);
            },
          );
        },
      ),
    );
  }

  Stream<List<CareerBuilderModel>> _employeesStream() {
    final chunks = _chunkList(applicationsIds, 10);

    final streams = chunks.map((chunk) {
      return FirebaseFirestore.instance
          .collection('Career')
          .where(FieldPath.documentId, whereIn: chunk)
          .snapshots();
    });

    return StreamGroup.merge(streams).map((snapshot) {
      return snapshot.docs
          .map((doc) =>
              CareerBuilderModel.fromJson(doc.data() as Map<String, dynamic>))
          .toList();
    });
  }

  List<List<String>> _chunkList(List<String> list, int chunkSize) {
    final chunks = <List<String>>[];
    for (var i = 0; i < list.length; i += chunkSize) {
      chunks.add(
        list.sublist(
          i,
          i + chunkSize > list.length ? list.length : i + chunkSize,
        ),
      );
    }
    return chunks;
  }
}
