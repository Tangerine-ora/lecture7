import 'package:flutter/material.dart';

import '../models/book.dart';

/// 详情页：通过命名路由 + 强类型 arguments 接收 Book，返回时用 pop 带回值。
class DetailPage extends StatelessWidget {
  const DetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    // 命名路由统一约定：跳转方携带 Book 实例，这里按类型取出。
    final book = ModalRoute.of(context)!.settings.arguments as Book;
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('图书详情')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 28,
                        child: Icon(_iconOf(book.category), size: 28),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(book.title, style: theme.textTheme.titleLarge),
                            const SizedBox(height: 4),
                            Text(
                              '作者：${book.author}',
                              style: theme.textTheme.bodyMedium,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Wrap(
                    spacing: 8,
                    children: [
                      Chip(label: Text(book.category)),
                      Chip(label: Text('借阅 ${book.borrowCount} 次')),
                      Chip(label: Text('编号 #${book.id}')),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Text('内容简介', style: theme.textTheme.titleMedium),
                  const SizedBox(height: 8),
                  Text(book.summary, style: theme.textTheme.bodyLarge),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          FilledButton.icon(
            onPressed: () =>
                Navigator.pop(context, '已浏览《${book.title}》'),
            icon: const Icon(Icons.reply),
            label: const Text('返回并带回浏览结果'),
          ),
        ],
      ),
    );
  }

  IconData _iconOf(String category) {
    switch (category) {
      case '计算机':
        return Icons.computer;
      case '文学':
        return Icons.auto_stories;
      case '历史':
        return Icons.account_balance;
      case '科普':
        return Icons.science;
      default:
        return Icons.menu_book;
    }
  }
}
