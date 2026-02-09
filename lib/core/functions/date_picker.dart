import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

Future<void> pickMonthYearWithDatePicker(
  BuildContext context,
  TextEditingController controller,
  DateTime firstDate
) async {
  final DateTime? picked = await showDatePicker(
    context: context,
    useRootNavigator: true,
    initialDate: DateTime.now(),
    firstDate: firstDate,
    lastDate: DateTime.now(),
    initialDatePickerMode: DatePickerMode.year,
  );

  if (picked != null) {
    final formatted = DateFormat('MMM yyyy').format(picked);
    controller.text = formatted;
  }
}
