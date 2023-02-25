import 'package:flutter/material.dart';

class AppDateTimePicker {
  static Future<DateTime?> getDate(BuildContext context) async {
    return await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
  }
}
