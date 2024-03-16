import 'package:flutter/material.dart';
import 'package:toastification/toastification.dart';

class ToastrService {
  const ToastrService();

  void success(BuildContext context, String title, String description) {
    toastification.dismissAll();
    toastification.show(
      context: context,
      title: Text(title),
      description: Text(description),
      autoCloseDuration: const Duration(seconds: 5),
      type: ToastificationType.success,
      style: ToastificationStyle.flatColored,
      showProgressBar: false
    );
  }

  void info(BuildContext context, String title, String description) {
    toastification.dismissAll();
    toastification.show(
      context: context,
      title: Text(title),
      description: Text(description),
      autoCloseDuration: const Duration(seconds: 5),
      type: ToastificationType.info,
      style: ToastificationStyle.flatColored,
      showProgressBar: false
    );
  }
  void warning(BuildContext context, String title, String description) {
    toastification.dismissAll();
    toastification.show(
      context: context,
      title: Text(title),
      description: Text(description),
      autoCloseDuration: const Duration(seconds: 5),
      type: ToastificationType.warning,
      style: ToastificationStyle.flatColored,
      showProgressBar: false
    );
  }
  void error(BuildContext context, String title, String description) {
    toastification.dismissAll();
    toastification.show(
      context: context,
      title: Text(title),
      description: Text(description),
      autoCloseDuration: const Duration(seconds: 5),
      type: ToastificationType.error,
      style: ToastificationStyle.flatColored,
      showProgressBar: false
    );
  }

}