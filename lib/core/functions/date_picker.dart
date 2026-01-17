import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

Future<void> pickMonthYearWithDatePicker(
  BuildContext context,
  TextEditingController controller,
) async {
  final DateTime? picked = await showDatePicker(
    context: context,
    useRootNavigator: true,
    initialDate: DateTime.now(),
    firstDate: DateTime(2000),
    lastDate: DateTime.now(),
    initialDatePickerMode: DatePickerMode.year,
  );

  if (picked != null) {
    final formatted = DateFormat('MMM yyyy').format(picked);
    controller.text = formatted;
  }
}
