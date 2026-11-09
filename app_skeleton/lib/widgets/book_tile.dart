import 'package:flutter/material.dart';

import '../models/book.dart';

/// 可复用列表项：数据（book）、点击行为（onTap）与长按行为（onLongPress）全部参数化。
class BookTile extends StatelessWidget {
  final Book book;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;

  const BookTile({
    super.key,
    required this.book,
    this.onTap,
    this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(child: Text('${book.id}')),
      title: Text(book.title),
      subtitle: Text('${book.author} · ${book.category}'),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (book.isPopular)
            const Icon(
              Icons.local_fire_department,
              size: 16,
              color: Colors.deepOrange,
            ),
          const SizedBox(width: 4),
          Text('${book.borrowCount}次'),
        ],
      ),
      onTap: onTap,
      onLongPress: onLongPress,
    );
  }
}
