import 'package:flutter/material.dart';

showloadingDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) {
      return Center(child: CircularProgressIndicator());
    },
  );
}
