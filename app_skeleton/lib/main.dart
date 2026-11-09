import 'package:flutter/material.dart';

import 'data/book_repository.dart';
import 'models/list_page_args.dart';
import 'pages/detail_page.dart';
import 'pages/list_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await BookRepository.instance.load();
  runApp(const BookApp());
}

class BookApp extends StatelessWidget {
  const BookApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '书架骨架',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      initialRoute: '/',
      // 命名路由表：全应用跳转统一走 Navigator.pushNamed。
      routes: {
        '/': (_) => const ListPage(),
        '/list': (context) {
          final args = ModalRoute.of(context)!.settings.arguments;
          if (args is ListPageArgs) {
            return ListPage(
              category: args.category,
              onlyPopular: args.onlyPopular,
            );
          }
          return const ListPage();
        },
        '/detail': (_) => const DetailPage(),
      },
    );
  }
}
