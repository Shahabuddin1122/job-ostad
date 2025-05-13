import 'package:flutter/material.dart';

Future<void> showCustomDialog({
  required BuildContext context,
  String? title,
  required String content,
  String confirmText = "OK",
  String cancelText = "Cancel",
  VoidCallback? onConfirm,
  VoidCallback? onCancel,
  bool showCancelButton = true,
  bool dismissible = true,
}) {
  return showDialog(
    context: context,
    barrierDismissible: dismissible,
    builder: (BuildContext context) {
      return AlertDialog(
        title: title != null ? Text(title) : null,
        content: Text(content),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        actions: [
          if (showCancelButton)
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                if (onCancel != null) onCancel();
              },
              child: Text(cancelText),
            ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              if (onConfirm != null) onConfirm();
            },
            child: Text(confirmText),
          ),
        ],
      );
    },
  );
}
