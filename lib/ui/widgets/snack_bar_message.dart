import 'package:flutter/material.dart';

void showSnackBarMessage(BuildContext context, String message, {bool isError = false}) {
  final snackBar = SnackBar(
    content: Row(
      children: [
        Icon(
          isError ? Icons.error_outline : Icons.check_circle_outline,
          color: Colors.white,
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            message,
            style: const TextStyle(fontSize: 16),
          ),
        ),
      ],
    ),
    backgroundColor: isError ? Colors.redAccent : Colors.green,
    behavior: SnackBarBehavior.floating,
    elevation: 10,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
    ),
    duration: const Duration(seconds: 3),
    animation: CurvedAnimation(
      parent: kAlwaysCompleteAnimation,
      curve: Curves.easeOut,
    ),
  );

  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}
