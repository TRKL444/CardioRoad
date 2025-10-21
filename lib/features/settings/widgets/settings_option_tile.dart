import 'package:flutter/material.dart';
import 'package:cardioroad/shared/themes/app_colors.dart';

class SettingsOptionTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;
  final Widget? trailing;

  const SettingsOptionTile({
    super.key,
    required this.icon,
    required this.title,
    required this.onTap,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: AppColors.primary),
      title: Text(title, style: const TextStyle(fontSize: 16)),
      trailing: trailing ??
          const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
      onTap: onTap,
    );
  }
}
