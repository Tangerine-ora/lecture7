import 'package:flutter/material.dart';

import '../data/book_repository.dart';
import '../models/book.dart';
import '../widgets/book_tile.dart';

/// 列表页：ListView.builder 懒构建，配合“加载更多”模拟分页取数。
class ListPage extends StatefulWidget {
  final String? category;
  final bool onlyPopular;

  const ListPage({super.key, this.category, this.onlyPopular = false});

  @override
  State<ListPage> createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {
  static const int _pageSize = 20;

  final List<Book> _items = <Book>[];
  int _offset = 0;
  bool _hasMore = true;

  int get _total => BookRepository.instance.count(
        category: widget.category,
        onlyPopular: widget.onlyPopular,
      );

  @override
  void initState() {
    super.initState();
    _items.addAll(_fetch(0));
    _offset = _items.length;
    _hasMore = _offset < _total;
  }

  List<Book> _fetch(int offset) {
    return BookRepository.instance.page(
      category: widget.category,
      onlyPopular: widget.onlyPopular,
      offset: offset,
      limit: _pageSize,
    );
  }

  void _loadMore() {
    final next = _fetch(_offset);
    setState(() {
      _items.addAll(next);
      _offset += next.length;
      _hasMore = _offset < _total;
    });
  }

  @override
  Widget build(BuildContext context) {
    final title = widget.category == null ? '全部书目' : '${widget.category}书单';
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Center(
              child: Text(
                '已加载 ${_items.length}/$_total',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ),
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: _items.length + 1,
        itemBuilder: (context, index) {
          if (index == _items.length) {
            return _buildLoadMore(context);
          }
          final book = _items[index];
          return BookTile(
            book: book,
            onTap: () => _openDetail(book),
            onLongPress: () => _showQuickFilter(book),
          );
        },
      ),
    );
  }

  Future<void> _openDetail(Book book) async {
    final result = await Navigator.pushNamed(
      context,
      '/detail',
      arguments: book,
    );
    if (!mounted || result == null) {
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('详情页回传：$result')),
    );
  }

  /// 长按弹层选择筛选条件，选中后把结果 pop 回首页（回程传值验证）。
  Future<void> _showQuickFilter(Book book) async {
    final choice = await showModalBottomSheet<String>(
      context: context,
      builder: (sheetContext) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: Text('《${book.title}》快捷筛选'),
                subtitle: const Text('选择后返回首页并显示结果'),
              ),
              const Divider(height: 1),
              ListTile(
                leading: const Icon(Icons.filter_alt),
                title: Text(
                  '仅看高借阅量（≥${BookRepositoryThreshold.popular} 次）',
                ),
                onTap: () => Navigator.pop(
                  sheetContext,
                  '仅看高借阅量（≥${BookRepositoryThreshold.popular} 次）',
                ),
              ),
              ListTile(
                leading: const Icon(Icons.close),
                title: const Text('取消'),
                onTap: () => Navigator.pop(sheetContext),
              ),
            ],
          ),
        );
      },
    );
    if (!mounted || choice == null) {
      return;
    }
    Navigator.pop(context, choice);
  }

  Widget _buildLoadMore(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
      child: Column(
        children: [
          FilledButton.icon(
            onPressed: _hasMore ? _loadMore : null,
            icon: const Icon(Icons.expand_more),
            label: Text(
              _hasMore ? '加载更多（每次 20 条）' : '已加载全部 $_total 条',
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '当前已构建 ${_items.length} 个列表项，仅滚动区域内的项才会 build',
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
    );
  }
}
