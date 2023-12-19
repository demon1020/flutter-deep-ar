import 'package:flutter/material.dart';
import '../theme/theme.dart';

showSnackBar({
  required BuildContext context,
  required String message,
  GlobalKey<ScaffoldState>? key,
  Duration? duration,
}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      duration: duration ?? Duration(milliseconds: 1500),
      width: MediaQuery.of(context).size.width - 20,
      behavior: SnackBarBehavior.floating,
      backgroundColor: AppTheme.primary,
      key: key,
      content: Text(
        message,
        textAlign: TextAlign.center,
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
    ),
  );
}
