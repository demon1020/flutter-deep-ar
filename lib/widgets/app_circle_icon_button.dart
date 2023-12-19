
import 'package:flutter/material.dart';

import '../theme/theme.dart';

class AppCircleIconButton extends StatefulWidget {
  final VoidCallback onTap;
  final IconData iconData;

  const AppCircleIconButton({Key? key, required this.onTap, this.iconData = Icons.add}) : super(key: key);

  @override
  State<AppCircleIconButton> createState() => _AppCircleIconButtonState();
}

class _AppCircleIconButtonState extends State<AppCircleIconButton> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        height: 50,
        width: 50,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: AppTheme.primaryLight.withOpacity(0.5),
        ),
        child: Icon(
          widget.iconData,
          color: AppTheme.primaryDark,
        ),
      ),
    );
  }
}
