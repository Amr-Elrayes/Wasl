  import 'package:flutter/material.dart';

Widget buildJobMatchingContent() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE5E7EB), width: 1.5),
      ),
      child: const Text(
        'Job Matching Content here...',
        style: TextStyle(fontSize: 14, color: Color(0xFF374151)),
      ),
    );
  }