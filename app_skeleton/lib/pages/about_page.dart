import 'package:flutter/material.dart';

/// 关于页：第 4 条命名路由，用来验证路由表可扩展。
class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    const routes = [
      ('/', '首页（GridView 分类入口）'),
      ('/list', '列表页（ListView.builder + 分页）'),
      ('/detail', '详情页（Book 强类型参数）'),
      ('/about', '关于页（本页）'),
    ];
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('关于')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text('app_skeleton', style: theme.textTheme.headlineSmall),
          const SizedBox(height: 8),
          Text(
            '第 7 课可滚动组件与多页面结构示例：首页网格 → 列表 → 详情，'
            '全部跳转使用命名路由，参数为强类型对象。',
            style: theme.textTheme.bodyMedium,
          ),
          const SizedBox(height: 24),
          Text('命名路由表', style: theme.textTheme.titleMedium),
          const SizedBox(height: 8),
          for (final entry in routes)
            ListTile(
              dense: true,
              leading: const Icon(Icons.arrow_forward_ios, size: 14),
              title: Text(entry.$1),
              subtitle: Text(entry.$2),
            ),
        ],
      ),
    );
  }
}
