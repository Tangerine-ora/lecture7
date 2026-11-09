/// 书目数据模型：路由间传参统一使用该强类型对象，而不是 Map。
class Book {
  final int id;
  final String title;
  final String author;
  final String category;
  final int borrowCount;
  final String summary;

  const Book({
    required this.id,
    required this.title,
    required this.author,
    required this.category,
    required this.borrowCount,
    required this.summary,
  });

  factory Book.fromJson(Map<String, dynamic> json) {
    return Book(
      id: json['id'] as int,
      title: json['title'] as String,
      author: json['author'] as String,
      category: json['category'] as String,
      borrowCount: json['borrowCount'] as int,
      summary: json['summary'] as String,
    );
  }

  bool get isPopular => borrowCount >= BookRepositoryThreshold.popular;
}

/// 阈值集中在一处，列表页过滤与首页提示文案共用。
abstract final class BookRepositoryThreshold {
  static const int popular = 20;
}
