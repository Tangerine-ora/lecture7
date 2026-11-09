import 'package:flutter/material.dart';

import '../data/book_repository.dart';
import '../models/book.dart';

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
          return ListTile(
            leading: CircleAvatar(child: Text('${book.id}')),
            title: Text(book.title),
            subtitle: Text('${book.author} · ${book.category}'),
            trailing: Text('${book.borrowCount}次'),
          );
        },
      ),
    );
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
