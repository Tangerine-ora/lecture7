import 'package:flutter/material.dart';

/// 可复用分类入口卡片：文案、数量、图标与点击回调均由外部传入。
class CategoryCard extends StatelessWidget {
  final String label;
  final int count;
  final IconData icon;
  final VoidCallback onTap;

  const CategoryCard({
    super.key,
    required this.label,
    required this.count,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, size: 30, color: theme.colorScheme.primary),
              const Spacer(),
              Text(label, style: theme.textTheme.titleMedium),
              const SizedBox(height: 2),
              Text('$count 本', style: theme.textTheme.bodySmall),
            ],
          ),
        ),
      ),
    );
  }
}
