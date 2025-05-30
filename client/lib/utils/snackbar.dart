import 'package:flutter/material.dart';

class SnackbarUtils {
  static void showSnackbar({
    required BuildContext context,
    required String message,
    Duration duration = const Duration(seconds: 3),
    Color backgroundColor = Colors.black87,
    Color textColor = Colors.white,
    String? actionLabel,
    VoidCallback? onActionPressed,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: TextStyle(color: textColor)),
        duration: duration,
        backgroundColor: backgroundColor,
        action:
            actionLabel != null && onActionPressed != null
                ? SnackBarAction(
                  label: actionLabel,
                  textColor: textColor,
                  onPressed: onActionPressed,
                )
                : null,
      ),
    );
  }

  // Predefined Snackbar types for common use cases
  static void showSuccessSnackbar(
    BuildContext context,
    String message, {
    Duration duration = const Duration(seconds: 3),
    String? actionLabel,
    VoidCallback? onActionPressed,
  }) {
    showSnackbar(
      context: context,
      message: message,
      duration: duration,
      backgroundColor: Colors.green[700]!,
      textColor: Colors.white,
      actionLabel: actionLabel,
      onActionPressed: onActionPressed,
    );
  }

  static void showErrorSnackbar(
    BuildContext context,
    String message, {
    Duration duration = const Duration(seconds: 3),
    String? actionLabel,
    VoidCallback? onActionPressed,
  }) {
    showSnackbar(
      context: context,
      message: message,
      duration: duration,
      backgroundColor: Colors.red[700]!,
      textColor: Colors.white,
      actionLabel: actionLabel,
      onActionPressed: onActionPressed,
    );
  }

  static void showInfoSnackbar(
    BuildContext context,
    String message, {
    Duration duration = const Duration(seconds: 3),
    String? actionLabel,
    VoidCallback? onActionPressed,
  }) {
    showSnackbar(
      context: context,
      message: message,
      duration: duration,
      backgroundColor: Colors.blue[700]!,
      textColor: Colors.white,
      actionLabel: actionLabel,
      onActionPressed: onActionPressed,
    );
  }
}
