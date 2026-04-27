import 'package:flutter/material.dart';
import 'package:wasl/components/inputs/cv_upload_field.dart';


class AiFeaturesScreen extends StatelessWidget {
  const AiFeaturesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Upload Document')),
      body: const Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            FileUploadField(),
          ],
        ),
      ),
    );
  }
}