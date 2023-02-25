import 'package:consus_erp/theme/app_theme.dart';
import 'package:flutter/material.dart';

class ExtendedButton extends StatelessWidget {
  final String text;
  final Widget? icon;
  final VoidCallback onTap;

  const ExtendedButton({required this.text, required this.onTap, this.icon, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
            color: AppTheme.shoppingManagerTheme.colorScheme.primary,
            borderRadius: BorderRadius.circular(10)),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              Text(
                text,
                style: TextStyle(color: Colors.white),
              ),
              if (icon != null) SizedBox(width: 10),
              if (icon != null) icon!,
            ],
          ),
        ),
      ),
    );
  }
}
