import 'package:flutter/material.dart';
import 'package:get/get.dart';

void showCustomSnackBar(String message,
    {bool isError = true, String title = "Errors"}) {
  Get.showSnackbar(
    GetSnackBar(
      title: title,
      message: message,
      icon: const Icon(Icons.refresh),
      duration: const Duration(seconds: 3),
    ),
  );
}
