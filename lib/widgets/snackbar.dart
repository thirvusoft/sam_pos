import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:heroicons/heroicons.dart';

void showCustomSnackBar(
  String message, {
  bool isError = true,
  String title = "Errors",
  Color iconColor = Colors.white,
  Color backgroundColor = Colors.red,
  required bool icon,
}) {
  Get.showSnackbar(
    GetSnackBar(
      title: title,
      message: message,
      icon: HeroIcon(
        (icon) ? HeroIcons.check : HeroIcons.exclamationCircle,
        color: iconColor,
      ),
      duration: const Duration(seconds: 3),
      backgroundColor: backgroundColor,
    ),
  );
}
