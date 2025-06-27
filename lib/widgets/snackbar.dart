import 'package:flutter/material.dart';
import 'package:toastification/toastification.dart';

import '../main.dart';
import '../utils/fontsizes.dart';

class SnackbarHelper {
  static void showSnackbar(
    String message, {
    Duration duration = const Duration(seconds: 2),
    bool isError = false,
    bool isTop = false,
    int maxlines = 2,
  }) {
    final context = navigatorKey.currentState?.context;
    if (context != null) {
      toastification.show(
        alignment: Alignment.topCenter,
        overlayState: navigatorKey.currentState?.overlay,
        style: ToastificationStyle.flatColored,
        type: isError ? ToastificationType.error : ToastificationType.success,
        showProgressBar: false,
        autoCloseDuration: duration,
        context: context,
        description: Text(
          message,
          style: TextStyle(color: Colors.black),
          maxLines: maxlines,
          textAlign: TextAlign.center,
          overflow: TextOverflow.ellipsis,
        ),
        backgroundColor: isError ? Colors.red.shade100 : Colors.green[100],
        icon: Icon(
          isError ? Icons.error : Icons.check_circle,
          color: isError ? Colors.red : Colors.green,
        ),
        borderRadius: BorderRadius.circular(commonRadiusSize),
      );
      // LoaderHelper.hideLoader();
    } else {}
  }
}
