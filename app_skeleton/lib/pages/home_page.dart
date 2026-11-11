import 'package:flutter/material.dart';

import '../data/book_repository.dart';
import '../models/list_page_args.dart';
import '../widgets/category_card.dart';

/// 首页：GridView 分类入口；从列表页返回的筛选结果展示在 AppBar 副标题。
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String? _returnedFilter;
  bool _onlyPopular = false;

  Future<void> _openList(String? category) async {
    final result = await Navigator.pushNamed(
      context,
      '/list',
      arguments: ListPageArgs(category: category, onlyPopular: _onlyPopular),
    );
    if (!mounted || result == null) {
      return;
    }
    setState(() {
      _returnedFilter = '回传：$result';
      _onlyPopular = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final repo = BookRepository.instance;
    final categories = <String?>[null, ...repo.categories];
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('书架首页'),
            Text(
              _returnedFilter ?? '选择分类进入书单',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            tooltip: '关于本页',
            onPressed: () => Navigator.pushNamed(context, '/about'),
            icon: const Icon(Icons.info_outline),
          ),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          // 宽屏下按可用宽度增加列数，避免卡片被拉得过高。
          final columns =
              (constraints.maxWidth / 300).floor().clamp(2, 5).toInt();
          return GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: columns,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 1.5,
            ),
            itemCount: categories.length,
            itemBuilder: (context, index) {
              final category = categories[index];
              final label = category ?? '全部书目';
              return CategoryCard(
                label: label,
                count: repo.count(category: category),
                icon: _iconOf(category),
                onTap: () => _openList(category),
              );
            },
          );
        },
      ),
    );
  }

  IconData _iconOf(String? category) {
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
        return Icons.apps;
    }
  }
}
