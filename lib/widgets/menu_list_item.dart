import 'package:flutter/material.dart';

class MenuListItem extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback? onTap;
  final Color? color;

  const MenuListItem({
    super.key,
    required this.title,
    required this.icon,
    this.onTap,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: color ?? Theme.of(context).iconTheme.color),
      title: Text(title, style: TextStyle(color: color)),
      trailing: (onTap != null) ? const Icon(Icons.chevron_right, color: Colors.grey) : null,
      onTap: onTap,
    );
  }
}
