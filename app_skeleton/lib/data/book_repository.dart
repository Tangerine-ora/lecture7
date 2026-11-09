import 'dart:convert';

import 'package:flutter/services.dart';

import '../models/book.dart';

/// 本地数据仓库：启动时一次性载入 assets/books.json，页面按需查询。
class BookRepository {
  BookRepository._();

  static final BookRepository instance = BookRepository._();

  List<Book> _books = const [];

  List<Book> get books => _books;

  bool get isLoaded => _books.isNotEmpty;

  Future<void> load() async {
    if (isLoaded) {
      return;
    }
    final raw = await rootBundle.loadString('assets/books.json');
    final list = jsonDecode(raw) as List<dynamic>;
    _books = list
        .map((e) => Book.fromJson(e as Map<String, dynamic>))
        .toList(growable: false);
  }

  /// 分类顺序按数据中首次出现的顺序返回，避免 Set 顺序不稳定。
  List<String> get categories {
    final result = <String>[];
    for (final book in _books) {
      if (!result.contains(book.category)) {
        result.add(book.category);
      }
    }
    return result;
  }

  List<Book> filter({String? category, bool onlyPopular = false}) {
    return _books
        .where((book) =>
            (category == null || book.category == category) &&
            (!onlyPopular || book.isPopular))
        .toList(growable: false);
  }

  int count({String? category, bool onlyPopular = false}) =>
      filter(category: category, onlyPopular: onlyPopular).length;

  /// 分页查询：offset 起点、limit 条数，返回空列表代表已经取完。
  List<Book> page({
    String? category,
    bool onlyPopular = false,
    int offset = 0,
    int limit = 20,
  }) {
    final matched = filter(category: category, onlyPopular: onlyPopular);
    if (offset >= matched.length) {
      return const [];
    }
    final end =
        (offset + limit) > matched.length ? matched.length : offset + limit;
    return matched.sublist(offset, end);
  }
}
