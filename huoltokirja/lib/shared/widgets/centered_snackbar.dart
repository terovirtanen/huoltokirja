import 'package:flutter/material.dart';

void showCenteredSnackBar(BuildContext context, String message) {
  final messenger = ScaffoldMessenger.of(context);
  final screenSize = MediaQuery.of(context).size;

  messenger.showSnackBar(
    SnackBar(
      content: Text(message, textAlign: TextAlign.center),
      behavior: SnackBarBehavior.floating,
      margin: EdgeInsets.fromLTRB(16, 0, 16, screenSize.height * 0.42),
    ),
  );
}