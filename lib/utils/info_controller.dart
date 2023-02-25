import 'package:consus_erp/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutx/flutx.dart';
import 'package:logger/logger.dart';
import 'package:get/get.dart';

Logger logger = Logger();

class Info {

  static Future startProgress() async {
    await Get.generalDialog(pageBuilder:
        (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) {
      return Center(
        child: CircularProgressIndicator(),
      );
    });
    ;
  }

  static void stopProgress() {
    if (Get.isDialogOpen!) Get.back();
  }

  static Future<void> successSnackBar(String message) async {
    await Get.snackbar("Status : Success", message,
        icon: Icon(
          Icons.check,
          color: Colors.green,
          size: 40,
        ));
  }

  static Future<void> errorSnackBar(String message) async {
    await Get.snackbar("Status : Error", message,
        borderRadius: 15,
        icon: Icon(
          Icons.cancel,
          color: Colors.red,
          size: 40,
        ));
  }

  static Future<void> infoSnackBar(String message) async {
    await Get.snackbar(
      "",
      message,
      icon: Icon(
        Icons.info,
        color: Colors.red,
        size: 40,
      ),
    );
  }

  static message(String message,
      {GlobalKey<ScaffoldMessengerState>? scaffoldMessengerKey,
      BuildContext? context,
      Duration? duration,
      SnackBarBehavior snackBarBehavior = SnackBarBehavior.fixed}) {
    duration ??= Duration(seconds: 3);
    ThemeData theme = AppTheme.theme;

    SnackBar snackBar = SnackBar(
      duration: duration,
      content: FxText(
        message,
        color: theme.colorScheme.onPrimary,
      ),
      backgroundColor: theme.colorScheme.primary,
      behavior: snackBarBehavior,
    );

    if (scaffoldMessengerKey != null) {
      scaffoldMessengerKey.currentState!.showSnackBar(snackBar);
    } else if (context != null) {
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } else {}
  }

  static error(String message,
      {GlobalKey<ScaffoldMessengerState>? scaffoldMessengerKey,
      BuildContext? context,
      Duration? duration,
      SnackBarBehavior snackBarBehavior = SnackBarBehavior.fixed}) {
    duration ??= Duration(seconds: 3);
    ThemeData theme = AppTheme.theme;

    SnackBar snackBar = SnackBar(
      duration: duration,
      content: FxText(
        message,
        color: theme.colorScheme.onError,
      ),
      backgroundColor: theme.colorScheme.error,
      behavior: snackBarBehavior,
    );

    if (scaffoldMessengerKey != null) {
      scaffoldMessengerKey.currentState!.showSnackBar(snackBar);
    } else if (context != null) {
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } else {}
  }
}
